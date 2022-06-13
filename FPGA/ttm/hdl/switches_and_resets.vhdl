------------------------------------------------------------
-- Company  : IIT
-- Engineers: Alessandro Rossetta, Mattia Donato 
-- Date     : April 2019
-- Design   : 
-- License  : to be defined
------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.vcomponents.all;
use work.mytypes.all;

-- USE WITH PARSER 8x2
entity switches_and_resets is

	GENERIC (  
	    --constant DEBUG_FAKE_LASER_ON : boolean := false;
	    --constant DEBUG_FAKE_PHOTON_ON : boolean := false;
	    ENABLE_SYLAP : boolean := true;
	    
	    CHANNELS      : INTEGER:=21;
	    CHANNELS_DIFF : INTEGER:=49;
	    
		STAGES		: INTEGER:=128*4; --346*4; --1396 - 4 * (3 for the hit_filter);
        STAGES_W    : INTEGER:=20;
		FINE_BITS	: INTEGER:=9;
		Xoff		: INTEGER:=1;
		Yoff		: INTEGER:=0);
	port(
			          
	    laser         : in std_logic;
	    
        --photon_channels : in std_logic_vector(CHANNELS-1 downto 0);
	    CHANNELS_P      : in std_logic_vector(CHANNELS_DIFF-1 downto 0);
        CHANNELS_N      : in std_logic_vector(CHANNELS_DIFF-1 downto 0);        
	    
	    pixel_clock   : in std_logic;
        line_clock    : in std_logic;
        frame_clock   : in std_logic;
        
        LED           : out std_logic_vector(7 downto 0);
       
	    reset_in_n    : in std_logic;                                ---input reset active low
		
		CONN_J2       : inout std_logic;
		CONN_J3       : inout std_logic;
		CONN_J4       : inout std_logic;
		CONN_J5       : inout std_logic;
		CONN_J6       : inout std_logic;
		CONN_J7       : inout std_logic;
		CONN_J8       : inout std_logic;
		CONN_J9       : inout std_logic;
		
		DETECTOR_VREF1     : inout std_logic;
		DETECTOR_VREF0     : inout std_logic;
		DETECTOR_EN_SPAD   : inout std_logic;
        
        SM_FAN_PWM    : out std_logic;
        
        GPIO_SW_N     : in std_logic;
        GPIO_SW_S     : in std_logic;   
        GPIO_SW_E     : in std_logic;   
        GPIO_SW_W     : in std_logic;   
        GPIO_SW_C     : in std_logic;   
                     
        GPIO_DIP_SW1  : in std_logic;
        GPIO_DIP_SW2  : in std_logic;
        GPIO_DIP_SW3  : in std_logic;
        GPIO_DIP_SW4  : in std_logic

	    );
end entity switches_and_resets;


architecture switches_and_resets_arch of switches_and_resets is

begin

end switches_and_resets_arch;
