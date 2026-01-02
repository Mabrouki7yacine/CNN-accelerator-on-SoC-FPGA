library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg is
    generic (
        WIDTH : integer --:= 7  -- Default width is 8 bits
    );
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;  -- Add reset signal
           i   : in STD_LOGIC_VECTOR (WIDTH-1 downto 0);
           o   : out STD_LOGIC_VECTOR (WIDTH-1 downto 0));
end reg;

architecture Behavioral of reg is
signal temp : STD_LOGIC_VECTOR (WIDTH-1 downto 0) := (others =>'0');
begin
process(clk, rst)
begin 
    if rst = '1' then
        temp <= (others => '0');  -- Reset to zero
    elsif rising_edge(clk) then
        temp <= i;
    end if; 
end process; 
o <= temp;
end Behavioral;
