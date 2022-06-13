library UNISIM;
use UNISIM.vcomponents.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;
use work.mytypes.all;

entity datapreparation is
  GENERIC (
          CHANNELS                   : INTEGER;
          DATAUSBWORDS               : INTEGER:=8
    );
  Port (
  		  clk                        : IN  std_logic;
          reset                      : IN  std_logic;

          dataout                    : OUT std_logic_vector(31 downto 0);
          dataout_valid              : OUT std_logic;
          dataout_ready              : IN std_logic;
          
          din_fifofull   : OUT std_logic;
          
          din_datavalid  : IN std_logic;  
          din_valid_L    : IN std_logic;       
          din_pixel      : IN std_logic; 
          din_line       : IN std_logic; 
          din_scan       : IN std_logic;
          din_value_L    : IN std_logic_vector(7 downto 0); 
          din_step       : IN std_logic_vector(15 downto 0); 
          din_valid_CH   : IN std_logic_vector(CHANNELS-1 downto 0); 
          din_value_CH   : IN std_array_7downto0_vector(CHANNELS-1 downto 0)
   );
end datapreparation;

architecture dataprep of datapreparation is

signal pointer                        : std_logic_vector(7 downto 0);
signal datain_buffer                  : std_logic_vector(255 downto 0);
signal din_datajoined_after_fifo            : std_logic_vector(255 downto 0);
signal din_datavalid_after_fifo_not   : std_logic;
signal din_datavalid_after_fifo       : std_logic;

signal datain_buffer_valid   : std_logic;
signal dataout_pre           : std_logic_vector(31 downto 0);
signal dataout_valid_pre     : std_logic;
signal din_datajoined        : std_logic_vector(255 downto 0);
signal din_newprotocol       : std_logic_vector(16*24 downto 0);

signal tx_busy               : std_logic;
signal data_out_valid        : std_logic;
signal fifo_rd_en            : std_logic;
signal din_fifofull_pre      : std_logic;

COMPONENT ila_1
        PORT (
        clk : IN STD_LOGIC;
        probe0 : IN STD_LOGIC_VECTOR(255 DOWNTO 0);
        probe1 : IN STD_LOGIC;
        probe2 : IN STD_LOGIC;
        probe3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        probe4 : IN STD_LOGIC;
        probe5 : IN STD_LOGIC;
        probe6 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        probe7 : IN STD_LOGIC_VECTOR(255 DOWNTO 0);
        probe8 : IN STD_LOGIC;
        probe9 : IN STD_LOGIC;
        probe10: IN STD_LOGIC
        
        );
END COMPONENT;

component fifo_dataprep
  PORT (
    clk : IN STD_LOGIC;
    srst : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(255 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(255 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC
  );
END  component;

begin
    dataout<= dataout_pre;
    dataout_valid<= dataout_valid_pre;
    
    ila_1_impl : ila_1
        PORT MAP (
            clk    => clk,                     
            probe0 => datain_buffer,            --  probe0 : IN STD_LOGIC_VECTOR(255 DOWNTO 0);  
            probe1 => datain_buffer_valid,      --  probe1 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);    
            probe2 => din_datavalid,            --  probe2 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);    
            probe3 => dataout_pre,                  --  probe3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);   
            probe4 => dataout_valid_pre,            --  probe4 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);    
            probe5 => dataout_ready,            --  probe5 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);    
            probe6 => pointer,                   --  probe6 : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
            probe7 => din_datajoined_after_fifo,      
            probe8 => din_datavalid_after_fifo,
            probe9 => fifo_rd_en,
            probe10=> din_fifofull_pre
            );
            


    
--    COMPONENT ila_1
--  PORT (
--  clk  : IN STD_LOGIC;
--  probe0 : IN STD_LOGIC_VECTOR(255 DOWNTO 0);
--  probe1 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
--  probe2 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
--  probe3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
--  probe4 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
--  probe5 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
--  probe6 : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
--  );
--    END COMPONENT;


  dataAssembly: process (clk, reset) begin
  
