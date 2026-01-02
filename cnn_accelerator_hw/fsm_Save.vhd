library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;

entity fsm_Save is
    Port (
        ce       : out STD_LOGIC;
        we       : out STD_LOGIC;
        clk      : in  STD_LOGIC;
        acc      : in  STD_LOGIC;
        rst      : in  STD_LOGIC;
        start    : in  STD_LOGIC;
        done     : out STD_LOGIC;
        asave    : out STD_LOGIC_VECTOR(9 downto 0);
        max_add  : in  STD_LOGIC_VECTOR(9 downto 0));
end fsm_Save;

architecture Behavioral of fsm_Save is
    signal state     : integer range 0 to 7 := 0;
    signal waiting   : integer range 0 to 15 := 0;
    signal count     : integer range 0 to 1023 := 0;
    signal addr_save : std_logic_vector(9 downto 0) := (others => '1');

begin

    asave <= addr_save;

    process(clk, rst)
    begin
        if rst = '1' then
            state <= 0;
        elsif rising_edge(clk) then
        
            if acc = '0' then
                waiting <= 7;
            else
                waiting <= 8;
            end if;
            
            case state is
                when 0 =>
                    -- Wait for start signal
                    done <= '0';
                    addr_save <= (others => '1');
                    if start = '1' then
                        state <= 1;
                        count <= 0;
                    end if;

                when 1 =>
                    --done <= '0';
                    if count < waiting then
                        count <= count + 1;
                    else
                        state <= 2;
                        count <= 0;
                    end if;

                when 2 =>
                    done <= '0';
                    if count <= to_integer(unsigned(max_add)) then
                        addr_save <= std_logic_vector(to_unsigned(count, addr_save'length));
                        count <= count + 1;
                    else
                        state <= 3; -- Move to done state
                        done <= '1';
                    end if;

                when 3 =>
                    state <= 3;
                    done <= '0';
                    count <= 0;
                    addr_save <= (others => '1');

                when others =>
                    done <= '0';
                    state <= 0;
            end case;
        end if;
    end process;

    process(clk, state)
    begin
        if rising_edge(clk) then
            case state is
                when 0 =>
                    ce <= '0';
                    we <= '0';
                when 1 =>
                    ce <= '0';
                    we <= '0';
                when 2 =>
                    ce <= '1';
                    we <= '1';
                when 3 =>
                    ce <= '0';
                    we <= '0';
                when others =>
                    ce <= '0';
                    we <= '0';
            end case;
        end if;
    end process;

end Behavioral;
