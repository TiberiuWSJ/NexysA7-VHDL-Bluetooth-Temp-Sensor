

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debouncer is
    Port ( Clk : in STD_LOGIC;
           D_in : in STD_LOGIC;
           Q_out : out STD_LOGIC);
end debouncer;

architecture Behavioral of debouncer is

signal Q1, Q2, Q3 : std_logic;

begin

process(Clk)
begin
   if (Clk'event and Clk = '1') then
         Q1 <= D_IN;
         Q2 <= Q1;
         Q3 <= Q2;
   end if;
end process;

Q_OUT <= Q1 and Q2 and (not Q3);

end Behavioral;