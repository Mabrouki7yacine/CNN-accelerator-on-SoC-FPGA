library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;
Library UNIMACRO;
use UNIMACRO.vcomponents.all;

entity mult is
    Generic (
        ARCH_TYPE : integer --:= 0  -- Generic constant to select architecture 0 uint 1 int
    );
    Port ( in_mat : in STD_LOGIC_VECTOR (7 downto 0);
           weight : in STD_LOGIC_VECTOR (7 downto 0);
           clk, rst : in STD_LOGIC;
           ce : in STD_LOGIC;
           mat_out : out STD_LOGIC_VECTOR (15 downto 0));
end mult;

architecture Behavioral of mult is
signal P : STD_LOGIC_VECTOR (42 downto 0) := (others =>'0');
signal A : STD_LOGIC_VECTOR (24 downto 0) := (others =>'0'); --0XXXXXXX0000000000XXXXXXX
signal B : STD_LOGIC_VECTOR (17 downto 0) := (others =>'0'); --0XXXXXXX000XXXXXXX
begin

    -- Generate process based on ARCH_TYPE
    GEN_ARCH : if ARCH_TYPE = 0 generate
    begin
        A(24 downto 8) <= (others => '0');
        A(7 downto 0) <= in_mat(7 downto 0);
        B(17 downto 8) <= (others => '0');
        B(7 downto 0) <= weight(7 downto 0);
        MULT_MACRO_inst : MULT_MACRO
        generic map (
           DEVICE => "7SERIES",    -- Target Device: "VIRTEX5", "7SERIES", "SPARTAN6" 
           LATENCY => 1,           -- Desired clock cycle latency, 0-4
           WIDTH_A => 25,          -- Multiplier A-input bus width, 1-25 
           WIDTH_B => 18)          -- Multiplier B-input bus width, 1-18
        port map (
           P => P,     -- Multiplier ouput bus, width determined by WIDTH_P generic 
           A => A,     -- Multiplier input A bus, width determined by WIDTH_A generic 
           B => B,     -- Multiplier input B bus, width determined by WIDTH_B generic 
           CE => CE,   -- 1-bit active high input clock enable
           CLK => CLK, -- 1-bit positive edge clock input
           RST => rst  -- 1-bit input active high reset
        );
        --mat_out(7) <= P(42);
        mat_out <= P(15 downto 0);
    end generate GEN_ARCH;

    GEN_DATAFLOW : if ARCH_TYPE = 1 generate
    begin
        A(24 downto 7) <= (others => in_mat(7));
        A(7 downto 0) <= in_mat(7 downto 0);
        B(17 downto 7) <= (others => weight(7));
        B(7 downto 0) <= weight(7 downto 0);
        MULT_MACRO_inst : MULT_MACRO
        generic map (
           DEVICE => "7SERIES",    -- Target Device: "VIRTEX5", "7SERIES", "SPARTAN6" 
           LATENCY => 1,           -- Desired clock cycle latency, 0-4
           WIDTH_A => 25,          -- Multiplier A-input bus width, 1-25 
           WIDTH_B => 18)          -- Multiplier B-input bus width, 1-18
        port map (
           P => P,     -- Multiplier ouput bus, width determined by WIDTH_P generic 
           A => A,     -- Multiplier input A bus, width determined by WIDTH_A generic 
           B => B,     -- Multiplier input B bus, width determined by WIDTH_B generic 
           CE => CE,   -- 1-bit active high input clock enable
           CLK => CLK, -- 1-bit positive edge clock input
           RST => rst  -- 1-bit input active high reset
        );
        --mat_out(7) <= P(42);
        mat_out <= P(15 downto 0);
    end generate GEN_DATAFLOW;


end Behavioral;
