library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity clamp is
    Port ( clk, rst : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (31 downto 0);
           data_out : out STD_LOGIC_VECTOR (7 downto 0));
end clamp;

architecture Behavioral of clamp is
    signal temp : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
    signal notv : STD_LOGIC := '0';
    signal xored : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
begin
    gene0 :for i in 0 to 31 generate
        temp(i) <= data_in(31);
    end generate;
    
    notv <= not data_in(31);
    
    xored <= temp xor data_in;
    
    clamp: process(temp, data_in, clk, rst, notv) 
    begin 
        if rst = '1' then
            data_out <= (others => '0');
        elsif rising_edge(clk) then
            if xored >= x"0000007F" then 
                data_out(0) <= '1';
                data_out(7) <= temp(0);
                data_out(6 downto 1) <= (others => notv);
            else
                data_out <= data_in(7 downto 0); 
            end if; 
        end if;
    end process;
    
end Behavioral;
