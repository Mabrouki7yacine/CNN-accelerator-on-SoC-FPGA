library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;
Library UNIMACRO;
use UNIMACRO.vcomponents.all;

entity my_pe_sign is
    Port ( clk,ce : in STD_LOGIC;
           acc,rst : in STD_LOGIC;
           weight : in STD_LOGIC_VECTOR (71 downto 0);       
           in_mat : in STD_LOGIC_VECTOR (71 downto 0);           
           div : in STD_LOGIC_VECTOR (3 downto 0);           
           out_mat : out STD_LOGIC_VECTOR (7 downto 0));
end my_pe_sign;

architecture Behavioral of my_pe_sign is

type array_S0 is array (0 to 7) of std_logic_vector(16 downto 0);
type array_S1_in  is array (0 to 3) of std_logic_vector(16 downto 0);
type array_S2_in  is array (0 to 1) of std_logic_vector(17 downto 0);
type array_S1_out is array (0 to 4) of std_logic_vector(17 downto 0);
type array_S2_out is array (0 to 1) of std_logic_vector(18 downto 0);

signal add_S0 : array_S0  := (others => (others => '0'));
signal add_S1 : array_S1_in  := (others => (others => '0'));
signal add_S2 : array_S2_in  := (others => (others => '0'));
signal add_S1_out : array_S1_out  := (others => (others => '0'));
signal add_S2_out : array_S2_out  := (others => (others => '0'));
signal add_S3 : STD_LOGIC_VECTOR (18 downto 0):= (others =>'0');
signal last_add_0, last_add_1 : STD_LOGIC_VECTOR (19 downto 0):= (others =>'0');
signal result, dataout_reg, temp_out, dequant_res : STD_LOGIC_VECTOR (31 downto 0):= (others =>'0');
signal reg_S1, reg_S2, reg_S3 : STD_LOGIC_VECTOR (15 downto 0):= (others =>'0');
signal mult_out : STD_LOGIC_VECTOR (143 downto 0):= (others =>'0');

begin

----------------------------------------------------------------------------------------------------
    -- multiplication stage
    gen_mult: for i in 0 to 8 generate
        mult_inst: entity work.mult
        generic map (
            ARCH_TYPE => 1  -- Correct assignment
        )
        port map(
            in_mat => in_mat((i+1)*8-1 downto i*8),
            weight => weight((i+1)*8-1 downto i*8),
            clk => clk,
            ce => ce,
            rst => rst,
            mat_out => mult_out((i+1)*16-1 downto i*16));
    end generate;

----------------------------------------------------------------------------------------------------    
    -- addition stage 0

    gen_assign_input_S0: for i in 0 to 7 generate
        add_S0(i) <= mult_out((i+1)*16-1) & mult_out((i+1)*16-1 downto i*16);
    end generate;

    gen_add_S1: for i in 0 to 3 generate
        add_inst_S1: entity work.adder
            generic map (
                WIDTH => 17
            )
            port map(
                a => add_S0(2*i),
                b => add_S0(2*i +1),
                c => add_S1(i),
                rst => rst,
                clk => clk,
                ce => ce );
    end generate;   
    
    reg_inst_S1: entity work.reg
        generic map (
            WIDTH => 16
        )
        port map(
            i => mult_out(143 downto 128),
            o => reg_S1,
            rst => rst,
            clk => clk  
        );

----------------------------------------------------------------------------------------------------
    -- addition stage 1
    gen_assign_input_S1: for i in 0 to 3 generate
        add_S1_out(i) <= add_S1(i)(16) & add_S1(i);
    end generate;

    gen_add_S2: for i in 0 to 1 generate
        add_inst_S2: entity work.adder
            generic map (
                WIDTH => 18
            )
            port map(
                a => add_S1_out(2*i),
                b => add_S1_out(2*i +1),
                c => add_S2(i),
                clk => clk,
                rst => rst,
                ce => ce );
    end generate;

    reg_inst_S2: entity work.reg
    generic map (
        WIDTH => 16
    )
    port map(
        i => reg_S1,
        o => reg_S2,
        rst => rst,
        clk => clk  
    );

----------------------------------------------------------------------------------------------------
    -- addition stage 2

    gen_assign_input_S2: for i in 0 to 1 generate
        add_S2_out(i) <= add_S2(i)(17) & add_S2(i);
    end generate;

    add_inst_S3: entity work.adder
        generic map (
            WIDTH => 19
        )
        port map(
            a => add_S2_out(0),
            b => add_S2_out(1),
            c => add_S3,
            rst => rst,
            clk => clk,
            ce => ce );
        
    reg_inst_S3: entity work.reg
            generic map (
                WIDTH => 16
            )
            port map(
                i => reg_S2,
                o => reg_S3,
                rst => rst,
                clk => clk );
                
----------------------------------------------------------------------------------------------------
    -- addition stage 3
    last_add_0 <= reg_S3(15) & reg_S3(15) & reg_S3(15) & reg_S3(15) & reg_S3;
    last_add_1 <= add_S3(18) & add_S3;

    add_inst_S4: entity work.adder
        generic map (
            WIDTH => 20
        )
        port map(
            a => last_add_0,
            b => last_add_1,
            c => result(19 downto 0),
            rst => rst,
            clk => clk,
            ce => ce );

    gene0 :for i in 20 to 31 generate
        result(i) <= result(19);
    end generate;
    
----------------------------------------------------------------------------------------------------
    -- accumulation
    process(clk, dataout_reg, rst ,result)
    begin
        if rst = '1' then
            dataout_reg <= (others => '0');  -- Reset output to zero
        elsif rising_edge(clk) then
            -- Only accumulate if 'ce' and are asserted
            if ce = '1' then
                -- Accumulate out_mat into dataout_reg
                dataout_reg <= std_logic_vector(signed(dataout_reg) + signed(result));
            end if;
        end if;
    end process;
    
    --dataout <= out_mat; 
    mux: process(acc, result, dataout_reg) 
    begin 
        if acc = '1' then 
            temp_out <= dataout_reg;
        else
            temp_out <= result; 
        end if; 
    end process;

----------------------------------------------------------------------------------------------------
    dequantization: entity work.dequant
    port map(
            clk => clk,
            rst => rst,
            a => temp_out,
            b => div,
            c => dequant_res
    );
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
    clipping: entity work.clamp
    port map(
            clk => clk,
            rst => rst,
            data_in => dequant_res,
            data_out => out_mat
    );
    
----------------------------------------------------------------------------------------------------
end Behavioral;