----------------
--COUNTER M0
----------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity Counter_M0 is
     port(clk, rst_ct, incr_m, mode, hold, tc_s1, incr_s: in std_logic;
         tc: out std_logic;
         nr: out std_logic_vector(3 downto 0));
end Counter_M0;

architecture Behavioral of Counter_M0 is

signal digit: std_logic_vector(3 downto 0) := "0000";

begin 

process(clk,rst_ct)
    begin 
        if(rst_ct = '1') then digit <= "0000";  
        elsif(rising_edge(clk)) then
            if(incr_m = '1' or  (incr_s = '1' and tc_s1 = '1')) then 
                    if(digit = 9) then digit <= "0000";
                    else digit <= digit + 1; 
                    end if;
            elsif(hold = '0' and tc_s1 = '1') then 
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

tc <= '1' when ((digit = 9 and mode = '0') or (digit = 0 and mode = '1') or (digit = 9 and incr_m = '1')) else '0';
nr <= digit;

end Behavioral;