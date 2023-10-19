-----------------------
--FREQUENCY DIVIDER
-----------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity Freq_Controller is
    Port ( clk : in  STD_LOGIC;
           divided_clk : out  STD_LOGIC);
end Freq_Controller;

architecture Behavioral of Freq_Controller is

signal counter: integer := 1;
signal new_clk: std_logic := '0';

begin

process(clk)
begin
    if rising_edge(clk) then
        if counter =  20000000 then 
            counter <= 1;
            new_clk <= not new_clk ;
        else
            counter <= counter + 1;
        end if;
    end if;
end process;

-- now new_clk can be used as input clk for another components
divided_clk <= new_clk;

end Behavioral;

