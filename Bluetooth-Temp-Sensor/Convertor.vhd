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

entity Convertor is
    Port (
      temperatura: in STD_LOGIC_VECTOR(15 downto 0);
      asciiCodes: out STD_LOGIC_VECTOR(39 downto 0)
       );
end Convertor;

architecture Behavioral of Convertor is

signal temperaturaInt : integer;
signal cifra1,cifra2, cifra3, cifra4 : std_logic_vector(3 downto 0);
signal codHex1, codHex2, codHex3, codHex4 : std_logic_vector(7 downto 0);
signal concatenare: STD_LOGIC_VECTOR(39 downto 0);
begin

temperaturaInt <= conv_integer(temperatura);

cifra1 <= std_logic_vector(to_unsigned(temperaturaInt mod 10, 4));
cifra2 <= std_logic_vector(to_unsigned((temperaturaInt / 10) mod 10, 4));
cifra3 <= std_logic_vector(to_unsigned((temperaturaInt / 100) mod 10, 4));
cifra4 <= std_logic_vector(to_unsigned((temperaturaInt / 1000) mod 10, 4));


 codHex1 <= x"30" when cifra1 = x"0"
 else  x"31" when cifra1 = x"1"
 else  x"32" when cifra1 = x"2"
 else  x"33" when cifra1 = x"3"
 else  x"34" when cifra1 = x"4"
 else  x"35" when cifra1 = x"5"
 else  x"36" when cifra1 = x"6"
 else  x"37" when cifra1 = x"7"
 else  x"38" when cifra1 = x"8"
 else  x"39" when cifra1 = x"9"
 else  x"00";

codHex2 <= x"30" when cifra2 = x"0"
 else  x"31" when cifra2 = x"1"
 else  x"32" when cifra2 = x"2"
 else  x"33" when cifra2 = x"3"
 else  x"34" when cifra2 = x"4"
 else  x"35" when cifra2 = x"5"
 else  x"36" when cifra2 = x"6"
 else  x"37" when cifra2 = x"7"
 else  x"38" when cifra2 = x"8"
 else  x"39" when cifra2 = x"9"
 else  x"00";    
 
 codHex3 <= x"30" when cifra3 = x"0"
  else  x"31" when cifra3 = x"1"
  else  x"32" when cifra3 = x"2"
  else  x"33" when cifra3 = x"3"
  else  x"34" when cifra3 = x"4"
  else  x"35" when cifra3 = x"5"
  else  x"36" when cifra3 = x"6"
  else  x"37" when cifra3 = x"7"
  else  x"38" when cifra3 = x"8"
  else  x"39" when cifra3 = x"9"
  else  x"00";


codHex4 <= x"30" when cifra4 = x"0"
  else  x"31" when cifra4 = x"1"
  else  x"32" when cifra4 = x"2"
  else  x"33" when cifra4 = x"3"
  else  x"34" when cifra4 = x"4"
  else  x"35" when cifra4 = x"5"
  else  x"36" when cifra4 = x"6"
  else  x"37" when cifra4 = x"7"
  else  x"38" when cifra4 = x"8"
  else  x"39" when cifra4 = x"9"
  else  x"00";
  
  
  concatenare <= codHex4 & codHex3 & x"2E" & codHex2 & codHex1;
  
asciiCodes <= concatenare;
  
end Behavioral;