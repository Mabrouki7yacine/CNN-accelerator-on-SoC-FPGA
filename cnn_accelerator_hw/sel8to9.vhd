library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;

entity sel8to9 is
  Port (clk          : in  std_logic;
        rst          : in  std_logic;
        launch       : in  std_logic;
        done         : out std_logic;
        ce           : in  std_logic;
        en_res       : in  std_logic;
        ce_save      : in  std_logic;
        we_save      : in  std_logic_vector(07 downto 0);
        we           : in  std_logic_vector(03 downto 0);
        enctrl       : in  std_logic_vector(02 downto 0);
        maxaddr      : in  std_logic_vector(09 downto 0);
        address      : in  std_logic_vector(15 downto 0);
        address_save : in  std_logic_vector(15 downto 0);
        address_ctrl : in  std_logic_vector(15 downto 0);
        result       : in  std_logic_vector(63 downto 0);
        write        : in  std_logic_vector(31 downto 0);
        read_temp    : out std_logic_vector(63 downto 0);
        tensor       : out std_logic_vector(71 downto 0));
end sel8to9;

architecture Behavioral of sel8to9 is
    type state_type is (IDLE, SABR1, SABR2, SABR3, INIT, STATE, FINISH);
    signal current_state, next_state : state_type;

    signal address_write : std_logic_vector(9 DOWNTO 0):= (others => '0');
    signal address_read  : std_logic_vector(9 DOWNTO 0):= (others => '0');
    signal addr_write    : std_logic_vector(9 DOWNTO 0):= (others => '0');
    signal addr_bram_out : std_logic_vector(15 DOWNTO 0):= (others => '0');
    signal addr_bram_in  : std_logic_vector(15 DOWNTO 0):= (others => '0');

    signal my_buff  : std_logic_vector(127 DOWNTO 0) := (others => '0');
    signal selected : std_logic_vector(71 DOWNTO 0):= (others => '0');  
    signal resultat : std_logic_vector(63 DOWNTO 0):= (others => '0');

    signal wein  : std_logic_vector(3 DOWNTO 0):= (others => '0');    
    signal enin  : std_logic_vector(2 DOWNTO 0):= (others => '0');    
    signal enout : std_logic := '0';

    signal data_in     : std_logic_vector(95 DOWNTO 0):= (others => '0');
    signal write_in    : std_logic_vector(95 DOWNTO 0):= (others => '0');
    signal tensor_temp : std_logic_vector(95 DOWNTO 0):= (others => '0');

    signal nca : std_logic_vector(95 DOWNTO 0):= (others => '0');
    signal ncb : std_logic_vector(95 DOWNTO 0):= (others => '0');
    signal ncc : std_logic_vector(63 DOWNTO 0):= (others => '0');
    signal ncd : std_logic_vector(63 DOWNTO 0):= (others => '0');

    signal sel      : std_logic_vector(03 DOWNTO 0):= (others => '0');
    signal sel_out  : std_logic_vector(02 DOWNTO 0):= (others => '0');
    signal write_en : std_logic := '0';
    signal read_en  : std_logic := '0';
    signal rst_fsm  : std_logic := '0';
    signal choose   : std_logic := '0';
    signal clkb     : std_logic := '0';
    signal clka     : std_logic := '0';
    signal move     : std_logic := '0';

