----------------
--COUNTER M1
----------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity Counter_M1 is
     port(clk, rst_ct, mode, hold, tc_m0, incr_m, incr_m0: in std_logic;
         tc: out std_logic;
         nr: out std_logic_vector(3 downto 0));
end Counter_M1;

architecture Behavioral of Counter_M1 is

signal digit: std_logic_vector(3 downto 0) := "0000";

begin 

process(clk,rst_ct)
    begin 
        if(rst_ct = '1') then digit <= "0000"; 
        elsif(rising_edge(clk)) then
        	  if(incr_m = '1' and incr_m0 = '1') then  --if incr_m is active and counter_m0 has reached 9 -> 0
        	  	if(digit = 9) then digit <= "0000"; --carry on => go back to 0
                    else digit <= digit + 1;
                    end if;
            elsif(hold = '0' and tc_m0 = '1') then
            if(mode = '0') then --ascending counting 
                if(digit = 9) then digit <= "0000"; --carry on => go back to 0
                else digit <= digit + 1;
                end if;
            elsif(mode = '1') then --descending counting
                if(digit = 0) then digit <= "1001"; --borrow on => go back to 5 
                else digit <= digit - 1; 
                end if;
            end if;
            end if;
        end if;
end process;

tc <= '1' when ((digit = 9 and mode = '0') or (digit = 0 and mode = '1')) else '0';
nr <= digit;

end Behavioral;
