library ieee;
use ieee.std_logic_misc.or_reduce;
use ieee.std_logic_misc.and_reduce;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.vcomponents.all;
use work.mytypes.all;

entity tdc_module IS
	GENERIC (
		CHANNELS	: INTEGER;
		STAGES		: INTEGER;
		--STAGES_W    : INTEGER;
		FINE_BITS	: INTEGER;
		Xoff		: INTEGER;
		Yoff		: INTEGER);
	PORT (
		system_clock                  : IN  std_logic;
		laser_synch		              : IN  std_logic;
        reset_tdc                     : IN  std_logic;
        channel                       : IN  std_logic_vector(CHANNELS-1 downto 0);
		pixel_enable                  : IN  std_logic;
		line_enable                   : IN  std_logic;
		scan_enable                   : IN  std_logic;
        data_out                      : OUT std_logic_vector(255 DOWNTO 0);
        data_out_valid                : OUT std_logic;
        fail_safe_mode                : IN  std_logic;

        dout_datavalid                : OUT std_logic;        
        dout_valid_L                  : OUT std_logic;       
        dout_pixel                    : OUT std_logic; 
        dout_line                     : OUT std_logic; 
        dout_scan                     : OUT std_logic;
        dout_value_L                  : OUT std_logic_vector(7 downto 0); 
        dout_step                     : OUT std_logic_vector(31 downto 0); 
        dout_valid_CH                 : OUT std_logic_vector(CHANNELS-1 downto 0); 
        dout_value_CH                 : OUT std_array_7downto0_vector(CHANNELS-1 downto 0);
        dout_stored_failsafe          : OUT std_logic;
        dout_no_channels_hit          : OUT std_logic        
		);
end entity tdc_module;


architecture tdc_single_tdc of tdc_module is


-- Data signals IN

signal data_out_presample        : std_logic_vector(255 DOWNTO 0);
signal data_out_valid_presample  : std_logic;

signal reset_fifo_cmd : std_logic;
signal fail_safe_mode_pre : std_logic;

-----------

COMPONENT tap_delay_line_with_encoder IS
	GENERIC (
		STAGES		: INTEGER;
		FINE_BITS	: INTEGER;
		Xoff		: INTEGER;
		Yoff		: INTEGER;
		DEBUG       : INTEGER);
	PORT (
		x_fake          : IN INTEGER;
		y_fake          : IN INTEGER;
		clk  			: IN  std_logic;
        rst             : IN  std_logic;
        hit             : IN  std_logic;
        valid_out       : OUT std_logic;
        hit_filtered_out : OUT std_logic;
        time_fine_1      : OUT std_logic_vector((FINE_BITS-1) DOWNTO 0)
		);
END COMPONENT;

COMPONENT ila_1
        PORT (
            clk : IN STD_LOGIC; 
            probe0 : IN STD_LOGIC_VECTOR(8 DOWNTO 0);   
            probe1 : IN STD_LOGIC;
            probe2 : IN STD_LOGIC;
            probe3 : IN STD_LOGIC;
            probe4 : IN STD_LOGIC
        
        );
END COMPONENT;


signal valid_data_tdc_hit : std_logic_vector(CHANNELS-1 downto 0);

signal value_raw_tdc_short : std_logic_vector(235 downto 0);
signal value_raw_tdc_short_buf : std_logic_vector(235 downto 0);
signal value_raw_tdc_long : std_logic_vector(943 downto 0);

signal counter: unsigned(4 downto 0);


signal empty       : std_logic;
signal wr_rst_busy : std_logic;
signal rd_rst_busy : std_logic;



signal write_enable_general       : std_logic;
signal write_enable_general_delay : std_logic;

   
signal time_fine_delta : std_logic_vector (8 downto 0); 

signal write_frame_enable       : std_logic;
signal write_line_enable       : std_logic;
signal write_pixel_enable       : std_logic;
signal write_pixel_enable_down  : std_logic;


signal time_fine_ch : std_array_7downto0_vector(CHANNELS-1 downto 0);
signal time_fine_ch_long : std_array_8downto0_vector(CHANNELS-1 downto 0);

signal valid_data_tdc : std_logic;

signal step : std_logic_vector(31 downto 0);
signal step_unreg : std_logic_vector(31 downto 0);
signal step_reg : std_logic_vector(31 downto 0);


