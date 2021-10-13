-------------------------------------------------------------------------------------
-- Company  : Molecular Microscopy & Spectroscopy, Istituto Italiano di Tecnologia
-- Engineers: Alessandro Rossetta, Mattia Donato 
-- Date     : April 2019
-- Design   : Time-Tagging Platform
-- License  : CC BY-NC 4.0 
-------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library UNisIM;
use UNisIM.vcomponents.all;



entity t2b is
	generic (
		out_length		 : integer :=9;
		in_length     	 : integer :=128
		);
	port (
        clock            : in std_logic;
        reset            : in std_logic;
        valid	         : in std_logic;
        thermo           : in std_logic_vector(((2**out_length)-1) downto 0);
	    bin              : out std_logic_vector((out_length-1) downto 0);
	    valid_bin        : out std_logic
		);        		
end t2b;

architecture t2b_structure of t2b is


signal i              : integer;
signal bin_r          : std_logic_vector((out_length-1) downto 0);
signal thermo_pre_r   : std_logic_vector(in_length downto 0); 
signal valid_bin_r    : std_logic;
signal valid_pre_r    : std_logic;
signal valid_pre_rr   : std_logic;
signal bin_pre0       : std_logic_vector((out_length-1) downto 0); 
signal bin_pre1       : std_logic_vector((out_length-1) downto 0); 
signal bin_pre2       : std_logic_vector((out_length-1) downto 0); 
signal bin_pre3       : std_logic_vector((out_length-1) downto 0);
signal valid_bin_pre0 : std_logic;
signal valid_bin_pre1 : std_logic;
signal valid_bin_pre2 : std_logic;
signal valid_bin_pre3 : std_logic;


        
        
        
begin


    bin <= bin_pre0;
    valid_bin <= valid_bin_pre0;    
       


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

end t2b_structure;
