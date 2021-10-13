-------------------------------------------------------------------------------------
-- Company  : Molecular Microscopy & Spectroscopy, Istituto Italiano di Tecnologia
-- Engineers: Alessandro Rossetta
-- Date     : April 2019
-- Design   : Time-Tagging Platform
-- License  : CC BY-NC 4.0 
-------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.math_real.all;
use IEEE.std_logic_misc.all;

library UNisIM;  
use UNisIM.Vcomponents.all;


entity hit_filter is
	generic (
		x_offset		: integer;
		y_offset		: integer);
	port (
		x_fake          : in integer;
		y_fake          : in integer;		
		clock 			: in  std_logic;
		photon_in   	: in  std_logic;
		photon_valid    : out std_logic;
		photon_filtered : out std_logic
		);
end hit_filter;

architecture hit_filter_structure of hit_filter is

constant A : integer:=1;
constant B : integer:=2;
constant C : integer:=3;
	
	
signal photon_filtered_st 	        : std_logic;
signal photon_filtered_nd 	        : std_logic;
signal filtered_photon   	 	    : std_logic;
signal valid_photon	                : std_logic;
signal photon_detection             : std_logic;
signal clear                        : std_logic;
	
attribute loc			 	        : string;
attribute establish_hierarchy 	    : string;
attribute establish_hierarchy of hit_filter_structure	: architecture is "true";	
attribute loc of first_photon_filter        : label is "slice_x"&integer'image(x_offset)&"y"&integer'image(y_offset);   -- 1st FCDE	
attribute loc of second_photon_filter       : label is "slice_x"&integer'image(x_offset)&"y"&integer'image(y_offset+A);	-- 2nd FCDE	
attribute loc of first_photon_valid         : label is "slice_x"&integer'image(x_offset)&"y"&integer'image(y_offset+B); -- 3rd FCDE	
attribute loc of second_photon_valid        : label is "slice_x"&integer'image(x_offset)&"y"&integer'image(y_offset+C);	-- 4th FCDE	



	
begin
	
	
	-- 1st FCDE
	first_photon_filter : FDCE
    generic map (
       INIT => '0')
    port map (
       Q    => photon_filtered_st,
       CLR  => photon_filtered_st,
       D    => '1',
       C    => photon_in,
       CE   => '1');
        
	-- 2nd FCDE
    second_photon_filter : FDPE
    generic map (
            INIT => '0') 
    port map (
       Q => filtered_photon, 
       C => clock, 
       CE => '1', 
       PRE => photon_filtered_st, 
       D => '0'); 

	photon_filtered <= filtered_photon;

	-- 3rd FCDE	
	first_photon_valid : FDCE
	generic map (
		INIT => '0')
	port map (
		Q    => photon_filtered_nd,   
		CLR  => '0',
		D    => filtered_photon,
		C    => clock,
		CE   => '1');
	
	-- 4th FCDE	
 	second_photon_valid : FDCE
    generic map (
        INIT => '0')
    port map (
        Q    => photon_valid,
        CLR  => '0',
        D    => photon_filtered_nd,
        C    => clock,
        CE   => '1');			


end hit_filter_structure;
