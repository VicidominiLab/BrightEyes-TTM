library UNISIM;
use UNISIM.vcomponents.all;

library ieee;
use ieee.std_logic_misc.or_reduce;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;
use work.mytypes.all;

entity datapreparation_new is
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
end datapreparation_new;

architecture datapreparation_new_i of datapreparation_new is

constant DATAUSBWORDS                   : INTEGER:=(CHANNELS+5)/2;
constant DATAUSBWORDS_BEGIN_OF_HEADER   : INTEGER:=((CHANNELS+5)/2)-3;
constant FIFO_DATAPREP_SIZE             : INTEGER:=479;
    

signal pointer                        : std_logic_vector(7 downto 0);
signal datain_buffer                  : std_logic_vector(16*(CHANNELS+5)-1 downto 0);
signal datain_buffer_failsafe_flag    : std_logic;
signal datain_buffer_no_channels_hit  : std_logic;

signal din_datajoined_after_fifo      : std_logic_vector(16*(CHANNELS+5)-1 downto 0);
signal din_datavalid_after_fifo_not   : std_logic;
signal din_datavalid_after_fifo       : std_logic;

signal datain_buffer_valid   : std_logic;
signal dataout_pre           : std_logic_vector(31 downto 0);
signal dataout_valid_pre     : std_logic;
signal din_datajoined        : std_logic_vector(16*(CHANNELS+5)-1 downto 0);
--signal din_newprotocol       : std_logic_vector(16*24 downto 0);

signal tx_busy               : std_logic;
signal data_out_valid        : std_logic;
signal fifo_rd_en            : std_logic;
signal din_fifo_full_pre      : std_logic;
signal din_fifo_prog_full_pre      : std_logic;

signal fifo_dataprep_din  : STD_LOGIC_VECTOR(FIFO_DATAPREP_SIZE DOWNTO 0);
signal fifo_dataprep_dout : STD_LOGIC_VECTOR(FIFO_DATAPREP_SIZE DOWNTO 0);



COMPONENT ila_data
        PORT (
        clk : IN STD_LOGIC;
        probe0 : IN STD_LOGIC_VECTOR(95 DOWNTO 0);
        probe1 : IN STD_LOGIC;
        probe2 : IN STD_LOGIC;
        probe3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        probe4 : IN STD_LOGIC;
        probe5 : IN STD_LOGIC;
        probe6 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        probe7 : IN STD_LOGIC_VECTOR(95 DOWNTO 0);
        probe8 : IN STD_LOGIC;
        probe9 : IN STD_LOGIC;
        probe10: IN STD_LOGIC
        
        );
END COMPONENT;



component fifo_dataprep
  PORT (
    clk : IN STD_LOGIC;
    srst : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(FIFO_DATAPREP_SIZE DOWNTO 0); --: IN STD_LOGIC_VECTOR(16*(CHANNELS+5)-1 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(FIFO_DATAPREP_SIZE DOWNTO 0); --: OUT STD_LOGIC_VECTOR(16*(CHANNELS+5)-1 DOWNTO 0);
    full : OUT STD_LOGIC;
    prog_full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC
  );
END  component;

begin


    ila_data_impl : ila_data
        PORT MAP (
            clk    => clk,                     
            probe0 => datain_buffer((CHANNELS+4)*16+15 downto (CHANNELS-1)*16),            --  probe0 : IN STD_LOGIC_VECTOR(255 DOWNTO 0);  
            probe1 => datain_buffer_valid,      --  probe1 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);    
            probe2 => din_datavalid,            --  probe2 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);    
            probe3 => dataout_pre,                  --  probe3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);   
            probe4 => dataout_valid_pre,            --  probe4 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);    
            probe5 => dataout_ready,            --  probe5 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);    
            probe6 => pointer,                   --  probe6 : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
            probe7 => din_datajoined_after_fifo((CHANNELS+4)*16+15 downto (CHANNELS-1)*16),      
            probe8 => din_datavalid_after_fifo,
            probe9 => fifo_rd_en,
            probe10=> din_fifo_full_pre
            );
            

      