signal valid_data_tdc_laser : std_logic;
signal time_fine_1_laser : std_logic_vector (8 downto 0);
signal time_fine_delta_laser : std_logic_vector (8 downto 0); 

signal overflow : std_logic;

signal pixel_enable_d, pixel_enable_dd, pixel_enable_s : std_logic;
signal line_enable_d,line_enable_dd, line_enable_s : std_logic;
signal wrap_d, wrap_dd, wrap_s : std_logic;
signal scan_enable_d, scan_enable_dd, scan_enable_s : std_logic;

signal counterOver, counterOver_unreg, counterOver_reg : std_logic_vector(15 downto 0);
signal reset_counterOver : std_logic;


signal enable_filter_fifowriting : std_logic;    
signal event_filter_laser_enable : std_logic;    
signal event_filter_write_fifo : std_logic;
signal event_filter_write_fifo_pre : std_logic;
signal valid_photon : std_logic;

signal filtered_hit  : std_logic_vector(CHANNELS-1 downto 0);
signal filtered_laser : std_logic;
signal valid_laser_after_hit : std_logic;
signal clear_laser_after_hit : std_logic;

--signal data_joined_valid_for_ILA    : std_logic;
--signal data_joined_for_ILA          : std_logic_vector(255 downto 0);    

signal  dout_pre_datavalid                : std_logic;                                                
signal  dout_pre_valid_L                  : std_logic;                                                
signal  dout_pre_pixel                    : std_logic;                                                
signal  dout_pre_line                     : std_logic;                                                
signal  dout_pre_scan                     : std_logic;                                                
signal  dout_pre_value_L                  : std_logic_vector(7 downto 0);                             
signal  dout_pre_step                     : std_logic_vector(31 downto 0);                            
signal  dout_pre_valid_CH                 : std_logic_vector(CHANNELS-1 downto 0);                    
signal  dout_pre_value_CH                 : std_array_7downto0_vector(CHANNELS-1 downto 0);            
signal  dout_pre_stored_failsafe          : std_logic;

signal stored_failsafe                    : std_logic;

signal dout_pre_no_channels_hit           : std_logic;  


ATTRIBUTE LOC			 	: string;

ATTRIBUTE keep_hierarchy     : string;
ATTRIBUTE keep_hierarchy OF tdc_single_tdc    : ARCHITECTURE IS "true";

type  x_offset_positions is array (0 to 24) of integer range 0 to 255;
type  y_offset_positions is array (0 to 24) of integer range 0 to 255;

