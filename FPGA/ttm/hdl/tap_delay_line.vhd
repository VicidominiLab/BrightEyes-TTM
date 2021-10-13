-------------------------------------------------------------------------------------
-- Company  : Molecular Microscopy & Spectroscopy, Istituto Italiano di Tecnologia
-- Engineers: Alessandro Rossetta, Mattia Donato 
-- Date     : April 2019
-- Design   : Time-Tagging Platform
-- License  : CC BY-NC 4.0 
-------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.math_real.all;

library unisim;
use unisim.vcomponents.all;

entity tap_delay_line is
	generic (
		taps 	    : integer;
		x_offset	: integer;
		y_offset	: integer);
	port (
		x_fake          : in integer;
		y_fake          : in integer;		
		photon_filtered : in std_logic;		
		reset			: in std_logic;
		clock			: in std_logic;		
		thermometer	: out std_logic_vector(taps-1 downto 0));		
end tap_delay_line;

architecture tap_delay_line_structure of tap_delay_line is

signal metastable_thermometer		: std_logic_vector(taps-1 downto 0);
signal stable_thermometer			: std_logic_vector(taps-1 downto 0);	
signal s_input		                : std_logic_vector(3 downto 0);

attribute loc			 	: string;
attribute bel			 	: string;
attribute establish_hierarchy 	: string;
attribute establish_hierarchy of tap_delay_line_structure: architecture is "true";

begin


	tap_delay_line: for i in 0 to taps/4-1 generate
	first_tap: if i = 0 generate
    
    attribute loc of tap : label is "slice_x"&integer'image(x_offset)&"y"&integer'image(y_offset+i);

        
    begin
    
    s_input <= "111" & photon_filtered;
    
        tap: CARRY4 
            port map(
                CO         => metastable_thermometer(3 downto 0),
                CI         => '0',
                CYINIT     => '1',
                DI         => "0000",
                S          => s_input );
     end generate;

		 
         next_tap: if i > 0 generate
		 
			attribute loc of tap : label is "slice_x"&integer'image(x_offset)&"y"&integer'image(y_offset+i);

                        
		begin
		
            tap: CARRY4 
				port map(
					CO 		=> metastable_thermometer(4*(i+1)-1 downto 4*i),
					CI 		=> metastable_thermometer(4*i-1),
					CYINIT 	=> '0',
					DI 		=> "0000",
					S 		=> "1111");
         end generate;
    end generate;
    
 
	flip_flop_barrier: for j in 0 to taps-1 generate
	
       
        AFF_FF : if ((j+1)mod(4) = 1) generate		

		attribute bel of first_latch  : label is "AFF";
		attribute loc of first_latch  : label is "slice_x"&integer'image(x_offset)&"y"&integer'image(y_offset+integer(floor(real(j/4))));
	 	attribute bel of second_latch : label is "BFF";
		attribute loc of second_latch : label is "slice_x"&integer'image(x_offset)&"y"&integer'image(y_offset+integer(floor(real(j/4))));

		
	begin
	
		first_latch: FDR
			generic map(
				INIT 	=> '0')
			port map(
				C 		=> clock,
				R 		=> reset,
				D 		=> metastable_thermometer(j),
				Q 		=> stable_thermometer(j));
				
		second_latch: FDR	
			generic map(
				INIT 	=> '0')
			port map(
				C 		=> clock,
				R 		=> reset,
				D 		=> stable_thermometer(j),
				Q 		=> thermometer(j));
	end generate;

	
end generate;

end tap_delay_line_structure;
