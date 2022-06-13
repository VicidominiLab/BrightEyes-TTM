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


entity top_single_ended is

	GENERIC (  
	    --constant DEBUG_FAKE_LASER_ON : boolean := false;
	    --constant DEBUG_FAKE_PHOTON_ON : boolean := false;
	    ENABLE_SYLAP : boolean := true;
	    
	    CHANNELS      : INTEGER:=25;
	    CHANNELS_DIFF : INTEGER:=49;
	    
		STAGES		: INTEGER:=128*4; --346*4; --1396 - 4 * (3 for the hit_filter);
        STAGES_W    : INTEGER:=20;
		FINE_BITS	: INTEGER:=9;
		Xoff		: INTEGER:=1;
		Yoff		: INTEGER:=0);
	port(
			          
	    laser         : in std_logic;
	    
        photon_channels : in std_logic_vector(CHANNELS-1 downto 0);
	--CHANNELS_P      : in std_logic_vector(CHANNELS_DIFF-1 downto 0);
        --CHANNELS_N      : in std_logic_vector(CHANNELS_DIFF-1 downto 0);        
	    
	    pixel_clock   : in std_logic;
        line_clock    : in std_logic;
        frame_clock   : in std_logic;
        
        LED           : out std_logic_vector(7 downto 0);
       
	    reset_in_n    : in std_logic;                                ---input reset active low
		clk200_p         : in std_logic;                             ---input clk 200 Mhz  
		clk200_n         : in std_logic;                             ---input clk 200 Mhz  

        clk156_25_p   : in std_logic;                                ---input clk 156.25 Mhz   
        clk156_25_n   : in std_logic;                                ---input clk 156.25 Mhz


		clk_out	      : out std_logic;                               ---output clk 100 Mhz and 180 phase shift
		clk66mhz      : in std_logic; 
		slcs 	      : inout std_logic;                               ---output chip select
		fdata         : inout std_logic_vector(31 downto 0);         
		faddr         : out std_logic_vector(1 downto 0);            ---output fifo address
		slrd	      : inout std_logic;                               ---output read select
		sloe	      : inout std_logic;                               ---output output enable select
		slwr	      : inout std_logic;                               ---output write select
                    
		flaga	      : inout std_logic;                                
		flagb	      : inout std_logic;
		flagc	      : in std_logic;
		flagd	      : in std_logic;

		pktend	      : inout std_logic;                               ---output pkt end 
		PMODE	      : out std_logic_vector(2 downto 0);
		RESET_FX3	      : out std_logic;
		RESET_GPIO59_FX3 : in std_logic;
		
		--HPC_FLIM      : inout std_logic_vector(5 downto 0);           ----expose the pin not used in FLIM green board

        CONN_J40 : inout std_logic;
        CONN_J15 : inout std_logic;
        CONN_J4  : inout std_logic;
        CONN_J14 : inout std_logic;
        CONN_J3  : inout std_logic;
        CONN_J18 : inout std_logic;
        CONN_J38 : inout std_logic;
        CONN_J12 : inout std_logic;
        CONN_J17 : inout std_logic;
        CONN_J1	 : inout std_logic;
        CONN_J6	 : inout std_logic;
        CONN_J21 : inout std_logic;
        CONN_J26 : inout std_logic;
        CONN_J31 : inout std_logic;
        CONN_J36 : inout std_logic;



        UART_PORT_TX  : out std_logic;
        UART_PORT_RX  : in std_logic;
        
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
end entity top_single_ended;

architecture top_single_ended_arch of top_single_ended is
    
    component clockMainGen
    port
     (-- Clock in ports
      -- Clock out ports
      clk_240           : out    std_logic;
      clk_400           : out    std_logic;      
      clk_50            : out    std_logic;      
      clk_100            : out    std_logic;      
      -- Status and control signals
      reset             : in     std_logic;
      locked            : out    std_logic;
      clk_in1_p         : in     std_logic;
      clk_in1_n         : in     std_logic
     );
    end component;

--    component clockUsbGen
--    port
--     (-- Clock in ports
--      -- Clock out ports
--      clk_out100           : out     std_logic;      
--      -- Status and control signals
--      reset             : in     std_logic;
--      locked            : out    std_logic;
--      clk_in400         : in     std_logic
--     );
--    end component;


    component clkSylapGen
    port
     (-- Clock in ports
      -- Clock out ports
      clk_sylap400      : out std_logic;
      clk_sylap50       : out std_logic;
      reset             : in  std_logic;
      locked            : out  std_logic;
      clk_in1_p         : in  std_logic;
      clk_in1_n         : in  std_logic
     );
    end component;
     
    component datapreparation_new_zerosuppression
       GENERIC (                                                                  
               CHANNELS                   : INTEGER                               
        );                                                                       
        Port (                                                                     
  		  clk                        : IN  std_logic;
          reset                      : IN  std_logic;
        
          dataout                    : OUT std_logic_vector(31 downto 0);
          dataout_valid              : OUT std_logic;
          dataout_ready              : IN std_logic;
          
          din_fifo_full         : OUT std_logic;
          din_fifo_prog_full   : OUT std_logic;
          
          din_datavalid  : IN std_logic;  
          din_valid_L    : IN std_logic;       
          din_pixel      : IN std_logic; 
          din_line       : IN std_logic; 
          din_scan       : IN std_logic;
          din_value_L    : IN std_logic_vector(7 downto 0); 
          din_step       : IN std_logic_vector(31 downto 0); 
          din_valid_CH   : IN std_logic_vector(CHANNELS-1 downto 0); 
          din_value_CH   : IN std_array_7downto0_vector(CHANNELS-1 downto 0);
          din_stored_failsafe : IN std_logic;
          din_no_channels_hit : IN std_logic             

          );                                                                        
    end component;
    
    

   
    
    signal resetUsbFifo_n : std_logic;
    signal resetUsbFifo   : std_logic;        
    signal clk_100   : std_logic;
    signal clk_50    : std_logic;
    signal clk_400   : std_logic;
    ---- USED for SYLAP otherwise ignored
    signal clk_sylap50    : std_logic;
    signal clk_sylap400   : std_logic;
    -----    
    
    signal locked_sysClk      : std_logic;
    signal locked_usbClk      : std_logic;
    signal locked_sysClk_neg  : std_logic;
    signal sys_clk   : std_logic;
    signal locked_sync_in                        : std_logic;
    signal betweenIBUFbufG            : std_logic;
    signal reset_sync_in_locked : std_logic;
    
    signal write_ok : std_logic;
   -- signal photon_channels : std_logic_vector(CHANNELS-1 downto 0);
   
    signal din_fifo_full : std_logic;
    signal din_fifo_prog_full : std_logic;
    
    
    COMPONENT to_fx3_workaround IS
        GENERIC (
            DEBUG		: INTEGER);
        PORT (
            
            -- System Signals
            rstn  		        	: IN  std_logic;  -- system reset active low
            clk           		    : IN  std_logic;  -- system clk @100 Mhz
            -- Stream Interface
            stream_rstn             : IN  std_logic;
            stream_clk              : IN std_logic;
            stream_data_i           : IN std_logic_vector(31 DOWNTO 0);
            stream_write_i          : IN std_logic;
            stream_full_o           : OUT std_logic;
            stream_prog_full_o      : OUT std_logic;
            stream_empty_o           : OUT std_logic;
            stream_prog_empty_o      : OUT std_logic;
            -- GPIF2 Interface
            fdata                   : INOUT std_logic_vector(31 DOWNTO 0);
            faddr                   : OUT std_logic_vector(1 DOWNTO 0); -- output fifo address  
            slrd                    : OUT std_logic; -- output read select
            slwr                    : OUT std_logic; -- output write select
            flaga                   : IN std_logic;
            flagb                   : IN std_logic;
            flagc                   : IN std_logic;
            flagd                   : IN std_logic;
            sloe                    : OUT std_logic; -- output enable select
            clk_out                 : OUT std_logic; -- output clk 100 Mhz and 180 phase shift
            slcs                    : OUT std_logic; -- output chip select
            pktend                  : OUT std_logic; -- output pkt end
            PMODE                   : OUT std_logic_vector(2 DOWNTO 0);
            RESET                   : OUT std_logic;
            counter_for_keep_reset_in_n : IN std_logic_vector(31 DOWNTO 0)
            );
    END COMPONENT;	
    
    component tdc_module IS
    GENERIC (                                                                               
        CHANNELS    : INTEGER;                                                                    
        STAGES        : INTEGER;                                                                     
        --STAGES_W    : INTEGER;                                                               
        FINE_BITS    : INTEGER;                                                                   
        Xoff        : INTEGER;                                                                       
        Yoff        : INTEGER);                                                                      
    PORT (                                                                                  
        system_clock    : IN  std_logic;                                                       
        laser_synch        : IN  std_logic;                                                          
           reset_tdc       : IN  std_logic;                                                 
           channel         : IN  std_logic_vector(CHANNELS-1 downto 0);                     
        pixel_enable    : IN  std_logic;                                                       
        line_enable     : IN  std_logic;                                                       
        scan_enable     : IN  std_logic;                                                       
           data_out        : OUT std_logic_vector(255 DOWNTO 0);                            
           data_out_valid  : OUT std_logic;                                                 
           fail_safe_mode      : IN  std_logic;                                             
    
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
        
        
        
    end component;

    signal d_datavalid                :  std_logic;                                             
    signal d_valid_L                  :  std_logic;                                         
    signal d_pixel                    :  std_logic;                                         
    signal d_line                     :  std_logic;                                         
    signal d_scan                     :  std_logic;                                     
    signal d_value_L                  :  std_logic_vector(7 downto 0);                      
    signal d_step                     :  std_logic_vector(31 downto 0);                     
    signal d_valid_CH                 :  std_logic_vector(CHANNELS-1 downto 0);             
    signal d_value_CH                 :  std_array_7downto0_vector(CHANNELS-1 downto 0);
    signal d_stored_failsafe          :  std_logic;     
    
    signal fail_safe_mode             :  std_logic;
    signal data_in : std_logic_vector(31 downto 0);
    signal rd_en   : std_logic;
    signal dout_tdc_module    : std_logic_vector(31 downto 0);
    signal dout    : std_logic_vector(31 downto 0);
    signal full   : std_logic;
    signal empty   : std_logic;
    signal prog_empty   : std_logic;
    signal prog_full   : std_logic;
    signal wr_rst_busy : std_logic;
    signal rd_rst_busy : std_logic;
    signal sync_in : std_logic;
    
    
    signal fifo_to_fx3_full  : std_logic;
    signal fifo_to_fx3_prog_full : std_logic;
    signal fifo_to_fx3_empty         : std_logic;
    signal fifo_to_fx3_prog_empty    : std_logic;
    
    signal dst_fifo_prog_full : std_logic;
    signal dst_fifo_full      : std_logic;
    signal dst_fifo_full_not  : std_logic;
  
    
    signal counter : unsigned(31 downto 0); 
    signal wr_en : std_logic;
    signal clk_24 :std_logic;
    signal clock_for_ILA:std_logic;
    signal dummy0 :std_logic :='0';
    signal debug_out : std_logic_vector(7 DOWNTO 0);

	signal CHANNELS_SINGLE_ENDED :  std_logic_vector(CHANNELS_DIFF-1 downto 0);
    
    signal photon_channels_to_module    :  std_logic_vector(CHANNELS-1 downto 0);
    signal single_channel_out : std_logic;
    
    signal counter_for_clk24: std_logic_vector(6 downto 0);
    
    signal led_resetFX3: std_logic;    
    signal led_full_flag_fx3: std_logic;
    signal led_prog_full_flag_fx3: std_logic;

    signal led_empty_flag_fx3: std_logic;
    signal led_prog_empty_flag_fx3: std_logic;

    signal led_failsafe: std_logic;
    signal led_full_flag_fx3_latched: std_logic;
    signal led_write_ok: std_logic;
    signal led_laser: std_logic;
    signal led_pixel: std_logic;
    signal led_line: std_logic;
    signal led_frame: std_logic;
    signal led_datavalid: std_logic;
    signal led_fail_safe_mode: std_logic;
    
    signal counter_for_keep_reset_in_n: std_logic_vector(31 downto 0);
    signal counter_for_keep_reset_in_n_enable : std_logic;
    signal reset_in_n_keep : std_logic;

    signal counter_for_fifo_reset: std_logic_vector(31 downto 0);
    signal counter_for_fifo_reset_enable : std_logic;
    signal reset_for_fifo : std_logic;

    signal to_fx3_resetUsbFifo_n : std_logic;
    signal to_fx3_resetUsbFifo_n_reg : std_logic;
    
    signal d_no_channels_hit : std_logic;
    
    ---------------------------------------------------------------------
    --  SYLAP COMPONENTS AND SIGNAL
    ---------------------------------------------------------------------
    signal lockSYLAPclk :std_logic;
    signal lockSYLAPclk_n :std_logic;
    signal simLaser : std_logic;
    signal simPulse : std_logic;
    signal simPulseFineDelayed : std_logic;
    signal simStart : std_logic;
    signal dout_valid : std_logic;
    signal dout_valid_to_fx3 : std_logic;
    
    signal sylap_scan    : std_logic;     
    signal sylap_line    : std_logic;    
    signal sylap_pixel   : std_logic;
    signal sylap_counter : unsigned(34 downto 0);
    
    component sylapTop IS
        PORT (
            signal output_simLaser : OUT  std_logic;
            signal output_simPulse : OUT  std_logic;
            signal output_simPulseFineDelayed : OUT  std_logic;
            signal output_simStart : OUT  std_logic;
            signal DebugLED : OUT  std_logic_vector(7 downto 0);
            signal reset    : IN std_logic;
            signal clk_400  : IN std_logic;
            signal clk_50   : IN std_logic;
            signal UART_PORT_RX : IN std_logic;
            signal UART_PORT_TX : OUT std_logic
            );
    end component;
    ---------------------------------------------------------------------
    --  END SYLAP COMPONENTS AND SIGNAL
    ---------------------------------------------------------------------
     function repeat(N: natural; B: std_logic)
        return std_logic_vector
        is
        variable result: std_logic_vector(1 to N);
            begin
            for i in 1 to N loop
            result(i) := B;
            end loop;
        return result;
      end;
    
    signal pixel_to_module       :  std_logic;
    signal line_to_module  :  std_logic;
    signal frame_to_module :  std_logic;


    attribute dont_touch : string;
    attribute dont_touch of photon_channels             : signal is "true";
    attribute dont_touch of photon_channels_to_module   : signal is "true";        
    attribute dont_touch of tdc_module                           : component is "yes";
    attribute dont_touch of datapreparation_new_zerosuppression  : component is "yes";
    attribute dont_touch of pixel_to_module : signal is "true";
    attribute dont_touch of line_to_module  : signal is "true";
    attribute dont_touch of frame_to_module : signal is "true";
    
    begin
    
    --SM_FAN_PWM <= '0'; --Switch off the noisy-fan!
    
    locked_sysClk_neg <= not locked_sysClk;

    LED(0)<=led_resetFX3;
    LED(1)<=led_prog_full_flag_fx3;
    LED(2)<=led_full_flag_fx3;
    
    LED(3)<=led_prog_empty_flag_fx3;
    LED(4)<=led_fail_safe_mode; --led_empty_flag_fx3;
    
    LED(5)<=led_frame;
    LED(6)<=led_line;
    LED(7)<=led_pixel;
    
    SylapOutputsGEN_ENABLED: IF (ENABLE_SYLAP=true) GENERATE 
         
        CONN_J15 <= simLaser;  
        CONN_J4  <= simPulseFineDelayed; 
        CONN_J14 <= sylap_pixel; 
        CONN_J3  <= sylap_line;  
        CONN_J18 <= sylap_scan;  
        CONN_J38 <= led_full_flag_fx3; 
        CONN_J12 <= led_failsafe; 
        CONN_J17 <= single_channel_out;
         
        
       SIM_FRAME_SCAN_PIXEL : process (clk_sylap50,  lockSYLAPclk, GPIO_SW_C) begin
                         if (lockSYLAPclk='0' or GPIO_SW_C='1') then
                              sylap_scan <= '0';    
                              sylap_line <= '0';    
                              sylap_pixel <= '0';
                              sylap_counter <= (OTHERS => '0');
                           elsif rising_edge(clk_sylap50) then
                           
                              sylap_counter <= sylap_counter + 1;
                              sylap_pixel <= sylap_counter(12); --81.92 us
                              sylap_line  <= sylap_counter(21); --42 ms
                              sylap_scan  <= sylap_counter(30); --21 s
                                
                         end if;
                  end process;        
        
    END GENERATE SylapOutputsGEN_ENABLED;
    
    SylapOutputsGEN_DISABLED: IF (ENABLE_SYLAP=false) GENERATE
    
        CONN_J15          <= 'Z';
        CONN_J4           <= 'Z';
        CONN_J14          <= 'Z';
        CONN_J3           <= 'Z';
        CONN_J18          <= 'Z';
        CONN_J38          <= 'Z';
        CONN_J12          <= 'Z';
        CONN_J17          <= 'Z';
        
    END GENERATE SylapOutputsGEN_DISABLED;
    

        
    
    
    pixel_to_module <= sylap_pixel  when (GPIO_DIP_SW1 ='1' and GPIO_DIP_SW2 ='1') else pixel_clock;
    line_to_module  <= sylap_line   when (GPIO_DIP_SW1 ='1' and GPIO_DIP_SW2 ='1') else line_clock;
    frame_to_module <= sylap_scan   when (GPIO_DIP_SW1 ='1' and GPIO_DIP_SW2 ='1') else frame_clock;

    
    photon_channels_to_module <=     ( repeat(CHANNELS   , photon_channels(0)  ) )                   when (GPIO_DIP_SW1 ='1' and GPIO_DIP_SW2 ='0') 
                                else ( repeat(CHANNELS   , simPulseFineDelayed ) )                   when (GPIO_DIP_SW1 ='1' and GPIO_DIP_SW2 ='1')
                                else ( photon_channels(CHANNELS-1 downto 1) ) & simPulseFineDelayed  when (GPIO_DIP_SW1 ='0' and GPIO_DIP_SW2 ='1')
                                else photon_channels;
                                
    sync_in<=       simLaser when (GPIO_DIP_SW3 ='1') else   laser;

    to_fx3_resetUsbFifo_n <=  resetUsbFifo_n when (GPIO_DIP_SW4 ='0') else locked_usbClk;
    

    
    reset_sync_in_locked <= not(locked_sysclk);

     RESET_240 : process (sys_clk) begin
                                if rising_edge(sys_clk) then
                                    to_fx3_resetUsbFifo_n_reg <= to_fx3_resetUsbFifo_n;
                                end if;
                        end process;    
    
     RESET_100 : process (clk_100) begin
                                if rising_edge(clk_100) then
                                       resetUsbFifo_n <= reset_in_n_keep;   
                                       resetUsbFifo <= not reset_in_n_keep;

                                       locked_usbClk <= locked_sysClk;
                                end if;
                        end process;
                        
    sylapInstGEN: IF (ENABLE_SYLAP=true) GENERATE
                  --instanciate A CLOCK GENERATOR for SYLAP
                 clkSylapGenINST : clkSylapGen port map (
                    -- Clock in ports
                    -- Clock out ports
                    clk_sylap400 => clk_sylap400,
                    clk_sylap50 => clk_sylap50,
                    reset  => locked_sysClk_neg,       
                    locked => lockSYLAPclk,        
                    clk_in1_p => clk156_25_p,
                    clk_in1_n => clk156_25_n
                   );
               
                   lockSYLAPclk_n <= not lockSYLAPclk;
                
                
--                  clk_sylap400    <= clk_400;
--                  clk_sylap50     <= clk_50;
--                  lockSYLAPclk_n  <= locked_sysClk_neg;       
                   
                  --instanciate SYLAP 
                  sylapTopINST : sylapTop port map (
                         output_simLaser => simLaser,
                         output_simPulse => simPulse,
                         output_simPulseFineDelayed =>  simPulseFineDelayed,
                         output_simStart  =>  simStart,
                         DebugLED => open,
                         reset => lockSYLAPclk_n,
                         clk_400 => clk_sylap400, 
                         clk_50 => clk_sylap50,
                         UART_PORT_RX => UART_PORT_RX,
                         UART_PORT_TX => UART_PORT_TX
                     );
                  
                           
      
     END GENERATE sylapInstGEN;


    clock_gen : clockMainGen
       port map ( 
      -- Clock out ports  
       clk_240 => sys_clk,
       clk_400 => clk_400,
       clk_50 => clk_50,
       clk_100 => clk_100,
      -- Status and control signals                
       reset => '0',
       locked => locked_sysClk,
       -- Clock in ports
       clk_in1_p => clk200_p,
       clk_in1_n => clk200_n
     );
     
     


         
    
    to_cypress_fx3: to_fx3_workaround
        generic map(DEBUG		=> 0)
        port map (
            -- System Signals
            rstn  		        	=> locked_usbClk, -- 100MHz Pll locked_sysClk signal
            clk           		    => clk_100,  -- system clk @100 Mhz
            -- Stream Interface
            stream_rstn             => to_fx3_resetUsbFifo_n_reg,
            stream_clk              => sys_clk, --it was clk_100,
            stream_data_i           => dout,--** ILA
            stream_write_i          => dout_valid_to_fx3,--** ILA
            stream_full_o           => fifo_to_fx3_full,--** ILA
            stream_prog_full_o      => fifo_to_fx3_prog_full,--** ILA
            stream_empty_o          => fifo_to_fx3_empty,--** ILA
            stream_prog_empty_o     => fifo_to_fx3_prog_empty,--** ILA
            -- GPIF2 Interface
            fdata                   => fdata,
            faddr                   => faddr, -- output fifo address  
            slrd                    => slrd, -- output read select
            slwr                    => slwr, -- output write select
            flaga                   => flaga,
            flagb                   => flagb,
            flagc                   => flagc,
            flagd                   => flagd,
            sloe                    => sloe, -- output enable select
            clk_out                 => clk_out, -- output clk 100 Mhz and 180 phase shift
            slcs                    => slcs, -- output chip select
            pktend                  => pktend, -- output pkt end
            PMODE                   => PMODE,
            RESET                   => RESET_FX3,
            counter_for_keep_reset_in_n => counter_for_keep_reset_in_n
            );
    
    
    
        TDC_module_complete: tdc_module
                GENERIC MAP (
                  CHANNELS     => CHANNELS,
                  STAGES       => STAGES,
              --   STAGES_W     => STAGES_W,
                  FINE_BITS    => FINE_BITS,
                  Xoff         => Xoff,
                  Yoff         => Yoff+3)
              port map (
                    -- System Signals
                    system_clock                => sys_clk,
                    laser_synch                 => sync_in,
                    reset_tdc                   => reset_sync_in_locked,
                    channel                     => photon_channels_to_module,
                    pixel_enable                => pixel_to_module,
                    line_enable                 => line_to_module,       
                    scan_enable                 => frame_to_module,  
                    fail_safe_mode              => fail_safe_mode,  
                    
                    dout_datavalid    => d_datavalid    ,
                    dout_valid_L      => d_valid_L  ,
                    dout_pixel        => d_pixel    ,
                    dout_line         => d_line     ,
                    dout_scan         => d_scan     ,
                    dout_value_L      => d_value_L  ,
                    dout_step         => d_step     ,
                    dout_valid_CH     => d_valid_CH ,
                    dout_value_CH     => d_value_CH ,
                    dout_stored_failsafe => d_stored_failsafe,
                    dout_no_channels_hit => d_no_channels_hit
                     );		
                     
                     
                     
     datapreparation_impl :datapreparation_new_zerosuppression
                        GENERIC MAP(                                                                  
                                CHANNELS                   => CHANNELS                           
                         )                                                                       
                         Port MAP(                            
                                 clk              =>  sys_clk             ,
                                 reset            =>  reset_for_fifo,      
                                
                                 dataout          => dout_tdc_module      ,
                                 dataout_valid    => dout_valid           ,
                                 dataout_ready    => dst_fifo_full_not    ,                     
                                 
                                 din_fifo_full          => din_fifo_full  ,
                                 din_fifo_prog_full     => din_fifo_prog_full   ,
                                 
                                 din_datavalid    =>  d_datavalid      ,
                                 din_valid_L      =>  d_valid_L        ,
                                 din_pixel        =>  d_pixel          ,
                                 din_line         =>  d_line           ,
                                 din_scan         =>  d_scan           ,
                                 din_value_L      =>  d_value_L        ,
                                 din_step         =>  d_step           ,
                                 din_valid_CH     =>  d_valid_CH       ,
                                 din_value_CH     =>  d_value_CH       ,
                                 din_stored_failsafe => d_stored_failsafe,
                                 din_no_channels_hit => d_no_channels_hit             
                          );                                                                       
                     
        
        
        
        
        
        dst_fifo_full_not  <= not dst_fifo_full;
        dst_fifo_full      <= fifo_to_fx3_full;
        dst_fifo_prog_full <= '1' when (GPIO_SW_E='1') else fifo_to_fx3_prog_full;
        
        fail_safe_mode <= fifo_to_fx3_prog_full;
        --dout_valid_to_fx3  <= dout_valid;
        
        
    FX3_WORKAROUND: process(sys_clk, locked_sysClk, reset_sync_in_locked) begin
            if (locked_sysClk='0') then
                    dout_valid_to_fx3  <= '0';
                    dout <= (others=>'1');
            elsif (rising_edge(sys_clk) and reset_sync_in_locked='0') then                         
                    if (GPIO_SW_N='1') or (fifo_to_fx3_full='1') then
                        dout_valid_to_fx3  <=  '0';
                    elsif ((GPIO_SW_S='1') or (fifo_to_fx3_prog_empty='1')) then
                        dout_valid_to_fx3  <=  '1';
                    else
                        dout_valid_to_fx3  <=  dout_valid;        
                    end if;
                
                    if (dout_valid='0') then
                      --dout <= (others=>'1');
                      dout <=  
                       "01111111"&"11111111"&"01111111"&"11111111";
                    else
                        dout <= dout_tdc_module;
                    end if;
             end if;                             
            
            end process;

    LED_240MHz_debug: process (sys_clk, locked_sysClk,reset_in_n_keep) begin       
        if  (locked_sysClk = '0') then 
                led_pixel <= '0'; 
                led_line <= '0'; 
                led_frame <= '0';
                led_fail_safe_mode <= '0';               
        elsif rising_edge(sys_clk) then
            led_laser <= laser;
            led_pixel <= pixel_clock; 
            led_line  <= line_clock;
            led_fail_safe_mode <= fail_safe_mode;
        end if;
    end process;
        
        
    LED_100MHz_debug: process (clk_100, locked_sysClk,reset_in_n_keep) begin
    
        if (locked_sysClk = '0' or reset_in_n_keep = '0') then    

            led_full_flag_fx3_latched <= '0';
            
            if  (locked_sysClk = '0') then 
                led_resetFX3<= '0';
                led_write_ok <= '0';

                
                led_full_flag_fx3 <= '0';
                led_prog_full_flag_fx3 <= '0';
                                
                led_empty_flag_fx3 <= '0';
                led_prog_empty_flag_fx3  <= '0';                
                
                led_failsafe <='0';
                led_laser <='0';
                led_datavalid <= '0';                
            end if;
            
        elsif rising_edge(clk_100) then
            led_resetFX3<=to_fx3_resetUsbFifo_n_reg;            
            led_write_ok <= write_ok;
            led_laser <= laser;

            led_datavalid <= dout_valid;

            led_full_flag_fx3 <=      fifo_to_fx3_full;
            led_prog_full_flag_fx3 <= fifo_to_fx3_prog_full;
                            
            led_empty_flag_fx3 <=       fifo_to_fx3_empty;
            led_prog_empty_flag_fx3  <= fifo_to_fx3_prog_empty;                


            if (fifo_to_fx3_full ='1') then
               led_full_flag_fx3_latched <= '1';                        
            end if;                        
            
        end if;
    end process;
    
    SAMPLE_WRITE_OK: process (clk_100,locked_sysClk) begin
            if (locked_sysClk='0') then    
                write_ok <= '0';
            elsif rising_edge(clk_100) then
                write_ok <= flaga and flagb;
            end if;
    end process; 

    SAMPLED_CHANNEL_OUT: process (clk_400,locked_sysClk) begin
            if (locked_sysClk='0') then    
                single_channel_out <= '0';
            elsif rising_edge(clk_400) then
                single_channel_out <= photon_channels(9);
            end if;
    end process;   
    
    RESET_IN_N_KEEP_PROCESS : process (clk_100, write_ok, locked_sysClk) begin
            if (locked_sysClk='0' or write_ok='1') then    
                counter_for_keep_reset_in_n<=(OTHERS => '0');
                counter_for_keep_reset_in_n_enable<='1';
                reset_in_n_keep<='1';
            elsif rising_edge(clk_100) then
                if (counter_for_keep_reset_in_n_enable='1') then
                   counter_for_keep_reset_in_n<=counter_for_keep_reset_in_n+'1';
                   reset_in_n_keep<='1';   
                   if(counter_for_keep_reset_in_n>=10000000) then --1s
                           counter_for_keep_reset_in_n_enable<='0';            
                           reset_in_n_keep<='0';   
                   end if;               
                end if;
            end if;
   end process;

    RESET_FOR_FIFO_IMPL : process (sys_clk, locked_sysClk) begin
            if (locked_sysClk='0') then    
                counter_for_fifo_reset<=(OTHERS => '0');
                counter_for_fifo_reset_enable<='1';
                reset_for_fifo<='1';
            elsif rising_edge(sys_clk) then
                if (counter_for_fifo_reset_enable='1') then
                   counter_for_fifo_reset<=counter_for_fifo_reset+'1';
                   reset_for_fifo<='1';   
                   if(counter_for_fifo_reset>=1000000) then --1s
                           counter_for_fifo_reset_enable<='0';            
                           reset_for_fifo<='0';   
                   end if;               
                end if;
            end if;
   end process;
 
  
  

      

end architecture;