begin
        
    --process(choose, selected, clk)
    --begin
        
        --if rising_edge(clk) and choose = '1' then
            --data_in <= x"000000" & selected;
        --else 
            --data_in <= (others => '0');
        --end if;
    --end process;
    
    data_in <= x"000000" & selected;
    
    --process(clk, choose, address_read, read_en, clk, addr_write, write_en, data_in, address, en_res, we, enctrl, write)
    process(clk)
    begin
    if rising_edge(clk) then
        if choose = '1' then 
            -- FSM result output mode
            addr_bram_out <= '0' & address_read & "00000";
            enout         <= read_en;
            --clkb          <= not clk;
            wein          <= (others => write_en);
            addr_bram_in  <= '0' & addr_write & "00000";
            enin          <= (others => write_en);
            write_in      <= data_in;
        else
            -- PS control mode
            addr_bram_out <= address;
            enout         <= en_res;
            --clkb          <= clk;
            wein          <= we;
            addr_bram_in  <= address;
            enin          <= enctrl;
            write_in      <= write & write & write;
        end if;
    end if;
    end process;


    gen_BRAM_input: for i in 0 to 2 generate
    BRAM_input: entity work.BRAM
    port map(
        CLKA    => clk,
        ENA     => enin(i), -- here we change
        REGCEA  => '1',
        RSTREGA => '0',
        CLKB    => clk,
        ENB     => ce,
        REGCEB  => '1',
        RSTREGB => '0',
        WEA     => wein, -- here we change
        WEB     => x"00",
        ADDRA   => addr_bram_in, -- here we change
        ADDRB   => address_ctrl,
        DIA     => write_in((i+1)*32-1 downto i*32),
        DIB     => nca((i+1)*32-1 downto i*32),
        DOA     => ncb((i+1)*32-1 downto i*32),
        DOB     => tensor_temp((i+1)*32-1 downto i*32)); 
    end generate;
    tensor <= tensor_temp(71 downto 0);

    gen_BRAM_output: for i in 0 to 1 generate
    BRAM_output: entity work.BRAM
    port map(
        CLKA    => clk,      
        ENA     => enout, -- here we change       
        REGCEA  => '1',
        RSTREGA => '0',
        CLKB    => clk,      
        ENB     => ce_save, 
        REGCEB  => '1',
        RSTREGB => '0',
        WEA     => x"0",
        WEB     => we_save,   
        ADDRA   => addr_bram_out, -- here we change 
        ADDRB   => address_save,
        DIA     => ncc((i+1)*32-1 downto i*32),      
        DIB     => result((i+1)*32-1 downto i*32),
        DOA     => resultat((i+1)*32-1 downto i*32),
        DOB     => ncd((i+1)*32-1 downto i*32)
    );
    end generate;
    read_temp <= resultat;

    process(clk, rst, address_write)
    begin 
        if rst = '1' then
            addr_write <= (others => '0');
        elsif rising_edge(clk) then
            addr_write <= address_write;
        end if; 
    end process; 
    
    
    my_buff(127 downto 64) <= resultat;
    
    process(clk, rst_fsm, my_buff, move)
    begin 
        if rst_fsm = '1' then
            my_buff(63 downto 0) <= (others => '0');
        elsif rising_edge(clk) and move = '1' then
            my_buff(63 downto 0) <= my_buff(127 downto 64);
        end if; 
    end process; 
    
    take_9_byte: entity work.selecting
    port map(
        clk => clk,
        rst => rst,
        my_buff => my_buff,
        sel => sel_out,
        selected => selected  
    );
    
    sel_out <= sel(2 downto 0);
    
    process(clk, rst)
    begin
        if rst = '1' then
            current_state <= IDLE;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

  -- State Machine Control ----------------------------------------------------
    process(current_state, launch, address_read, maxaddr,sel)
    begin
        next_state <= current_state;
        case current_state is
            when IDLE =>
                if launch = '1' then
                    next_state <= INIT;
                else
                    next_state <= IDLE;
                end if;
                           
            when INIT =>
                next_state <= SABR1;
            
            when SABR1 =>
                next_state <= SABR2;
            
            when SABR2 =>
                next_state <= STATE;
                
            when SABR3 =>
                next_state <= STATE;
                                
            when STATE =>
                if unsigned(address_read) > unsigned(maxaddr)+1 then
                    next_state <= FINISH;
                --elsif sel >= "0111" then
                elsif sel >= "0111" and sel <= "1110" then
                    --sel <= "0000";
                    next_state <= SABR3; 
                else
                    next_state <= STATE; 
                end if;            

            when FINISH =>
                    next_state <= IDLE;
            
            when others =>
                next_state <= IDLE;
        end case;
    end process;
        
    
    process(clk)
    begin
        if rising_edge(clk) then
            done <= '0';  -- Default done to '0'
            case current_state is
                when IDLE =>
                address_read  <= (others => '0');
                address_write <= (others => '0');
                done    <= '0';
                choose  <= '0';
                move    <= '0';
                read_en <= '0';
                write_en<= '0';
                rst_fsm <= '1';
                sel <= "0000";
                    
                when INIT =>
                done    <= '0';
                choose  <= '1';
                move    <= '1';
                read_en <= '1';
                write_en<= '0';
                rst_fsm <= '0';
                address_write  <= (others => '1');
                sel <= "0000";
                
                when SABR1 =>
                move <= '1';
                rst_fsm <= '0';
                read_en <= '1';
                write_en<= '0';
                choose  <= '1';
                address_read  <= std_logic_vector(unsigned(address_read) + 1);
                --sel <= "0000";
                sel <= "1111";

                when SABR2 =>
                move <= '1';
                rst_fsm <= '0';
                read_en <= '1';
                write_en<= '1';
                choose  <= '1';
                address_read  <= std_logic_vector(unsigned(address_read) + 1);
                sel <= "1111";
                
                when SABR3 =>
                move <= '1';
                rst_fsm <= '0';
                read_en <= '1';
                write_en<= '1';
                choose  <= '1';
                address_read  <= std_logic_vector(unsigned(address_read) + 1);
                sel <= "0000";
                
                when STATE =>
                move <= '1';
                rst_fsm <= '0';
                read_en <= '1';
                write_en<= '1';
                choose  <= '1';
                address_write <= std_logic_vector(unsigned(address_write) + 1);
                sel           <= std_logic_vector(unsigned(sel) + 1);
                address_read  <= std_logic_vector(unsigned(address_read) + 1);

                when FINISH =>
                done   <= '1';
                read_en <= '0';
                write_en<= '0';
                choose <= '0';
                move <= '0';
                rst_fsm <= '1';
                
                when others =>
            end case;     
        end if;
    end process;



end Behavioral;
