library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dequant is
    Port ( a : in STD_LOGIC_VECTOR (31 downto 0);
           b : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           c : out STD_LOGIC_VECTOR (31 downto 0));
end dequant;

architecture Behavioral of dequant is
signal shift : integer;
signal temp  : STD_LOGIC_VECTOR (7 downto 0);
signal samet  : STD_LOGIC_VECTOR (23 downto 0);
signal bbxL  : integer range 0 to 31 := 0 ;
signal bbxH  : integer range 0 to 31 := 7 ;
begin

process(clk, rst)
begin
    if rst = '1' then
         c <= (others => '0');
    elsif rising_edge(clk) then
            --c(7 downto 0) <= a(bbxH downto bbxL);
            c(31 - to_integer(unsigned(b)) downto 0) <= a(31 downto to_integer(unsigned(b)));
            c(31 downto 32 - to_integer(unsigned(b))) <= (others => a(31));
    end if; 
end process;
   

end Behavioral;

