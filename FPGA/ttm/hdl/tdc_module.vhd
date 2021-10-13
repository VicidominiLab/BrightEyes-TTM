-------------------------------------------------------------------------------------
-- Company  : Molecular Microscopy & Spectroscopy, Istituto Italiano di Tecnologia
-- Engineers: Alessandro Rossetta, Mattia Donato 
-- Date     : April 2019
-- Design   : Time-Tagging Platform
-- License  : CC BY-NC 4.0 
-------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_misc.or_reduce;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity tdc_module IS
	GENERIC (
		CHANNELS	: INTEGER;
		STAGES		: INTEGER;
		--STAGES_W    : INTEGER;
		FINE_BITS	: INTEGER;
		Xoff		: INTEGER;
		Yoff		: INTEGER);
	PORT (
		system_clock    : IN  std_logic;
		laser_synch		: IN  std_logic;
        reset_tdc       : IN  std_logic;
        channel         : IN  std_logic_vector(CHANNELS-1 downto 0);
		pixel_enable    : IN  std_logic;
		line_enable     : IN  std_logic;
		scan_enable     : IN  std_logic;
        data_out        : OUT std_logic_vector(255 DOWNTO 0);
        data_out_valid  : OUT std_logic;
        dst_fifo_prog_full       : IN  std_logic;
        dst_fifo_full       : IN  std_logic;
        debug_out        : OUT std_logic_vector(7 DOWNTO 0)
		);
end entity tdc_module;


architecture tdc_single_tdc of tdc_module is


-- Data signals IN

signal data_out_presample        : std_logic_vector(255 DOWNTO 0);
signal data_out_valid_presample  : std_logic;

signal dataword_output : std_logic_vector (255 downto 0); 
signal dataword_output_pre : std_logic_vector (255 downto 0); 
signal reset_fifo_cmd : std_logic;
signal fail_safe_mode_pre : std_logic;
signal fail_safe_mode : std_logic;

-----------

