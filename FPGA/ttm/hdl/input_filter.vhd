------------------------------------------------------------
-- Company  : IIT
-- Engineers: Alessandro Rossetta
-- Date     : April 2019
-- Design   : 
-- License  : to be defined
------------------------------------------------------------




LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.math_real.ALL;
use IEEE.std_logic_misc.all;

library UNISIM;  
use UNISIM.Vcomponents.all;


ENTITY input_filter IS
	GENERIC (
		Xoff		: INTEGER;
		Yoff		: INTEGER);
	PORT (
		x_fake          : IN INTEGER;
		y_fake          : IN INTEGER;
		
		clk_in 			: IN  std_logic;
		hit_in 			: IN  std_logic;
		valid           : OUT std_logic;
		filtered_hit    : OUT std_logic
		);
END input_filter;

ARCHITECTURE structure OF input_filter IS

	ATTRIBUTE LOC			 	: string;

	ATTRIBUTE keep_hierarchy 	: string;
	ATTRIBUTE keep_hierarchy OF structure	: ARCHITECTURE IS "true";

	
	
	SIGNAL filtered_hit_1 	        : std_logic;
	SIGNAL filtered_hit_2 	        : std_logic;
	SIGNAL filtered_hit_signal 	    : std_logic;
	SIGNAL filtered_hit_signal_2 	: std_logic;
	SIGNAL valid_hit 	            : std_logic;
	SIGNAL fired 			        : std_logic;
	SIGNAL clear                    : std_logic;

	
	ATTRIBUTE LOC OF input_filter1       : LABEL IS "SLICE_X"&INTEGER'image(Xoff)&"Y"&INTEGER'image(Yoff);	
	ATTRIBUTE LOC OF input_filter2       : LABEL IS "SLICE_X"&INTEGER'image(Xoff)&"Y"&INTEGER'image(Yoff+1);	
	ATTRIBUTE LOC OF input_filter_fired1 : LABEL IS "SLICE_X"&INTEGER'image(Xoff)&"Y"&INTEGER'image(Yoff+2);
	ATTRIBUTE LOC OF input_filter_fired2 : LABEL IS "SLICE_X"&INTEGER'image(Xoff)&"Y"&INTEGER'image(Yoff+3);	



	
BEGIN
	
	
	
	input_filter1 : FDCE
    GENERIC MAP (
       INIT => '0')
    PORT MAP (
       Q    => filtered_hit_1,
       CLR  => filtered_hit_1,
       D    => '1',
       C    => hit_in,
       CE   => '1');
        

    input_filter2 : FDPE
    GENERIC MAP (
            INIT => '0') -- Initial value of register ('0' or '1')
    PORT MAP (
       Q => filtered_hit_signal, -- Data output
       C => clk_in, -- Clock input
       CE => '1', -- Clock enable input
       PRE => filtered_hit_1, -- Asynchronous preset input
       D => '0'); -- Data input

	filtered_hit <= filtered_hit_signal;

	input_filter_fired1 : FDCE
	GENERIC MAP (
		INIT => '0')
	PORT MAP (
		Q    => filtered_hit_signal_2,    --
		CLR  => '0',
		D    => filtered_hit_signal,
		C    => clk_in,
		CE   => '1');
			
 	input_filter_fired2 : FDCE
    GENERIC MAP (
        INIT => '0')
    PORT MAP (
        Q    => valid,--
        CLR  => '0',
        D    => filtered_hit_signal_2,
        C    => clk_in,
        CE   => '1');			


END structure;
