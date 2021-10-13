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

library unisim;
use unisim.vcomponents.all;

entity tap_delay_line_with_t2b is
	generic (
		taps		    : integer;
		t2b_bits	    : integer;
		x_offset		: integer;
		y_offset		: integer);
	port (
		x_fake          : in  integer;
		y_fake          : in  integer;
		clock  		 	: in  std_logic;
		reset 			: in  std_logic;
		photon 			: in  std_logic;
		photon_valid    : out std_logic;
		photon_filtered : out std_logic;
		time_tag        : out std_logic_vector((t2b_bits-1) downto 0)
		);

        		
end tap_delay_line_with_t2b;

architecture tap_delay_line_with_t2b_structure of tap_delay_line_with_t2b is
    
signal fine_value_reg              : std_logic_vector((taps-1) downto 0);
signal value_raw_signal            : std_logic_vector((taps-1) downto 0);    
signal value_raw_2                 : std_logic_vector(((taps/4)-1) downto 0);
signal value_raw_2_pad             : std_logic_vector(511 downto 0);    
signal tdl_reset                   : std_logic;
signal lock                        : std_logic;
signal valid                       : std_logic;
signal filtered_input              : std_logic;
signal valid_bin_out               : std_logic;
signal valid_reg                   : std_logic;      
signal value_raw_decimated         : std_logic_vector(((taps/4)-1) downto 0);
signal value_raw_decimated_pad     : std_logic_vector((2**t2b_bits)-1 downto 0);    
signal value_raw_decimated_zeros   : std_logic_vector((2**t2b_bits)-(taps/4)-1 downto 0);    
signal t2b_time_tag                : std_logic_vector((t2b_bits-1) downto 0);

attribute establish_hierarchy 	: string;
attribute establish_hierarchy of tap_delay_line_with_t2b_structure    : architecture is "true";

component hit_filter
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
end component;

component tap_delay_line is
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
end component;

component t2b is
	generic (
		out_length		 : integer;
		in_length     	 : integer
		);
	port (
        clock            : in std_logic;
        reset            : in std_logic;
        valid	         : in std_logic;
        thermo           : in std_logic_vector(((2**out_length)-1) downto 0);
	    bin              : out std_logic_vector((out_length-1) downto 0);
	    valid_bin        : out std_logic
		); 
end component;

	
begin



	input_shaping : hit_filter
		generic map (
			x_offset	=> x_offset,
			y_offset	=> y_offset)
		port map (
			x_fake          => x_fake,
			y_fake          => y_fake,
			clock   		=> clock,
			photon_in    	=> photon,
			photon_valid	=> valid,
			photon_filtered	=> filtered_input);


photon_filtered <= filtered_input;           



	delay_line : tap_delay_line
		generic map (
			taps 	=> taps,
			x_offset	=> x_offset,
			y_offset	=> y_offset+6)
		port map (
			x_fake          => x_fake,
			y_fake          => y_fake,
			photon_filtered => filtered_input,
			clock    		=> clock,
			reset	 		=> reset,
			thermometer	    => value_raw_signal);
			

			
    thermal_data_decimation: for i in 0 to taps-1 generate
                                 term_array : if ((i)MOD(4) = 0) generate
                                            value_raw_decimated ((i/4)) <= value_raw_signal(i);
                                 end generate;
                             end generate;                  
                        

photon_filtered <= filtered_input;
value_raw_decimated_zeros <= (others=>'0');
value_raw_decimated_pad <= value_raw_decimated_zeros & value_raw_decimated; 
valid_reg <= valid;


	thermomether_to_binary : t2b
		generic map (
			out_length 		=> t2b_bits,
			in_length       => taps/4)
		port map (
			clock     => clock,
			reset	  => reset,
			valid 	  => valid_reg, 
			thermo    => value_raw_decimated_pad,
			bin       => t2b_time_tag,
            valid_bin => valid_bin_out);

			
latch_after_t2b: process (clock, reset) begin
        if (reset='1') then
            photon_valid <='0';
            time_tag <= (others=>'0');            
        elsif(rising_edge(clock)) then
            photon_valid <= valid_bin_out;
            time_tag <= t2b_time_tag; 
        end if;
end process;

        
end tap_delay_line_with_t2b_structure;

