library ieee;
use ieee.std_logic_misc.or_reduce;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.vcomponents.all;

package mytypes is
    type   std_array_7downto0_vector is array (natural range <>) of std_logic_vector(7 downto 0);
    type   std_array_8downto0_vector is array (natural range <>) of std_logic_vector(8 downto 0);
    type   std_array_15downto0_vector is array (natural range <>) of std_logic_vector(15 downto 0);
    type   std_array_16downto0_vector is array (natural range <>) of std_logic_vector(16 downto 0);
    type   std_array_23downto0_vector is array (natural range <>) of std_logic_vector(23 downto 0);        
    type   std_array_31downto0_vector is array (natural range <>) of std_logic_vector(31 downto 0);    
end package;
