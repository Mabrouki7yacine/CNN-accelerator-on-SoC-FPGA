library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;
Library UNIMACRO;
use UNIMACRO.vcomponents.all;

entity main is
    generic (
        G_MAX_ADD : integer := 3  -- default value
    );
    Port ( 
        clk       : in  STD_LOGIC;
        enable    : in  STD_LOGIC;
        done      : out STD_LOGIC_VECTOR(1 downto 0);
        --ten       : out STD_LOGIC_VECTOR(71 downto 0);
        --ac        : out STD_LOGIC_VECTOR(9 downto 0);
        we        : in  STD_LOGIC_VECTOR(3 downto 0);
        axi_gpio  : in  STD_LOGIC_VECTOR(12 downto 0);
        --entemp    : in  STD_LOGIC_VECTOR(4 downto 0);
        --start     : in  STD_LOGIC;
        --acc       : in  STD_LOGIC;
        --rst       : in  STD_LOGIC;
        --arrange   : in  STD_LOGIC;
        address   : in  STD_LOGIC_VECTOR(12 downto 0);
        --address   : in  STD_LOGIC_VECTOR(9 downto 0);
        write     : in  STD_LOGIC_VECTOR(31 downto 0);
        read      : out STD_LOGIC_VECTOR(31 downto 0)
    );
end main;

architecture Behavioral of main is
    --signal G_MAX_ADD  : integer := 2;
    signal rst        : STD_LOGIC := '0';
    signal acc        : STD_LOGIC := '0';
    signal start      : STD_LOGIC := '0';
    signal ce         : STD_LOGIC := '0';
    signal ce_save    : STD_LOGIC := '0';
    signal arrange    : STD_LOGIC := '0';
    signal wer        : STD_LOGIC := '0';
    signal en_res     : STD_LOGIC := '0';
    signal last_done  : STD_LOGIC := '0';
    signal first_done : STD_LOGIC := '0';
    signal en_fsm     : STD_LOGIC_VECTOR(03 downto 0) := (others => '0');
    signal we_save    : STD_LOGIC_VECTOR(07 downto 0) := (others => '0');
    signal max_add    : STD_LOGIC_VECTOR(09 downto 0) := (others => '0');
    signal actrl      : STD_LOGIC_VECTOR(09 downto 0) := (others => '0');
    signal asave      : STD_LOGIC_VECTOR(09 downto 0) := (others => '0');
    signal result     : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
    signal tensor     : STD_LOGIC_VECTOR(95 downto 0) := (others => '0');
    signal read_temp  : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
    signal enctrl     : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal entemp     : STD_LOGIC_VECTOR(04 downto 0) := (others => '0');
    signal nca        : STD_LOGIC_VECTOR(95 downto 0) := (others => '0');
    signal ncb        : STD_LOGIC_VECTOR(95 downto 0) := (others => '0');
    signal ncc        : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
    signal ncd        : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
    signal address_ctrl : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal address_save : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal addr         : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    
    begin
    --ten <= tensor(71 downto 0);
    max_add <= std_logic_vector(to_unsigned(G_MAX_ADD, 10));

    start   <= axi_gpio(5);
    acc     <= axi_gpio(6);
    rst     <= axi_gpio(7);
    entemp <= axi_gpio(4 downto 0);
    arrange    <= axi_gpio(12);
    addr <= '0' & address(12 downto 3) & "00000";

    
    --rearrange    <= first_done and arrange;
    address_ctrl <= '0' & actrl & "00000";
    address_save <= '0' & asave & "00000";

    we_save <= (others => wer);
    
    
    --process(arrange, last_done, first_done)
    --process(axi_gpio(12), last_done, first_done)
    --begin
        --if arrange = '1' then 
        --if axi_gpio(12) = '1' then 
           --done <= last_done; 
        --else
           --done <= first_done; 
        --end if;
    --end process;

    selecting: entity work.sel8to9
    port map(
        clk          =>clk,
        rst          =>rst,
        --launch       =>rearrange,
        launch       =>arrange,
        --done         =>last_done,
        done         =>done(1),
        ce           =>ce,
        en_res       =>en_res,
        ce_save      =>ce_save,
        we_save      =>we_save,
        we           =>we,
        enctrl       =>enctrl(20 downto 18),
        maxaddr      =>max_add,
        address      =>addr,
        address_save =>address_save,
        address_ctrl =>address_ctrl,
        result       =>result,
        write        =>write,
        read_temp    =>read_temp,
        tensor       =>tensor(71 downto 0)
    );

    -- Instantiating Save FSM
    Save_FSM: entity work.fsm_Save
    port map(
        ce      => ce_save,
        we      => wer,
        clk     => clk,
        acc     => acc,
        rst     => rst,
        start   => start,
        --done    => first_done,
        done    => done(0),
        asave   => asave,
        max_add => max_add
    );

    -- Instantiating PE FSM
    PE_FSM: entity work.fsm_PE
    port map(
        ce      => ce,
        clk     => clk,
        acc     => acc,
        rst     => rst,
        start   => start,
        actrl   => actrl,
        max_add => max_add
    );

    -- Instantiating PE Block
    PE_block: entity work.PE_blocks
    port map(
        ce      => ce,
        we      => we(0),
        en      => enctrl(17 downto 0),
        wr      => write,
        clk     => clk,
        rst     => rst,
        acc     => acc,
        divi    => axi_gpio(11 downto 8),
        addr_a  => actrl,
        addr_b  => address(12 downto 3),
        tensor  => tensor(71 downto 0),
        --test    => test,
        DataOut => result
    );
        
    -- Read Selection Process
    --process(axi_gpio(4 downto 0), read_temp)
    process(entemp, read_temp)
    begin
        --if rising_edge(clk) then
        --case axi_gpio(4 downto 0) is
        case entemp is
            when "10101" => 
                en_res <= '1';
                read <= read_temp(31 downto 0);
            when "10110" => 
                en_res <= '1';
                read <= read_temp(63 downto 32);
            when others =>
                en_res <= '0';
                read <= (others => '0');
        end case;
        --end if;
    end process;

    process(entemp, enable)
    begin
        --if rising_edge(clk) then
            enctrl <= (others => '0');
            enctrl(to_integer(unsigned(entemp))) <= enable;
        --end if;
    end process;

    --enctr <= enctrl;
    
end Behavioral;
