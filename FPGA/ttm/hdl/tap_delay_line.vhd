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
USE ieee.math_real.ALL;

LIBRARY unisim;
USE unisim.vcomponents.ALL;

ENTITY tap_delay_line IS
	GENERIC (
		STAGES 	: INTEGER;
		Xoff	: INTEGER;
		Yoff	: INTEGER);
	PORT (
		x_fake          : IN INTEGER;
		y_fake          : IN INTEGER;
		
		trigger			: IN std_logic;		-- START signal input (triggers carrychain)
		reset			: IN std_logic;
		clock			: IN std_logic;		-- STOP signal input (assumed to be clock synchronous)
		latched_output	: OUT std_logic_vector(STAGES-1 DOWNTO 0));		-- Carrychain output, to be converted to binary
END tap_delay_line;

ARCHITECTURE behaviour OF tap_delay_line IS
	
	-- To place the delayline in a particular spot (best for linearities and resolution), the LOC constraint is used.
	ATTRIBUTE LOC			 	: string;
	ATTRIBUTE BEL			 	: string;
	ATTRIBUTE keep_hierarchy 	: string;
	ATTRIBUTE keep_hierarchy OF behaviour	: ARCHITECTURE IS "true";
	
	ATTRIBUTE myAttribute: integer;

	SIGNAL unreg		: std_logic_vector(STAGES-1 DOWNTO 0);
	SIGNAL reg			: std_logic_vector(STAGES-1 DOWNTO 0);
	
	SIGNAL s_input		: std_logic_vector(3 DOWNTO 0);

BEGIN

	-- Generation of the carrychain, starting at the specified X, Y coordinate. 
	carry_delay_line: FOR i IN 0 TO STAGES/4-1 GENERATE
		first_carry4: IF i = 0 GENERATE
    
       ATTRIBUTE LOC OF delayblock : LABEL IS "SLICE_X"&INTEGER'image(Xoff)&"Y"&INTEGER'image(Yoff+i);

        
    BEGIN
    
    s_input <= "111" & trigger;
    
        delayblock: CARRY4 
            PORT MAP(
                CO         => unreg(3 DOWNTO 0),
                CI         => '0',
                CYINIT     => '1',
                DI         => "0000",
                S         => s_input );
     END GENERATE;

		 
         next_carry4: IF i > 0 GENERATE
		 
			ATTRIBUTE LOC OF delayblock : LABEL IS "SLICE_X"&INTEGER'image(Xoff)&"Y"&INTEGER'image(Yoff+i);

                        
		BEGIN
		
            delayblock: CARRY4 
				PORT MAP(
					CO 		=> unreg(4*(i+1)-1 DOWNTO 4*i),
					CI 		=> unreg(4*i-1),
					CYINIT 	=> '0',
					DI 		=> "0000",
					S 		=> "1111");
         END GENERATE;
    END GENERATE;
    
    -- The output is latched two times for stability reasons. 
	latch: FOR j IN 0 TO STAGES-1 GENERATE
	
       
        AFF_FF : if ((j+1)MOD(4) = 1) GENERATE		

		ATTRIBUTE BEL OF FDR_1 : LABEL IS "AFF";
		ATTRIBUTE LOC OF FDR_1 : LABEL IS "SLICE_X"&INTEGER'image(Xoff)&"Y"&INTEGER'image(Yoff+integer(floor(real(j/4))));
	 	ATTRIBUTE BEL OF FDR_2 : LABEL IS "BFF";
		ATTRIBUTE LOC OF FDR_2 : LABEL IS "SLICE_X"&INTEGER'image(Xoff)&"Y"&INTEGER'image(Yoff+integer(floor(real(j/4))));

		
	BEGIN
	
		FDR_1: FDR
			GENERIC MAP(
				INIT 	=> '0')
			PORT MAP(
				C 		=> clock,
				R 		=> reset,
				D 		=> unreg(j),
				Q 		=> reg(j));
		FDR_2: FDR	
			GENERIC MAP(
				INIT 	=> '0')
			PORT MAP(
				C 		=> clock,
				R 		=> reset,
				D 		=> reg(j),
				Q 		=> latched_output(j));
	END GENERATE;

	
END GENERATE;

END behaviour;
