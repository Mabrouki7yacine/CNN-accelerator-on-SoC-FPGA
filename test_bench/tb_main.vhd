library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_main is
    -- Testbench has no ports
end tb_main;

architecture Behavioral of tb_main is

    ------------------------------------------------------------------------
    -- Component Declaration: Device Under Test (DUT)
    ------------------------------------------------------------------------
    component main
        Port ( 
        clk       : in  STD_LOGIC;
        enable    : in  STD_LOGIC;
        done      : out STD_LOGIC_VECTOR(1 downto 0);
        ten       : out STD_LOGIC_VECTOR(71 downto 0);
        ac        : out STD_LOGIC_VECTOR(9 downto 0);
        we        : in  STD_LOGIC_VECTOR(3 downto 0);
        --axi_gpio  : in  STD_LOGIC_VECTOR(12 downto 0);
        entemp    : in  STD_LOGIC_VECTOR(4 downto 0);
        start     : in  STD_LOGIC;
        acc       : in  STD_LOGIC;
        rst       : in  STD_LOGIC;
        arrange   : in  STD_LOGIC;
        --address   : in  STD_LOGIC_VECTOR(12 downto 0);
        address   : in  STD_LOGIC_VECTOR(9 downto 0);
        write     : in  STD_LOGIC_VECTOR(31 downto 0);
        read      : out STD_LOGIC_VECTOR(31 downto 0)
    );
    end component;

    ------------------------------------------------------------------------
    -- Signals
    ------------------------------------------------------------------------
    signal clk        : STD_LOGIC := '0';
    signal last_done  : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');

    signal we         : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal enable     : STD_LOGIC := '0';

    signal addr       : STD_LOGIC_VECTOR(12 downto 0) := (others => '0');
    signal write      : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal read       : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal ten       : STD_LOGIC_VECTOR(71 downto 0) := (others => '0');
    signal ac       : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');

    signal axi_gpio   : STD_LOGIC_VECTOR(12 downto 0) := (others => '0');

    constant clk_period : time := 10 ns;

begin

    ------------------------------------------------------------------------
    -- Instantiate DUT
    ------------------------------------------------------------------------
    uut: main
        Port map (
            clk       => clk,
            enable    => enable,
            done      => last_done,
            ten       => ten,
            ac        => ac,
            we        => we,
            entemp    => axi_gpio(4 downto 0),
            start     => axi_gpio(5),
            acc       => axi_gpio(6),
            rst       => axi_gpio(7),
            arrange   => axi_gpio(12),
            address   => addr(9 downto 0),
            write     => write,
            read      => read
        );

    ------------------------------------------------------------------------
    -- Clock Generation
    ------------------------------------------------------------------------
    clk_gen: process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process clk_gen;

    ------------------------------------------------------------------------
    -- Stimulus Process
    ------------------------------------------------------------------------
    stim_proc: process
    begin
        --wait for 300 ns;

        --------------------------------------------------------------------
        -- Reset
        --------------------------------------------------------------------
        axi_gpio(12) <= '0';
        axi_gpio(7)  <= '1'; wait for 2 * clk_period;
        axi_gpio(7)  <= '0'; wait for clk_period;

        --axi_gpio(12) <= '1';
        --wait for 1 * clk_period;
        --axi_gpio(12) <= '0';
        --wait until last_done(1) = '1';
        --wait for 2 * clk_period;        
        
        --------------------------------------------------------------------
        -- First Write Sequence
        --------------------------------------------------------------------
        enable <= '1'; we <= "1111";
        --enable <= '0'; we <= "0000";

        -- Write tensor values
        for i in 0 to 4 loop
            addr <= "000"&"0000000000";
            axi_gpio(4 downto 0) <= std_logic_vector(to_unsigned(i, 5));

            case i is
                when 0 => write <= X"01010101";
                when 1 => write <= X"01010101";
                when 2 => write <= X"02010001";
                when 3 => write <= X"06050403";
                when 4 => write <= X"00000807";
                when others => null;
            end case;

            wait for clk_period;
        end loop;

        -- Write weight values
        for i in 18 to 20 loop
            addr <= "000"&"0000000000";
            axi_gpio(4 downto 0) <= std_logic_vector(to_unsigned(i, 5));

            case i is
                when 18 => write <= X"01040002";
                when 19 => write <= X"06030305";
                when 20 => write <= X"00000001";
                when others => null;
            end case;

            wait for clk_period;
        end loop;

        --------------------------------------------------------------------
        -- Run Model
        --------------------------------------------------------------------
        enable <= '0'; we <= "0000";
        axi_gpio(7) <= '1'; wait for clk_period;
        axi_gpio(7) <= '0'; wait for clk_period;
        axi_gpio(6) <= '0'; -- Accumulate
        axi_gpio(5) <= '1'; wait for clk_period;
        axi_gpio(5) <= '0';
        wait until last_done(0) = '1';
        axi_gpio(12) <= '1';
        wait for 1 * clk_period;
        axi_gpio(12) <= '0';
        wait until last_done(1) = '1';

        -- Final Read
        addr <= "000"&"0000000000";
        axi_gpio(4 downto 0) <= "10101";
        wait for 5 * clk_period;

        --------------------------------------------------------------------
        -- Second Write Sequence
        --------------------------------------------------------------------
        enable <= '1'; we <= "1111";
        --enable <= '0'; we <= "0000";

        for i in 0 to 4 loop
            addr <= "000"&"0000000000";
            axi_gpio(4 downto 0) <= std_logic_vector(to_unsigned(i, 5));

            case i is
                when 0 => write <= X"01ffff00";
                when 1 => write <= X"01010101";
                when 2 => write <= X"01010101";
                when 3 => write <= X"01010101";
                when 4 => write <= X"00000101";
                when others => null;
            end case;

            wait for clk_period;
        end loop;

        --------------------------------------------------------------------
        -- Second Run
        --------------------------------------------------------------------
        enable <= '0'; we <= "0000";
        axi_gpio(7) <= '1'; wait for clk_period;
        axi_gpio(7) <= '0'; wait for clk_period;
        axi_gpio(6) <= '0'; -- Accumulate
        axi_gpio(5) <= '1'; wait for clk_period;
        axi_gpio(5) <= '0';
        wait until last_done(0) = '1';
        axi_gpio(12) <= '1';
        wait for 1 * clk_period;
        axi_gpio(12) <= '0';
        wait until last_done(1) = '1';

        -- Final Read Again
        addr <= "000"&"0000000000";
        axi_gpio(4 downto 0) <= "10101";
        wait for 5 * clk_period;

        --------------------------------------------------------------------
        -- End Simulation
        --------------------------------------------------------------------
        wait;
    end process stim_proc;

end Behavioral;