-- PROTOCOL v0.2 

    GEN_DIN_DATAJOINED: FOR I IN 0 TO CHANNELS-1 GENERATE
        din_datajoined(I*16+15 DOWNTO I*16)    <=  din_valid_CH(I) & std_logic_vector(to_unsigned( I,7)) & din_value_CH(I);
    END GENERATE;
    
    din_datajoined((CHANNELS+0)*16+15 DOWNTO (CHANNELS+0)*16) <=  "1"                    & std_logic_vector(to_unsigned( 123,7)) & din_stored_failsafe & din_no_channels_hit & din_step(26 downto 21);
    din_datajoined((CHANNELS+1)*16+15 DOWNTO (CHANNELS+1)*16) <=  din_valid_L            & std_logic_vector(to_unsigned( 124,7)) &                            din_value_L           ;
    din_datajoined((CHANNELS+2)*16+15 DOWNTO (CHANNELS+2)*16) <=  "1"                    & std_logic_vector(to_unsigned( 125,7)) & din_pixel               &  din_step(6 downto  0) ; 
    din_datajoined((CHANNELS+3)*16+15 DOWNTO (CHANNELS+3)*16) <=  "1"                    & std_logic_vector(to_unsigned( 126,7)) & din_scan                &  din_step(13 downto 7) ;
    din_datajoined((CHANNELS+4)*16+15 DOWNTO (CHANNELS+4)*16) <=  "1"                    & std_logic_vector(to_unsigned( 127,7)) & din_line                &  din_step(20 downto 14);
        


  dataAssembly: process (clk, reset) begin
     
   if (reset='1') then
                    
                datain_buffer       <= (others=>'1');
                datain_buffer_valid <= '0';
                
                dataout_valid_pre <= '0';
                pointer <= (others=>'0');
                fifo_rd_en <= '0';
   else  
     if (rising_edge(clk)) then

    dataout       <= dataout_pre;
    dataout_valid <= dataout_valid_pre;
    

     
           dataout_valid_pre <= '0'; 
           fifo_rd_en <= '0';
           
               if ((dataout_ready='1') and (datain_buffer_valid='1')) then

               
                       --pointer <= std_logic_vector(unsigned(pointer)+1);
                       
                       
                       for i in 0 to DATAUSBWORDS-1 loop
                            if (pointer = std_logic_vector(to_unsigned(i,8))) then --for reverse
                                pointer <= std_logic_vector(to_unsigned(i+1,8));
                          --if (pointer = std_logic_vector(to_unsigned(DATAUSBWORDS-1-i,8))) then --for reverse
                                dataout_pre <= datain_buffer(32*(i+1)-1 downto 32*i);
                                dataout_valid_pre <= '1';
                            end if;
                       end loop;


                       --if (datain_buffer_failsafe_flag='0') and (datain_buffer_no_channels_hit='0') then                                             
                       if (datain_buffer_failsafe_flag='0') then
                            if (pointer >= std_logic_vector(to_unsigned(DATAUSBWORDS-1,8))) then
                                pointer <= (others=>'0');                   
                                    if (din_datavalid_after_fifo='0') then
                                            datain_buffer       <= (others=>'0');
                                            datain_buffer_valid <= '0';
                                    else   
                                            datain_buffer        <= din_datajoined_after_fifo;                                        
                                            datain_buffer_valid  <= din_datavalid_after_fifo;
                                            fifo_rd_en           <= din_datavalid_after_fifo;
                                    end if;                
                            end if;           
                       else
                           if (pointer < std_logic_vector(to_unsigned(DATAUSBWORDS_BEGIN_OF_HEADER,8))) or 
                              (pointer >= std_logic_vector(to_unsigned(DATAUSBWORDS-1,8))) then
                                                             
                               pointer <= std_logic_vector(to_unsigned(DATAUSBWORDS_BEGIN_OF_HEADER,8));
                               if (din_datavalid_after_fifo='0') then
                                           datain_buffer       <= (others=>'0');
                                           datain_buffer_valid <= '0';
                                   else   
                                           datain_buffer        <= din_datajoined_after_fifo;                                        
                                           datain_buffer_valid  <= din_datavalid_after_fifo;
                                           fifo_rd_en           <= din_datavalid_after_fifo;
                                   end if;                                              
                           end if;
                       end if;
                       

                      
               end if;
    
               if ((din_datavalid_after_fifo='1') and ( (datain_buffer_valid='0')
                                             or (pointer = std_logic_vector(to_unsigned(DATAUSBWORDS-1,8)))
                                            )) then
                      datain_buffer <= din_datajoined_after_fifo;
                      datain_buffer_valid  <= din_datavalid_after_fifo;
                      fifo_rd_en           <= din_datavalid_after_fifo;
               end if;

           
      end if;       
    end if;       
  end process;
  
 datain_buffer_failsafe_flag   <=  datain_buffer((CHANNELS+0)*16+7);
 datain_buffer_no_channels_hit <=  datain_buffer((CHANNELS+0)*16+6);
  
 din_datavalid_after_fifo <= not din_datavalid_after_fifo_not;
 din_fifo_full <= din_fifo_full_pre;
 din_fifo_prog_full <= din_fifo_prog_full_pre;
 
 fifo_dataprep_din(16*(CHANNELS+5)-1 DOWNTO 0) <= din_datajoined;
 din_datajoined_after_fifo                     <= fifo_dataprep_dout(16*(CHANNELS+5)-1 DOWNTO 0);

   fifo_dataprep_impl : fifo_dataprep
          PORT MAP(
            clk    => clk,
            srst   => reset,
            din    => fifo_dataprep_din,
            wr_en  => din_datavalid,
            rd_en  => fifo_rd_en,
            dout   => fifo_dataprep_dout,
            full   => din_fifo_full_pre,
            prog_full => din_fifo_prog_full_pre,
            empty  => din_datavalid_after_fifo_not
          );

end datapreparation_new_i;
