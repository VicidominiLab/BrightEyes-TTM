library UNISIM;
use UNISIM.vcomponents.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY therm2bin_easy2 IS
	GENERIC (
		out_length		: INTEGER :=9;
		in_length     	: INTEGER :=128
		);
	PORT (
        clock            : IN std_logic;
        reset            : IN std_logic;
        valid	         : IN std_logic;
        thermo           : IN std_logic_vector(((2**out_length)-1) downto 0);
	    bin              : OUT std_logic_vector((out_length-1) downto 0);
	    valid_bin        : OUT std_logic
		);

        		
END therm2bin_easy2;

ARCHITECTURE therm2bin_arch OF therm2bin_easy2 IS


--        integer i;
SIGNAL i : INTEGER;

--        reg [out_length-1:0] bin_r ; 
SIGNAL bin_r : std_logic_vector((out_length-1) downto 0);

--
SIGNAL thermo_pre_r : std_logic_vector(in_length downto 0); 
--        reg [in_length:0] thermo_pre_r;

SIGNAL valid_bin_r : std_logic;
--        reg valid_bin_r;
SIGNAL valid_pre_r: std_logic;
--        reg valid_pre_r;
SIGNAL valid_pre_rr: std_logic;
--        reg valid_pre_rr;


SIGNAL bin_pre0 : std_logic_vector((out_length-1) downto 0); 
SIGNAL bin_pre1 : std_logic_vector((out_length-1) downto 0); 
SIGNAL bin_pre2 : std_logic_vector((out_length-1) downto 0); 
SIGNAL bin_pre3 : std_logic_vector((out_length-1) downto 0);

SIGNAL valid_bin_pre0 : std_logic;
SIGNAL valid_bin_pre1 : std_logic;
SIGNAL valid_bin_pre2 : std_logic;
SIGNAL valid_bin_pre3 : std_logic;

--        reg [out_length-1:0] bin_pre [4:0];
--        reg [4:0] valid_bin_pre ;
        
        
        
BEGIN

    bin <= bin_pre0;
    valid_bin <= valid_bin_pre0;    
       
    --        always @(posedge clock)
    --            begin
    --                thermo_pre_r <= thermo[in_length:0];
    --                valid_pre_rr <= valid;                
    --            end

    process(clock, reset) 
    begin
        if (reset='1') then
            valid_pre_rr <= '0';
            thermo_pre_r <= (others=>'0');
        elsif rising_edge(clock) then
                    thermo_pre_r <= thermo(in_length downto 0);
                    valid_pre_rr <= valid;
        end if;       
    end process;


    --        always @(posedge clock)
    --            begin
    --                //valid_pre_r  <= valid_pre_rr;
    --                valid_bin_r <= valid_pre_rr; 
    --                bin_r=0;
                    
    --                for (i=0; i<in_length; i=i+1)
    --                    begin
    --                         if (thermo_pre_r[i-1]==1'b1) bin_r=i;
    --                    end
    --            end     

    process(clock, reset) 
    begin
        if rising_edge(clock) then
            valid_bin_r <= valid_pre_rr;
            bin_r <= std_logic_vector(to_unsigned(0, out_length));
            
            for i in 0 to in_length-1 loop
                if (thermo_pre_r(i)='1') then
                    bin_r <= std_logic_vector(to_unsigned(i, out_length));
                end if;
            end loop;
        end if;       
    end process;
--        always @(posedge clock)
    --                begin
    --                    bin_pre[3] <= bin_r;
    --                    valid_bin_pre[3] <= valid_bin_r;
                        
    --                    bin_pre[2] <= bin_pre[3];
    --                    valid_bin_pre[2] <= valid_bin_pre[3];
                        
    --                    bin_pre[1] <= bin_pre[2];
    --                    valid_bin_pre[1] <= valid_bin_pre[2];
    
    --                    bin_pre[0] <= bin_pre[1];
    --                    valid_bin_pre[0] <= valid_bin_pre[1];
    
    --                end   
    
    --        assign bin = bin_pre[0];
    --        assign valid_bin = valid_bin_pre[0];
    
    
    
    process(clock, reset) 
    begin
        if rising_edge(clock) then
            bin_pre3 <= bin_r;
            valid_bin_pre3 <= valid_bin_r;
            
            bin_pre2 <= bin_pre3;
            valid_bin_pre2 <= valid_bin_pre3;
            
            bin_pre1 <= bin_pre2;
            valid_bin_pre1 <= valid_bin_pre2;
            
            bin_pre0 <= bin_pre1;
            valid_bin_pre0 <= valid_bin_pre1;    
            

                        
        end if;       
    end process;

END ARCHITECTURE;


        
   
            

    
--endmodule
