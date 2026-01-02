library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;
Library UNIMACRO;
use UNIMACRO.vcomponents.all;

entity PE_blocks is
    Port ( clk, ce, rst : in STD_LOGIC;
           we, acc : in STD_LOGIC;
           en: in STD_LOGIC_VECTOR(17 DOWNTO 0);
           addr_a, addr_b : in STD_LOGIC_VECTOR(9 DOWNTO 0); 
           wr : in STD_LOGIC_VECTOR(31 DOWNTO 0); 
           tensor : in STD_LOGIC_VECTOR(71 DOWNTO 0); 
           divi : in STD_LOGIC_VECTOR(3 DOWNTO 0); 
           test : out STD_LOGIC_VECTOR(71 DOWNTO 0); 
           DataOut : out STD_LOGIC_VECTOR(63 DOWNTO 0));
end PE_blocks;

architecture Behavioral of PE_blocks is
    signal enb : std_logic :='0';
    signal ts  : std_logic_vector(575 DOWNTO 0);
    signal nca : std_logic_vector(1151 DOWNTO 0);
    signal ncb : std_logic_vector(1151 DOWNTO 0);
    signal wea : std_logic_vector(3 DOWNTO 0) := X"0";
    signal web : std_logic_vector(7 DOWNTO 0) := X"00";
    signal address_a, address_b : std_logic_vector(15 DOWNTO 0);
    signal out_mat : std_logic_vector(63 DOWNTO 0) := (others =>'0');

begin

    address_a <= '0' & addr_a & "00000";
    address_b <= '0' & addr_b & "00000";
    
    web <= (others => we);

    gen_BRAM_tensor: for i in 0 to 17 generate
        BRAM_input: entity work.BRAM
        port map(
            CLKA    => clk,      
            ENA     => ce,       
            REGCEA  => '1',      
            RSTREGA => '0',      
            CLKB    => clk,      
            ENB     => en(i),      
            REGCEB  => '1',      
            RSTREGB => '0',      
            WEA     => wea,      
            WEB     => web,      
            ADDRA   => address_a,
            ADDRB   => address_b,
            DIA     => nca((i+1)*32-1 downto i*32),      
            DIB     => wr,     
            DOA     => ts((i+1)*32-1 downto i*32),   
            DOB     => ncb((i+1)*32-1 downto i*32)       
        );   
    end generate;
    test <= ts(71 downto 0);
    gen_PE: for i in 0 to 7 generate
        PE_0: entity work.my_pe_sign
        port map(
            clk => clk,
            acc => acc,
            ce => ce,
            rst => rst,
            div => divi,
            weight => tensor,
            in_mat => ts((i+1)*72-1 downto i*72),
            out_mat => DataOut((i+1)*8-1 downto i*8));  
    end generate;

end Behavioral;