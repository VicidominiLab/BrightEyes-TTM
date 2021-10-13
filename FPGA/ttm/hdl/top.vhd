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
use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.vcomponents.all;
-- USE WITH PARSER 8x2
entity top is

	GENERIC (  
	    --constant DEBUG_FAKE_LASER_ON : boolean := false;
	    --constant DEBUG_FAKE_PHOTON_ON : boolean := false;
	    ENABLE_SYLAP : boolean := true;
	    
	    CHANNELS    : INTEGER:=21;
		STAGES		: INTEGER:=128*4; --346*4; --1396 - 4 * (3 for the hit_filter);
        STAGES_W    : INTEGER:=20;
		FINE_BITS	: INTEGER:=9;
		Xoff		: INTEGER:=1;
		Yoff		: INTEGER:=0);
	port(
			          
	    laser         : in std_logic;
	    
        photon_channels : in std_logic_vector(CHANNELS-1 downto 0);
	    
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
		
		HPC_FLIM      : inout std_logic_vector(7 downto 0);           ----expose the pin not used in FLIM green board
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
end entity top;

architecture top_arch of top is
    
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

    component clockUsbGen
    port
     (-- Clock in ports
      -- Clock out ports
      clk_out100           : out     std_logic;      
      -- Status and control signals
      reset             : in     std_logic;
      locked            : out    std_logic;
      clk_in400         : in     std_logic
     );
    end component;


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
            stream_data_i           : IN std_logic_vector(255 DOWNTO 0);
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
        dst_fifo_prog_full       : IN std_logic;
        dst_fifo_full       : IN std_logic;
        debug_out : OUT std_logic_vector(7 DOWNTO 0)
        );
    end component;
    
    
    signal data_in : std_logic_vector(31 downto 0);
    signal rd_en   : std_logic;
    signal dout_tdc_module    : std_logic_vector(255 downto 0);
    signal dout    : std_logic_vector(255 downto 0);
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
    signal dst_fifo_full : std_logic;
    
    
    signal counter : unsigned(31 downto 0); 
    signal wr_en : std_logic;
    signal clk_24 :std_logic;
    signal clock_for_ILA:std_logic;
    signal dummy0 :std_logic :='0';
    signal debug_out : std_logic_vector(7 DOWNTO 0);
    
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
    
    signal counter_for_keep_reset_in_n: std_logic_vector(31 downto 0);
    signal counter_for_keep_reset_in_n_enable : std_logic;
    signal reset_in_n_keep : std_logic;
    signal to_fx3_resetUsbFifo_n : std_logic;
    
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
   
        
              
    begin
    
    --SM_FAN_PWM <= '0'; --Switch off the noisy-fan!
    
    locked_sysClk_neg <= not locked_sysClk;

    LED(0)<=led_resetFX3;
    -- LED(1)<=led_laser;
    -- LED(2)<=led_write_ok;
    -- LED(3)<=led_failsafe;

    LED(1)<=led_prog_full_flag_fx3;
    LED(2)<=led_full_flag_fx3;
    
    LED(3)<=led_prog_empty_flag_fx3;
    LED(4)<=led_empty_flag_fx3;
    
    LED(5)<=led_frame;
    LED(6)<=led_line;
    LED(7)<=led_pixel;
    
    SylapOutputsGEN_ENABLED: IF (ENABLE_SYLAP=true) GENERATE
      
        HPC_FLIM(0) <= simLaser;  -- FLIM J1
        HPC_FLIM(1) <= simPulseFineDelayed;  -- FLIM J6
        HPC_FLIM(2) <= sylap_pixel;  -- FLIM J21
        HPC_FLIM(3) <= sylap_line;  -- FLIM J26
        HPC_FLIM(4) <= sylap_scan;  -- FLIM J31
        HPC_FLIM(5) <= led_full_flag_fx3;  -- FLIM J36
        HPC_FLIM(6) <= led_failsafe;  -- FLIM J12
        HPC_FLIM(7) <= single_channel_out;  -- FLIM J17
        
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
    
        HPC_FLIM(0) <= 'Z';  -- FLIM J1
        HPC_FLIM(1) <= 'Z';  -- FLIM J6
        HPC_FLIM(2) <= 'Z';  -- FLIM J21
        HPC_FLIM(3) <= 'Z';  -- FLIM J26
        HPC_FLIM(4) <= 'Z';  -- FLIM J31
        HPC_FLIM(5) <= 'Z';  -- FLIM J36
        HPC_FLIM(6) <= 'Z';  -- FLIM J12
        HPC_FLIM(7) <= 'Z';  -- FLIM J17
    END GENERATE SylapOutputsGEN_DISABLED;
    
    
    
    
    
    
    
    photon_channels_to_module <=     ( repeat(CHANNELS   , photon_channels(0)  ) )                   when (GPIO_DIP_SW1 ='1' and GPIO_DIP_SW2 ='0') 
                                else ( repeat(CHANNELS   , simPulseFineDelayed ) )                   when (GPIO_DIP_SW1 ='1' and GPIO_DIP_SW2 ='1')
                                else ( photon_channels(CHANNELS-1 downto 1) ) & simPulseFineDelayed  when (GPIO_DIP_SW1 ='0' and GPIO_DIP_SW2 ='1')
                                else photon_channels;
                                
    sync_in<=       simLaser when (GPIO_DIP_SW3 ='1')
             else   laser;
    
    --sync_in<=laser;
    --photon_channels_to_module <=  photon_channels;

    
    resetUsbFifo <= not resetUsbFifo_n;
    
    reset_sync_in_locked <= not(locked_sysclk);

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
     
      RECLOCK_USBRESET : process (clk_100) begin
                            if rising_edge(clk_100) then
                                   resetUsbFifo_n <= reset_in_n_keep;   
                                   locked_usbClk <= locked_sysClk;
                                                               
                            end if;
                    end process;

