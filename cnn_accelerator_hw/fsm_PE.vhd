library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;

entity fsm_PE is
    Port ( 
        ce       : out STD_LOGIC;
        clk      : in  STD_LOGIC;
        acc      : in  STD_LOGIC;
        rst      : in  STD_LOGIC;
        --done     : out STD_LOGIC;
        start    : in  STD_LOGIC;
        actrl    : out STD_LOGIC_VECTOR(9 downto 0);
        max_add  : in  STD_LOGIC_VECTOR(9 downto 0));
end fsm_PE;

architecture Behavioral of fsm_PE is
    signal done : STD_LOGIC := '0';
    signal state : integer range 0 to 3 := 0;
    signal timer : integer range 0 to 7 := 0;
    signal count : integer range 0 to 1023 := 0;
    signal waiting : integer range 0 to 15 := 0;
    signal addr_ctrl : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
begin

    actrl <= addr_ctrl;

    process(clk, rst)
    begin
        if rst = '1' then
            state <= 0;
        --    count <= 0;
        --    timer <= 0;
        elsif rising_edge(clk) then
        
            if acc = '0' then
                waiting <= 7;
            else
                waiting <= 8;
            end if;
            
            case state is
                when 0 =>
                    done <= '0';
                    ce <= '0';
                    timer <= 0;
                    addr_ctrl <= (others => '1');
                    if start = '1' then
                        ce <= '0';
                        state <= 1;
                        count <= 0;
                    end if;

                when 1 =>
                    done <= '0';
                    ce  <= '1';
                    if count <= to_integer(unsigned(max_add)) then
                        addr_ctrl <= std_logic_vector(to_unsigned(count, addr_ctrl'length));
                        count <= count + 1;
                    else
                        state <= 2;
                        --count <= 0;
                        --addr_ctrl <= (others => '1');
                    end if;

                when 2 =>
                    done <= '0';
                    count <= 0;
                    --addr_ctrl <= (others => '1');
                    if timer < waiting then
                        timer <= timer + 1;
                    else
                        state <= 3;
                        done <= '1';
                        ce <= '0';
                        count <= 0;
                    end if;
                    
                when 3 =>
                    timer <= 0;
                    state <= 3;
                    done <= '0';
                    count <= 0;
                    ce <= '0';
                    addr_ctrl <= (others => '1');

                when others =>
                    done <= '0';
                    state <= 0;
            end case;
        end if;
    end process;
        
end Behavioral;