COMPONENT tap_delay_line_with_t2b IS
	generic (
        taps            : integer;
        t2b_bits        : integer;
        x_offset        : integer;
        y_offset        : integer);
    port (
        x_fake          : in  integer;
        y_fake          : in  integer;
        clock               : in  std_logic;
        reset             : in  std_logic;
        photon             : in  std_logic;
        photon_valid    : out std_logic;
        photon_filtered : out std_logic;
        time_tag        : out std_logic_vector((t2b_bits-1) downto 0)
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

type   multi_time_fine is array (0 to CHANNELS-1) of std_logic_vector(7 downto 0);
signal time_fine_ch : multi_time_fine;

type   multi_time_fine_long is array (0 to CHANNELS-1) of std_logic_vector(8 downto 0);
signal time_fine_ch_long : multi_time_fine_long;

signal valid_data_tdc : std_logic;

signal step : std_logic_vector(15 downto 0);
signal step_unreg : std_logic_vector(15 downto 0);
signal step_reg : std_logic_vector(15 downto 0);


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

signal data_invalid : std_logic_vector(255 downto 0):= "11110000"&"00000000"&"00000000"&"00000000" &
                                                       "11110000"&"00000000"&"00000000"&"00000000" &
                                                       "11110000"&"00000000"&"00000000"&"00000000" &
                                                       "11110000"&"00000000"&"00000000"&"00000000" &
                                                       "11110000"&"00000000"&"00000000"&"00000000" &
                                                       "11110000"&"00000000"&"00000000"&"00000000" &
                                                       "11110000"&"00000000"&"00000000"&"00000000" &
                                                       "11110000"&"00000000"&"00000000"&"00000000";

ATTRIBUTE LOC			 	: string;

ATTRIBUTE keep_hierarchy     : string;
ATTRIBUTE keep_hierarchy OF tdc_single_tdc    : ARCHITECTURE IS "true";

type  x_offset_positions is array (0 to CHANNELS-1) of integer range 0 to 100;
constant x_offset : x_offset_positions:=(3,5,7,9,11,13,15,17,19,21,36,38,40,42,44,46,60,62,64,66,68);
constant x_offset_laser : integer := 70 ;

   	
begin --architecture begining
    
    --------- TDC -----------------------------                    
    TDL_laser : tap_delay_line_with_t2b
        GENERIC MAP (
            taps		=> STAGES,
            t2b_bits	=> FINE_BITS,
            x_offset		=> x_offset_laser, --Xoff,
            y_offset		=> Yoff
            )
        PORT MAP (
            x_fake          => x_offset_laser,
            y_fake          => Yoff,
            clock  			=> system_clock,
            reset 			=> reset_tdc,
            photon 			=> laser_synch,
            photon_valid    => valid_data_tdc_laser,
            photon_filtered => filtered_laser,
            time_tag        => time_fine_1_laser
            );

-- Generation of TDC modules depending on requested number of channels 
  TDL_ch: FOR i IN 0 TO (CHANNELS-1) GENERATE
  
   

    TDL : tap_delay_line_with_t2b
        GENERIC MAP (
            taps		=> STAGES,
            t2b_bits	=> FINE_BITS,
            x_offset	=> x_offset(i), --Xoff+i,--<-- WORKS --> DOES NOT WORK--x_offset(i),
            y_offset    => Yoff
            )

        PORT MAP (
            x_fake          => x_offset(i),
            y_fake          => Yoff,
            clock  			=> system_clock,
            reset 			=> reset_tdc,
            photon 			=> channel(i),
            photon_valid    => valid_data_tdc_hit(i),
            photon_filtered => filtered_hit(i),           
            time_tag        => time_fine_ch_long(i)
            );
            
        time_fine_ch(i) <= time_fine_ch_long(i)(7 downto 0);
             
     END GENERATE;       
    
    valid_data_tdc <= or_reduce(valid_data_tdc_hit); -- all the valid are reduced to a single boolean
            
        
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
           fail_safe_mode <= '0';
           fail_safe_mode_pre <= '0';
           enable_filter_fifowriting <= '0';
           event_filter_laser_enable <= '0';
           event_filter_write_fifo <= '0';
       else  
        
            if rising_edge(system_clock) then
                write_enable_general <=  event_filter_write_fifo;
                fail_safe_mode_pre <= dst_fifo_prog_full;
            
                 fail_safe_mode <= fail_safe_mode_pre;

                 --enable_filter_fifowriting <=  valid_photon; -- valid_data_tdc or valid_photon; TRIAL 
                 enable_filter_fifowriting <=  valid_data_tdc or valid_photon;  

                 event_filter_laser_enable <= (valid_data_tdc_laser and
                                               enable_filter_fifowriting);




                          --- RENDERE NON LATCHED GLI OR
                          if (fail_safe_mode= '0') then
                               event_filter_write_fifo <= ((valid_data_tdc_laser and enable_filter_fifowriting) or valid_data_tdc) 
                                                            or overflow
                                                            or write_frame_enable
                                                            or write_line_enable
                                                            or write_pixel_enable;-- or write_pixel_enable_down;

                           else
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
          dataword_output <= (OTHERS => '0');
          dataword_output_pre <= (OTHERS => '0');
          debug_out(2 downto 0) <=    (OTHERS => '0');
         
        else  
          if (rising_edge(system_clock)) then
            dataword_output <= dataword_output_pre;
           -- write_enable_general <=  event_filter_write_fifo;
                debug_out(2 downto 0) <=                       write_pixel_enable & line_enable_s & scan_enable_s;
                dataword_output_pre <=            
                

                                                   "0000" & valid_data_tdc_laser & write_pixel_enable & line_enable_s & scan_enable_s -- imaging
                                                   & time_fine_1_laser(7 downto 0) -- sync fine stamp                   
                                                   & step(15 downto 8)
                                                   & step(7 downto 0)         -- macro counter 

                                                   & "0001" & valid_data_tdc_hit(0) & valid_data_tdc_hit(1)  
                                                   & valid_data_tdc_hit(2) & "0"                  
                                                   & time_fine_ch(0)   -- ch1                    
                                                   & time_fine_ch(1)   -- ch2                     
                                                   & time_fine_ch(2)   -- ch3    

                                                   & "0010" & valid_data_tdc_hit(3) & valid_data_tdc_hit(4)  
                                                   & valid_data_tdc_hit(5) & "0"                  
                                                   & time_fine_ch(3)   -- ch4                    
                                                   & time_fine_ch(4)   -- ch5                     
                                                   & time_fine_ch(5)   -- ch6                

                                                   
                                                   & "0011" & valid_data_tdc_hit(6) & valid_data_tdc_hit(7)  
                                                   & valid_data_tdc_hit(8) & "0"                  
                                                   & time_fine_ch(6)   -- ch7                    
                                                   & time_fine_ch(7)   -- ch8                     
                                                   & time_fine_ch(8)   -- ch9 
                                                   
                                                   & "0100" & valid_data_tdc_hit(9) & valid_data_tdc_hit(10)  
                                                   & valid_data_tdc_hit(11) & "0"                  
                                                   & time_fine_ch(9)   -- ch10                    
                                                   & time_fine_ch(10)  -- ch11                     
                                                   & time_fine_ch(11)  -- ch12
                                                   
                                                   & "0101" & valid_data_tdc_hit(12) & valid_data_tdc_hit(13)  
                                                   & valid_data_tdc_hit(14) & "0"                  
                                                   & time_fine_ch(12)  -- ch13                    
                                                   & time_fine_ch(13)  -- ch14                     
                                                   & time_fine_ch(14)  -- ch15
                                                   
                                                   & "0110" & valid_data_tdc_hit(15) & valid_data_tdc_hit(16)  
                                                   & valid_data_tdc_hit(17) & "0"                  
                                                   & time_fine_ch(15)  -- ch16                    
                                                   & time_fine_ch(16)  -- ch17                     
                                                   & time_fine_ch(17)  -- ch18    
                                                                                                                    
                                                   & "0111" & valid_data_tdc_hit(18) & valid_data_tdc_hit(19)  
                                                   & valid_data_tdc_hit(20) & "0"                  
                                                   & time_fine_ch(18)   -- ch19                    
                                                   & time_fine_ch(19)   -- ch20                     
                                                   & time_fine_ch(20);  -- ch21
                                                   






               
                                                   
           end if;        
        end if;       
    end process;

    ---------------------------------------------------------------
    -- FIFO pre-STAGE for Synchronization
    ---------------------------------------------------------------
    fifoprestage: process (system_clock,reset_tdc) begin
    
        if reset_tdc = '1' then
            data_out_valid <= '0';
            data_out <= (OTHERS => '0');
            
            data_out_valid_presample <= '0';
            data_out_presample <= (OTHERS => '0');
        else
            if rising_edge(system_clock) then
             
                data_out_valid_presample <= write_enable_general;
                data_out_presample <= dataword_output;
                
                data_out_valid <= data_out_valid_presample;
                --data_out <= data_out_presample;    
                
                if (data_out_valid_presample='0') then
                   data_out <= data_invalid; 
                else
                   data_out <= data_out_presample;
                end if;
                                       
            end if;
        end if;	 
    end process;
    
end architecture;	