--     clockUsb_gen : clockUsbGen
--        port map ( 
--       -- Clock out ports  
--        clk_out100 => clk_100,
        
--       -- Status and control signals                
--        reset => locked_sysClk_neg,
--        locked => locked_usbClk,
--        -- Clock in ports
--        clk_in400 => clk_400
--      );     
         
    to_fx3_resetUsbFifo_n <=  resetUsbFifo_n when (GPIO_DIP_SW4 ='0') else locked_usbClk;
    
    to_cypress_fx3: to_fx3_workaround
        generic map(DEBUG		=> 0)
        port map (
            -- System Signals
            rstn  		        	=> locked_usbClk, -- 100MHz Pll locked_sysClk signal
            clk           		    => clk_100,  -- system clk @100 Mhz
            -- Stream Interface
            stream_rstn             => to_fx3_resetUsbFifo_n,
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
                    pixel_enable                => pixel_clock,
                    line_enable                 => line_clock,
                    scan_enable                 => frame_clock,
                    data_out                    => dout_tdc_module,
                    data_out_valid              => dout_valid,
                    dst_fifo_prog_full          => dst_fifo_prog_full, 
                    dst_fifo_full               => dst_fifo_full,    
                    debug_out                   => debug_out         
                     );		

        
        dst_fifo_full      <= fifo_to_fx3_full;
        dst_fifo_prog_full <= '1' when (GPIO_SW_E='1') else fifo_to_fx3_prog_full;
        --dout_valid_to_fx3  <= dout_valid;
        
        
    FX3_WORKAROUND: process(sys_clk, locked_sysClk) begin
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
                   "11110000"&"00000000"&"00000000"&"00000000" &
                   "11110000"&"00000000"&"00000000"&"00000000" &
                   "11110000"&"00000000"&"00000000"&"00000000" &
                   "11110000"&"00000000"&"00000000"&"00000000" &
                   "11110000"&"00000000"&"00000000"&"00000000" &
                   "11110000"&"00000000"&"00000000"&"00000000" &
                   "11110000"&"00000000"&"00000000"&"00000000" &
                   "11110000"&"00000000"&"00000000"&"00000000";
                else
                    dout <= dout_tdc_module;
                end if;
         end if;                             
        
        end process;
        
        
    LED_debug: process (clk_100, locked_sysClk,reset_in_n_keep) begin
    
        if (locked_sysClk = '0' or reset_in_n_keep = '0') then    

            led_full_flag_fx3_latched <= '0';
            
            if  (locked_sysClk = '0') then 
                led_resetFX3<= '0';
                led_write_ok <= '0';
                led_pixel <= '0'; 
                led_line <= '0'; 
                led_frame <= '0';
                
                led_full_flag_fx3 <= '0';
                led_prog_full_flag_fx3 <= '0';
                                
                led_empty_flag_fx3 <= '0';
                led_prog_empty_flag_fx3  <= '0';                
                
                led_failsafe <='0';
                led_laser <='0';
                led_datavalid <= '0';                
            end if;
            
        elsif rising_edge(clk_100) then
            led_resetFX3<=to_fx3_resetUsbFifo_n;            
            led_write_ok <= write_ok;
            led_laser <= laser;
            led_pixel <= pixel_clock; 
            led_line <= line_clock; 
            led_frame <=frame_clock;
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
                single_channel_out <= photon_channels(10);
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



   
 
  
  

      

end architecture;

