library UNISIM;
use UNISIM.vcomponents.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;
use work.mytypes.all;

entity datapreparation_new_zerosuppression is
  GENERIC (
          CHANNELS                   : INTEGER;
          DATAUSBWORDS               : INTEGER:=13
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
end datapreparation_new_zerosuppression;

architecture datapreparation_new_zerosuppression_i of datapreparation_new_zerosuppression is

COMPONENT datapreparation_new
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
END COMPONENT;





signal fifoA_din   : std_logic_vector(31 DOWNTO 0);
signal fifoA_wr_en : std_logic; 
signal fifoA_rd_en : std_logic;
signal fifoA_dout  : std_logic_vector(15 DOWNTO 0);
signal fifoA_full  : std_logic;
signal fifoA_empty : std_logic;


signal fifoB_din   : std_logic_vector(15 DOWNTO 0);
signal fifoB_wr_en : std_logic;
signal fifoB_rd_en : std_logic;
signal fifoB_dout  : std_logic_vector(31 DOWNTO 0);
signal fifoB_full  : std_logic;
signal fifoB_empty : std_logic; 


signal fifoAB_data            : std_logic_vector(15 DOWNTO 0);
signal fifoAB_rd_en_not_full  : std_logic; 
signal fifoAB_not_empty_wr_en : std_logic;


signal dataprep_dataout       : std_logic_vector(31 downto 0);
signal dataprep_dataout_valid : std_logic;
signal dataprep_dataout_ready : std_logic;


begin

--   dataprep_dataout_ready  <= dataout_ready;
--   dataout        <= dataprep_dataout;       
--   dataout_valid  <= dataprep_dataout_valid; -- and (dataprep_dataout(15) or dataprep_dataout(31));

   dataprep_dataout_ready  <= dataout_ready;
   process(clk, reset) begin
       if (reset='1') then
                dataout        <= (others => '0');       
                dataout_valid  <= '0';
       elsif (rising_edge(clk)) then   
            if (dataprep_dataout(15)='1' or dataprep_dataout(31)='1') then
            
                dataout        <= dataprep_dataout;       
                dataout_valid  <= dataprep_dataout_valid;
                
            else
            
                dataout        <= (others => '0');       
                dataout_valid  <= '0';
                
            end if;     
       end if;
   end process;




datapreparation_new_impl: datapreparation_new
  generic map(
          CHANNELS       =>CHANNELS         
  )
  Port map (
  		  clk             => clk             ,
          reset           => reset           ,

          dataout         =>  dataprep_dataout        ,  --dataout       ,
          dataout_valid   =>  dataprep_dataout_valid  ,  --dataout_valid ,
          dataout_ready   =>  dataprep_dataout_ready  ,  --dataout_ready ,
          

          din_fifo_full    => din_fifo_full    ,
          din_fifo_prog_full    => din_fifo_prog_full    ,

          din_datavalid   => din_datavalid   ,
          din_valid_L     => din_valid_L     ,
          din_pixel       => din_pixel       ,
          din_line        => din_line        ,
          din_scan        => din_scan        ,
          din_value_L     => din_value_L     ,
          din_step        => din_step        ,
          din_valid_CH    => din_valid_CH    ,
          din_value_CH    => din_value_CH    ,
          din_stored_failsafe => din_stored_failsafe ,
          din_no_channels_hit => din_no_channels_hit           
   );       
    

end datapreparation_new_zerosuppression_i;
