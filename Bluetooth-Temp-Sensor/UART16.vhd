----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.01.2024 18:15:05
-- Design Name: 
-- Module Name: UART16 - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UART16 is
  Port ( Clk: in std_logic;
       rst_uart: in std_logic;
       Send: in std_logic;
       Data1: in std_logic_vector(39 downto 0);
       Tx: out std_logic;
       Rdy: out std_logic);
end UART16;

architecture Behavioral of UART16 is
--constant CR    : STD_LOGIC_VECTOR (7 downto 0) := x"0D";
    --constant LF    : STD_LOGIC_VECTOR (7 downto 0) := x"0A";
    type State is (init, trimit, stop);
    signal stare : State := init;
    signal TxData  : STD_LOGIC_VECTOR (7 downto 0) := x"00";
    signal Start   : STD_LOGIC := '0';
    signal TxRdy   : STD_LOGIC := '0';
    signal nr_octeti : Integer;
    signal temp_txRdy : std_logic := '0';
    signal start_temp : std_logic := '0';
    
signal send_filtrat : std_logic := '0';
signal rst_filtrat : std_logic := '0';


begin
-- Instantierea modulului uart_tx
    uartTx: entity WORK.UART 
    port map (
                Clk => Clk,
                Rst => rst_uart,
                Start => start_temp,
                TxData => TxData,
                Tx => Tx,
                TxRdy => temp_txRdy);
-- Automatul de stare pentru transmisia caracterelor
    FSM : process(clk)
begin
  if rst_uart = '1' then
      stare <= init;
  else
      if clk = '1' and clk'event then
          case stare is
              when init =>
                  rst_filtrat <= '0';  
                  nr_octeti <= 7;  
                  start_temp <= '0'; 
                  if send_filtrat = '1' then
                      stare <= trimit;
                  end if;
              when trimit => 
                  start_temp <= '1';
                  if temp_txRdy = '1' then
                  nr_octeti <= nr_octeti - 1;
                  end if;
                  if nr_octeti > 0 then
                      stare <= trimit;
                  else
                      rst_filtrat <= '1';
                      stare <= stop;
                  end if;
              when stop => stare <= init;
                 
          end case;   
      end if;
  end if;
end process;
  
  
  -- Selectia octetului care trebuie transmis
      
          TxData <= Data1 (39 downto 32) when nr_octeti = 5 else
                    Data1 (31 downto 24) when nr_octeti = 4 else
                    Data1 (23 downto 16) when nr_octeti = 3 else
                    Data1 (15 downto 8) when nr_octeti = 2 else
                    Data1 (7 downto 0) when nr_octeti = 1 else
                    --CR when 03,
                    --LF when 04,
                    x"20";    
   MPG2 : entity Work.debouncer port map (clk, rst_uart, rst_filtrat);
   MPG3 : entity Work.debouncer port map (clk, send, send_filtrat);
end Behavioral;