--  NEW PROTOCOL
--  ___________________________
--  7 step[20:14]              * 9bits
--  1 line_enable_s            *
--  1 always                   *
--  ___________________________
--  7 step[13:7]               * 9bits
--  1 scan_enable_s            *
--  1 always                   *
--  ___________________________
--  7 step[6:0]                * 9bits
--  1 write_pixel_enable       *
--  1 always                   *
--  ___________________________
--  8 time_fine_laser          * 9bits
--  1 valid_data_tdc_laser     *
--  ___________________________
--  8 time_fine_ch             * 9bits x max 21
--  1 valid_data_tdc_hit       *
--  ___________________________
    


--    din_newprotocol   <=  std_logic_vector(to_unsigned(  0,6))  &  din_step(20 downto 14) & din_line   & "1"              & "0" &
--                          std_logic_vector(to_unsigned(  1,6))  &  din_step(13 downto 7)  & din_scan   & "1"              & "0" &
--                          std_logic_vector(to_unsigned(  2,6))  &  din_step(6 downto  0)  & din_pixel  & "1"              & "0" &
--                          std_logic_vector(to_unsigned(  3,6))  &  din_value_L                         & din_valid_L      & "0" &
--                          std_logic_vector(to_unsigned(  4,6))  &  din_value_CH(0)                     & din_valid_CH(0)  & "0" &
--                          std_logic_vector(to_unsigned(  5,6))  &  din_value_CH(1)                     & din_valid_CH(1)  & "0" &
--                          std_logic_vector(to_unsigned(  6,6))  &  din_value_CH(2)                     & din_valid_CH(2)  & "0" &
--                          std_logic_vector(to_unsigned(  7,6))  &  din_value_CH(3)                     & din_valid_CH(3)  & "0" &
--                          std_logic_vector(to_unsigned(  8,6))  &  din_value_CH(4)                     & din_valid_CH(4)  & "0" &
--                          std_logic_vector(to_unsigned(  9,6))  &  din_value_CH(5)                     & din_valid_CH(5)  & "0" &
--                          std_logic_vector(to_unsigned( 10,6))  &  din_value_CH(6)                     & din_valid_CH(6)  & "0" &
--                          std_logic_vector(to_unsigned( 11,6))  &  din_value_CH(7)                     & din_valid_CH(7)  & "0" &
--                          std_logic_vector(to_unsigned( 12,6))  &  din_value_CH(8)                     & din_valid_CH(8)  & "0" &
--                          std_logic_vector(to_unsigned( 13,6))  &  din_value_CH(9)                     & din_valid_CH(9)  & "0" &
--                          std_logic_vector(to_unsigned( 14,6))  &  din_value_CH(10)                    & din_valid_CH(10) & "0" &
--                          std_logic_vector(to_unsigned( 15,6))  &  din_value_CH(11)                    & din_valid_CH(11) & "0" &
--                          std_logic_vector(to_unsigned( 16,6))  &  din_value_CH(12)                    & din_valid_CH(12) & "0" &
--                          std_logic_vector(to_unsigned( 17,6))  &  din_value_CH(13)                    & din_valid_CH(13) & "0" &
--                          std_logic_vector(to_unsigned( 18,6))  &  din_value_CH(14)                    & din_valid_CH(14) & "0" &
--                          std_logic_vector(to_unsigned( 19,6))  &  din_value_CH(15)                    & din_valid_CH(15) & "0" &
--                          std_logic_vector(to_unsigned( 20,6))  &  din_value_CH(16)                    & din_valid_CH(16) & "0" &
--                          std_logic_vector(to_unsigned( 21,6))  &  din_value_CH(17)                    & din_valid_CH(17) & "0" &
--                          std_logic_vector(to_unsigned( 22,6))  &  din_value_CH(18)                    & din_valid_CH(18) & "0" &
--                          std_logic_vector(to_unsigned( 23,6))  &  din_value_CH(19)                    & din_valid_CH(19) & "0" &
--                          std_logic_vector(to_unsigned( 24,6))  &  din_value_CH(20)                    & din_valid_CH(20) & "0";
                
    




  
  
    din_datajoined   <=     "0000" & din_valid_L & din_pixel & din_line & din_scan -- imaging
                        & din_value_L(7 downto 0) -- sync fine stamp                   
                        & din_step(15 downto 8)
                        & din_step(7 downto 0)         -- macro counter 
    
                        & "0001" & din_valid_CH(0) & din_valid_CH(1) & din_valid_CH(2) & "0"                  
                        & din_value_CH(0)   -- ch1                    
                        & din_value_CH(1)   -- ch2                     
                        & din_value_CH(2)   -- ch3    
    
                        & "0010" & din_valid_CH(3) & din_valid_CH(4) & din_valid_CH(5) & "0"                  
                        & din_value_CH(3)   -- ch4                    
                        & din_value_CH(4)   -- ch5                     
                        & din_value_CH(5)   -- ch6                
    
                        
                        & "0011" & din_valid_CH(6) & din_valid_CH(7) & din_valid_CH(8) & "0"                  
                        & din_value_CH(6)   -- ch7                    
                        & din_value_CH(7)   -- ch8                     
                        & din_value_CH(8)   -- ch9 
                        
                        & "0100" & din_valid_CH(9) & din_valid_CH(10) & din_valid_CH(11) & "0"                  
                        & din_value_CH(9)   -- ch10                    
                        & din_value_CH(10)  -- ch11                     
                        & din_value_CH(11)  -- ch12
                        
                        & "0101" & din_valid_CH(12) & din_valid_CH(13) & din_valid_CH(14) & "0"                  
                        & din_value_CH(12)  -- ch13                    
                        & din_value_CH(13)  -- ch14                     
                        & din_value_CH(14)  -- ch15
                        
                        & "0110" & din_valid_CH(15) & din_valid_CH(16) & din_valid_CH(17) & "0"                  
                        & din_value_CH(15)  -- ch16                    
                        & din_value_CH(16)  -- ch17                     
                        & din_value_CH(17)  -- ch18    
                                                                                         
                        & "0111" & din_valid_CH(18) & din_valid_CH(19) & din_valid_CH(20) & "0"                  
                        & din_value_CH(18)   -- ch19                    
                        & din_value_CH(19)   -- ch20                     
                        & din_value_CH(20);  -- ch21
     
   if (reset='1') then
                datain_buffer       <= (others=>'1');
                datain_buffer_valid <= '0';
                
                dataout_valid_pre <= '0';
                pointer <= (others=>'0');
                fifo_rd_en <= '0';
   else  
     if (rising_edge(clk)) then
     
           dataout_valid_pre <= '0'; 
           fifo_rd_en <= '0';
           
               if ((dataout_ready='1') and (datain_buffer_valid='1')) then
                       pointer <= std_logic_vector(unsigned(pointer)+1);
                       
                       
                       for i in 0 to DATAUSBWORDS-1 loop
                          --if (pointer = std_logic_vector(to_unsigned(i,8))) then --for reverse
                            if (pointer = std_logic_vector(to_unsigned(DATAUSBWORDS-1-i,8))) then --for reverse
                                dataout_pre <= datain_buffer(32*(i+1)-1 downto 32*i);
                                dataout_valid_pre <= '1';
                            end if;
                       end loop;
    
                       if (pointer >= std_logic_vector(to_unsigned(DATAUSBWORDS-1,8))) then
                            pointer <= (others=>'0');                   
                                if (din_datavalid_after_fifo='0') then
                                        datain_buffer       <= (others=>'1');
                                        datain_buffer_valid <= '0';
                                else   
                                        datain_buffer        <= din_datajoined_after_fifo;
                                        datain_buffer_valid  <= din_datavalid_after_fifo;
                                        fifo_rd_en           <= '1';
                                end if;                
                       end if;
                      
               end if;
    
               if ((din_datavalid_after_fifo='1') and ( (datain_buffer_valid='0')
                                             or (pointer = std_logic_vector(to_unsigned(DATAUSBWORDS-1,8)))
                                            )) then
                      datain_buffer <= din_datajoined_after_fifo;
                      datain_buffer_valid  <= din_datavalid_after_fifo;
                      fifo_rd_en           <= '1';
               end if;

           
      end if;       
    end if;       
  end process;
  
 din_datavalid_after_fifo <= not din_datavalid_after_fifo_not;
 din_fifofull <= din_fifofull_pre;
 
   fifo_dataprep_impl : fifo_dataprep
          PORT MAP(
            clk    => clk,
            srst   => reset,
            din    => din_datajoined,
            wr_en  => din_datavalid,
            rd_en  => fifo_rd_en,
            dout   => din_datajoined_after_fifo,
            full   => din_fifofull_pre,
            empty  => din_datavalid_after_fifo_not
          );

end dataprep;