--HORIZONTAL SOLUTION
constant x_offset : x_offset_positions:=(3,5,7,9,11,13,15,17,19,21,36,38,40,42,44,46,56,58,60,62,64,66,68,70,72);
constant y_offset : y_offset_positions:=(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

constant x_offset_laser : integer := 74; 
constant y_offset_laser : integer := 0 ;
   	
begin --architecture begining
    
    --------- TDC -----------------------------                    
    TDL_laser : tap_delay_line_with_encoder
        GENERIC MAP (
            STAGES		=> STAGES,
            FINE_BITS	=> FINE_BITS,
            Xoff		=> Xoff+x_offset_laser, --Xoff,
            Yoff		=> Yoff+y_offset_laser,
            DEBUG       => 0)
        PORT MAP (
            x_fake          => x_offset_laser,
            y_fake          => y_offset_laser,
            clk  			=> system_clock,
            rst 			=> reset_tdc,
            hit 			=> laser_synch,
            valid_out       => valid_data_tdc_laser,
            hit_filtered_out => filtered_laser,
            time_fine_1      => time_fine_1_laser
            );



-- Generation of TDC modules depending on requested number of channels 
  TDL_ch: FOR i IN 0 TO (CHANNELS-1) GENERATE
  
   

    TDL : tap_delay_line_with_encoder
        GENERIC MAP (
            STAGES		=> STAGES,
            FINE_BITS	=> FINE_BITS,
            Xoff		=> Xoff+x_offset(i), --Xoff+i,--<-- WORKS --> DOES NOT WORK--x_offset(i),
            Yoff		=> Yoff+y_offset(i),
            DEBUG       => 0)

        PORT MAP (
            x_fake          => x_offset(i),
            y_fake          => y_offset(i),
            clk  			=> system_clock,
            rst 			=> reset_tdc,
            hit 			=> channel(i),
            valid_out       => valid_data_tdc_hit(i),
            hit_filtered_out => filtered_hit(i),           
            time_fine_1      => time_fine_ch_long(i)
            );
            
        time_fine_ch(i) <= time_fine_ch_long(i)(7 downto 0);
             
     END GENERATE;       
    
    valid_data_tdc <= or_reduce(valid_data_tdc_hit); -- all the valid are reduced to a single boolean

    
    ila_1_i  : ila_1
            PORT MAP (
                clk  => system_clock, 
                probe0 =>   time_fine_1_laser,
                probe1 =>   valid_data_tdc_laser,
                probe2 => filtered_laser,
                probe3 => valid_data_tdc,
                probe4 => '0'
            );            
        
    -- Frame Enable
    ---------------------------------------------------------------
    
    
    
    scan_buffer: process (system_clock,reset_tdc) begin
    
        if reset_tdc = '1' then
        
            scan_enable_d <= '0';
            scan_enable_dd <= '0';
            write_frame_enable <='0';
            
        elsif rising_edge(system_clock) then
    
                
            scan_enable_d <= scan_enable;
            scan_enable_dd <= scan_enable_d;
            write_frame_enable <= scan_enable_d AND not(scan_enable_dd);
           
                
        end if;
        
    end process;
    
    
    
    
    ---------------------------------------------------------------
    
    -- Line Enable
    ---------------------------------------------------------------
    
    line_buffer: process (system_clock,reset_tdc) begin
    
        if reset_tdc = '1' then
        
            line_enable_d <= '0';
            line_enable_dd <= '0';
            write_line_enable <= '0';
            
        elsif rising_edge(system_clock) then
    
                
            line_enable_d <= line_enable;
            line_enable_dd <= line_enable_d;
            write_line_enable <= line_enable_d AND not(line_enable_dd);
           
                
        end if;
        
    end process;
    
    
    
    -- Pixel Enable
    ---------------------------------------------------------------
    
    pixel_buffer:process (system_clock,reset_tdc) begin
    
        if reset_tdc = '1' then
        
            pixel_enable_d <= '0';
            pixel_enable_dd <= '0';
            write_pixel_enable <= '0';
            
        elsif rising_edge(system_clock) then
    
                
            pixel_enable_d <= pixel_enable;
            pixel_enable_dd <= pixel_enable_d;
            write_pixel_enable <= pixel_enable_d AND not(pixel_enable_dd);
            write_pixel_enable_down <= not(pixel_enable_d) AND pixel_enable_dd;          
                
        end if;
        
    end process;
    
    

    
    ---------------------------------------------------------------
    -- Step Counter
    ---------------------------------------------------------------
    
    step_counter: process (system_clock,reset_tdc) begin
    
        if reset_tdc = '1' then
        
            step <= (OTHERS => '0');
            step_unreg <= (OTHERS => '0');
            step_reg <= (OTHERS => '0');
            
        else
        
            if rising_edge(system_clock) then
                step_unreg <= step_unreg + '1';	
                step_reg <= step_unreg;	
                step <= step_reg;	
                   
            end if;
                
        end if;
        
    end process;
 
 
--    -------------------------------------------------------------
--     Counter for the Overflow
--     Overflow trigger
--    -------------------------------------------------------------
     
    trigger_forced: process (system_clock,reset_counterOver) begin
    
        if reset_counterOver = '1' then
        
            counterOver <= (OTHERS => '0');
            counterOver_unreg <= (OTHERS => '0');
            counterOver_reg <= (OTHERS => '0');
        
            wrap_d <= '0';
            wrap_dd <= '0';
            
            overflow <= '0';                            
        else
        
            if rising_edge(system_clock) then
                counterOver_unreg <= counterOver_unreg + '1';
                counterOver_reg <= counterOver_unreg;	
            
                counterOver <= counterOver_reg;	
                wrap_d <= counterOver(12);
                wrap_dd <= wrap_d;

                if (overflow='0') then
                    overflow <= wrap_d AND not(wrap_dd);
                else                    
                    overflow <= '0';
                end if;
                
            end if;
                
        end if;
        
    end process;
    
    reset_counterOver <= write_enable_general or reset_tdc;  
    

    
    -- WRITE ENABLE ASSEMBLY
    
    --//          _
    --// ________| |_______________ valid_data_tdc_hit_ch1
    --//                  _
    --// ________________| |_______ valid_data_tdc_hit_chN
    --//            ____________
    --// __________|            |__ valid_photon
    --//                        _
    --//_______________________| |__ valid_data_tdc_laser
    --//          ______________ 
    --//_________|              |___ Enable_fifowriting
    --//          _      _      _    
    --//_________| |____| |____| |__ event_filter_write_fifo
    
    --// Multichannel Event Filter Process
    event_filter: process(system_clock,reset_tdc) begin
    
       if (reset_tdc='1') then
           valid_photon <= '0';
           enable_filter_fifowriting <= '0';
           event_filter_laser_enable <= '0';
           event_filter_write_fifo <= '0';
           stored_failsafe <= '0';             
       else  
        
            if rising_edge(system_clock) then
                write_enable_general <=  event_filter_write_fifo;
            

                 --enable_filter_fifowriting <=  valid_photon; -- valid_data_tdc or valid_photon; TRIAL 
                 enable_filter_fifowriting <=  valid_data_tdc or valid_photon;  

                 event_filter_laser_enable <= (valid_data_tdc_laser and
                                               enable_filter_fifowriting);


                 

                          --- RENDERE NON LATCHED GLI OR
                          if (fail_safe_mode= '0') then
                               stored_failsafe <= '0';                            
                               event_filter_write_fifo <= ((valid_data_tdc_laser and enable_filter_fifowriting) or valid_data_tdc) 
                                                            or overflow
                                                            or write_frame_enable
                                                            or write_line_enable
                                                            or write_pixel_enable;-- or write_pixel_enable_down;

                           else
                               stored_failsafe <= '1';
                               event_filter_write_fifo <=      overflow
                                                            or write_frame_enable
                                                            or write_line_enable
                                                            or write_pixel_enable;-- or write_pixel_enable_down;

                           end if;                 
       
                         if ( valid_data_tdc_laser ='1') then
                             valid_photon <= '0';        
                         elsif ((valid_data_tdc = '1' ) and (valid_photon='0')) then
                             valid_photon <= '1';
                         end if;
            end if;        
       end if;       
      end process;
      
      resample_pixel_line_frame:  process (system_clock, reset_tdc) begin
             if (reset_tdc='1') then
              -- valid_photon <= '0';
               pixel_enable_s <= '0';
               line_enable_s <= '0';
               scan_enable_s <= '0';
             elsif rising_edge(system_clock) then
                  pixel_enable_s <= write_pixel_enable;
                  line_enable_s <= line_enable;
                  scan_enable_s <= scan_enable;
               end if;
       end process;
                
     dataAssembly: process (system_clock, reset_tdc) begin
        if (reset_tdc='1') then
         -- valid_photon <= '0';
         
        else  
          if (rising_edge(system_clock)) then
            dout_datavalid         <= event_filter_write_fifo ;
            dout_valid_L           <= dout_pre_valid_L         ;
            dout_pixel             <= dout_pre_pixel           ;
            dout_line              <= dout_pre_line            ;
            dout_scan              <= dout_pre_scan            ;
            dout_value_L           <= dout_pre_value_L         ;
            dout_step              <= dout_pre_step            ;
            dout_valid_CH          <= dout_pre_valid_CH        ;
            dout_value_CH          <= dout_pre_value_CH        ;
            dout_stored_failsafe   <= stored_failsafe          ;--fail_safe_mode or not valid_data_tdc;
            dout_no_channels_hit   <= dout_pre_no_channels_hit ;
                                                        
          --dout_pre_datavalid         <= event_filter_write_fifo        ;
            dout_pre_valid_L           <= valid_data_tdc_laser           ;
            dout_pre_pixel             <= write_pixel_enable             ;
            dout_pre_line              <= line_enable_s                  ;
            dout_pre_scan              <= scan_enable_s                  ;
            dout_pre_value_L           <= time_fine_1_laser(7 downto 0)  ;           
            dout_pre_step              <= step(31 downto 0)              ;
            dout_pre_valid_CH          <= valid_data_tdc_hit             ;
            dout_pre_value_CH          <= time_fine_ch                   ;        
          --dout_pre_stored_failsafe   <= fail_safe_mode                 ;
            dout_pre_no_channels_hit   <= (and_reduce(not valid_data_tdc_hit));           
            
           end if;        
        end if;       
    end process;
                

end architecture;	
