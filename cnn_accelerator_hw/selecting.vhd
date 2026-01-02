library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity selecting is
    Port ( 
        clk, rst : in STD_LOGIC;
        --choose   : in STD_LOGIC;
        sel : in STD_LOGIC_VECTOR (2 downto 0);
        my_buff : in STD_LOGIC_VECTOR (127 downto 0);
        selected : out STD_LOGIC_VECTOR (71 downto 0)
    );
end selecting;

architecture Behavioral of selecting is
    signal shift : integer range 0 to 31;
    signal temp : std_logic_vector(71 downto 0) := (others => '0');
begin

    process(clk, rst)
    begin
        if rst = '1' then
            selected <= (others => '0');
        elsif rising_edge(clk) then
            selected <= temp;
        end if; 
    end process;
    
    process(my_buff, sel)
    begin
            case sel is
                when "000" =>
                    temp <= my_buff(71 downto 0);
                when "001" =>
                    temp <= my_buff(79 downto 8);
                when "010" =>
                    temp <= my_buff(87 downto 16);
                when "011" =>
                    temp <= my_buff(95 downto 24);
                when "100" =>
                    temp <= my_buff(103 downto 32);
                when "101" =>
                    temp <= my_buff(111 downto 40);
                when "110" =>
                    temp <= my_buff(119 downto 48);
                when "111" =>
                    temp <= my_buff(127 downto 56);
                when others =>
                    temp <= (others => '0');  
            end case;
    end process;

            
end Behavioral;