----------------
--COUNTER S1
----------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity Counter_S1 is
    port(clk, rst_ct, mode, hold, tc_s0, incr_s: in std_logic;
         tc: out std_logic;
         nr: out std_logic_vector(3 downto 0)); -- it counts only until 5
end Counter_S1;

architecture Behavioral of Counter_S1 is

signal digit: std_logic_vector(3 downto 0) := "0000";

begin

process(clk,rst_ct)
    begin 
        if(rst_ct = '1') then digit <= "0000"; 
        elsif(rising_edge(clk)) then
        	  if(incr_s = '1' and tc_s0 = '1') then --incr_tc is active when the previous counter has reached 9 in increment state 
        	  	if(digit = 5) then digit <= "0000"; --carry on => go back to 0
                    else digit <= digit + 1;
                    end if;
            elsif(hold = '0' and tc_s0 = '1') then --can count
                if(mode = '0') then --ascending counting 
                    if(digit = 5) then digit <= "0000"; --carry on => go back to 0
                    else digit <= digit + 1;
                    end if;
                elsif(mode = '1') then --descending counting
                    if(digit = 0) then digit <= "0101"; --borrow on => go back to 5 
                    else digit <= digit - 1; 
                    end if;
                end if;
             end if;
        end if;
end process;

nr <= digit;
tc <= '1' when (digit = 5 and mode = '0') or (digit = 0 and mode = '1') else '0';

end Behavioral;

