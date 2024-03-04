----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.01.2024 13:27:00
-- Design Name: 
-- Module Name: ProjectController - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ProjectController is
    port(   clk: in std_logic;
            rst: in std_logic;
            start : in std_logic;
            rst_uart: in std_logic;
            scl: INOUT STD_LOGIC;                                 --I2C serial clock
            sda: INOUT STD_LOGIC;                                 --I2C serial data
            an: out STD_LOGIC_VECTOR (7 downto 0);    -- anozi
            cat: out STD_LOGIC_VECTOR (7 downto 0);
            tx : out std_logic;
            outLed: out std_logic;
            TxReady : out std_logic
    );
end ProjectController;

architecture Behavioral of ProjectController is
signal TxData : std_logic_vector(7 downto 0);
signal button : std_logic;
signal Tx_aux : std_logic := '1';
signal TxReady_aux : std_logic;

signal i2c_ack_err : std_logic;                                 --I2C slave acknowledge error flag
signal temperature1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal temperature : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal temperatureSSD : STD_LOGIC_VECTOR(31 DOWNTO 0); 
signal reset_sens: std_logic;           --temperature value obtained
signal numarOcteti: integer := 4;
type State is (init, start1, trimit, stop);
signal stare : State := init;

signal temperaturaInt : integer;

signal nrOut : std_logic_vector (39 downto 0);
signal nrOut1 : std_logic_vector (39 downto 0);

component displ7seg is
    Port ( clk  : in  STD_LOGIC;
           rst  : in  STD_LOGIC;
           Data : in  STD_LOGIC_VECTOR (31 downto 0);   -- date
           an   : out STD_LOGIC_VECTOR (7 downto 0);    -- anozi
           cat  : out STD_LOGIC_VECTOR (7 downto 0));   -- catozi
end component;



component temp_sensor_adt7420 IS
  GENERIC(
    sys_clk_freq     : INTEGER := 100_000_000;                      --input clock speed from user logic in Hz
    temp_sensor_addr : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1001011"); --I2C address of the temp sensor pmod
  PORT(
    clk         : IN    STD_LOGIC;                                 --system clock
    reset_n     : IN    STD_LOGIC;                                 --asynchronous active-low reset
    scl         : INOUT STD_LOGIC;                                 --I2C serial clock
    sda         : INOUT STD_LOGIC;                                 --I2C serial data
    i2c_ack_err : OUT   STD_LOGIC;                                 --I2C slave acknowledge error flag
    temperature : OUT   STD_LOGIC_VECTOR(15 DOWNTO 0));            --temperature value obtained
END component;

begin


Conv: entity WORK.Convertor port map (temperature, nrOut);

nrOut1 <= nrOut;

C1 : entity WORK.UART16 port map(Clk => Clk, Rst_uart => rst_uart, Send => start, Data1 => nrOut1, Tx => tx, Rdy => TxReady);


tempSenzor: temp_sensor_adt7420
  GENERIC map(
    sys_clk_freq => 100_000_000,                      --input clock speed from user logic in Hz
    temp_sensor_addr => "1001011") --I2C address of the temp sensor pmod
  PORT map(
    clk   => clk,                                 --system clock
    reset_n => reset_sens,                                 --asynchronous active-low reset
    scl => scl,                                 --I2C serial clock
    sda => SDA,                                 --I2C serial data
    i2c_ack_err => i2c_ack_err,                                 --I2C slave acknowledge error flag
    temperature => temperature);            --temperature value obtained
    
    temperatureSSD <= x"0000" & temperature;
    reset_sens <= not rst;

SSD: displ7seg 
    Port map( clk  => clk,
           rst  => rst,
           Data => temperatureSSD,  -- date
           an   => an,    -- anozi
           cat  => cat);   -- catozi
           
    
           
end Behavioral;