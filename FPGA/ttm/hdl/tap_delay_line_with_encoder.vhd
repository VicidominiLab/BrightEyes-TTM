------------------------------------------------------------
-- Company  : IIT
-- Engineers: Alessandro Rossetta, Mattia Donato 
-- Date     : April 2019
-- Design   : 
-- License  : to be defined
------------------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;

LIBRARY unisim;
USE unisim.vcomponents.ALL;

ENTITY tap_delay_line_with_encoder IS
	GENERIC (
		STAGES		: INTEGER;
		FINE_BITS	: INTEGER;
		Xoff		: INTEGER;
		Yoff		: INTEGER);
	PORT (
		x_fake           : IN INTEGER;
		y_fake           : IN INTEGER;
		clk  		 	 : IN  std_logic;
		rst 			 : IN  std_logic;
		hit 			 : IN  std_logic;
		valid_out        : OUT std_logic;
		hit_filtered_out : OUT std_logic;
		time_fine_1      : OUT std_logic_vector((FINE_BITS-1) DOWNTO 0)
		);

        		
END tap_delay_line_with_encoder;

ARCHITECTURE structure OF tap_delay_line_with_encoder IS
	ATTRIBUTE keep_hierarchy 	: string;
    ATTRIBUTE keep_hierarchy OF structure    : ARCHITECTURE IS "true";
    
    SIGNAL fine_value_reg    : std_logic_vector((STAGES-1) DOWNTO 0);
    SIGNAL value_raw_signal    : std_logic_vector((STAGES-1) DOWNTO 0);
    
    SIGNAL value_raw_2       : std_logic_vector(((STAGES/4)-1) DOWNTO 0);
    SIGNAL value_raw_2_pad     : std_logic_vector(511 DOWNTO 0);
    
    SIGNAL tdl_reset       : std_logic;
    SIGNAL lock            : std_logic;
    SIGNAL clock           : std_logic;
    SIGNAL clock_180       : std_logic;
    
    SIGNAL valid                    : std_logic;
    SIGNAL filtered_input           : std_logic;
    SIGNAL valid_bin_out            : std_logic;
    SIGNAL valid_reg                : std_logic;
      
    SIGNAL value_raw_decimated       : std_logic_vector(((STAGES/4)-1) DOWNTO 0);
    SIGNAL value_raw_decimated_pad     : std_logic_vector((2**FINE_BITS)-1 DOWNTO 0);    
    SIGNAL value_raw_decimated_zeros: std_logic_vector((2**FINE_BITS)-(STAGES/4)-1 DOWNTO 0);
    
    SIGNAL t2b_time_fine_1      : std_logic_vector((FINE_BITS-1) DOWNTO 0);


COMPONENT ila_0

PORT (
	clk : IN STD_LOGIC;



	probe0 : IN STD_LOGIC_VECTOR(199 DOWNTO 0)
);
END COMPONENT  ;


COMPONENT input_filter
	GENERIC (
		Xoff		: INTEGER;
		Yoff		: INTEGER);
	PORT (
		x_fake          : IN INTEGER;
		y_fake          : IN INTEGER;
		
		clk_in  			: IN  std_logic;
		hit_in 	   		: IN  std_logic;
		valid           : OUT std_logic;
		filtered_hit    : OUT std_logic
		);
END COMPONENT;

COMPONENT therm2bin_easy2 IS
	GENERIC (
		out_length  : INTEGER;
		in_length   : INTEGER);
	PORT (
		clock       : IN  std_logic;
		reset 	    : IN  std_logic;
		valid     	: IN  std_logic;
		thermo      : IN  std_logic_vector(((2**out_length)-1) DOWNTO 0);
		bin         : OUT std_logic_vector((out_length-1) DOWNTO 0);
		valid_bin   : OUT std_logic);
END COMPONENT;


COMPONENT tap_delay_line IS
    GENERIC (
        STAGES     : INTEGER;
        Xoff    : INTEGER;
        Yoff    : INTEGER);
    PORT (
        x_fake                 : INTEGER;
		y_fake                 : IN INTEGER;
        
        trigger                : IN std_logic;
        reset                : IN std_logic;
        clock                : IN std_logic;
        latched_output        : OUT std_logic_vector(STAGES-1 DOWNTO 0));
END COMPONENT;


	
BEGIN



	hit_filter : input_filter
		GENERIC MAP (
			Xoff	=> Xoff,
			Yoff	=> Yoff)
		PORT MAP (
			x_fake          => x_fake,
			y_fake          => y_fake,
			clk_in   		=> clk,
			hit_in    		=> hit,
			valid	 		=> valid,
			filtered_hit	=> filtered_input);

        hit_filtered_out <= filtered_input;           



	tdl : tap_delay_line
		GENERIC MAP (
			STAGES 	=> STAGES,
			Xoff	=> Xoff,
			Yoff	=> Yoff+6)
		PORT MAP (
			x_fake          => x_fake,
			y_fake          => y_fake,
			trigger   		=> filtered_input,
			clock    		=> clk,
			reset	 		=> rst,
			latched_output	=> value_raw_signal);
			
			
    thermal_data_decimation: FOR i IN 0 TO STAGES-1 GENERATE
                                 term_array : if ((i)MOD(4) = 0) GENERATE
                                            value_raw_decimated ((i/4)) <= value_raw_signal(i);
                                 END GENERATE;
                             END GENERATE;                  
                        

hit_filtered_out <= filtered_input;
value_raw_decimated_zeros <= (others=>'0');
value_raw_decimated_pad <= value_raw_decimated_zeros & value_raw_decimated; 
valid_reg <= valid;

	--t2b : therm2bin_pipeline_count
	t2b : therm2bin_easy2
		GENERIC MAP (
			out_length 		=> FINE_BITS,
			in_length       => STAGES/4)
		PORT MAP (
			clock   => clk,
			reset	=> rst,
			valid 	=> valid_reg, 
			thermo  => value_raw_decimated_pad,
			bin     => t2b_time_fine_1,
            valid_bin => valid_bin_out);
			
    latch_after_t2b: process (clk, rst) begin
        if (rst='1') then
            valid_out <='0';
            time_fine_1 <= (others=>'0');            
        elsif(rising_edge(clk)) then
            valid_out <= valid_bin_out;
            time_fine_1 <= t2b_time_fine_1; 
        end if;
    end process;

        
END structure;

