library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder is
    generic (
        WIDTH : integer --:= 8 Default width is 8 bits
    );
    Port ( a   : in STD_LOGIC_VECTOR (WIDTH-1 downto 0);
           b   : in STD_LOGIC_VECTOR (WIDTH-1 downto 0);
           c   : out STD_LOGIC_VECTOR (WIDTH-1 downto 0);
           clk : in STD_LOGIC;
           ce  : in STD_LOGIC;
           rst : in STD_LOGIC  -- New reset signal
    );
end adder;

architecture Behavioral of adder is
signal temp_a : unsigned (WIDTH-1 downto 0) := (others =>'0');
signal temp_b : unsigned (WIDTH-1 downto 0) := (others =>'0');
signal temp_c : unsigned (WIDTH-1 downto 0) := (others =>'0');
begin

    temp_c <= unsigned(a) + unsigned(b);

    process(clk, rst)
    begin
        if rst = '1' then
            c <= (others => '0');  -- Reset output to zero
        elsif rising_edge(clk) then
            if ce = '1' then
                c <= std_logic_vector(temp_c);  -- Perform addition when `ce` is asserted
            end if;
        end if;
    end process;

end Behavioral;
