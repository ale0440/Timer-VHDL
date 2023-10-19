library ieee;
use ieee.std_logic_1164.all;

entity Debouncer is
	port ( 
			button : in std_logic;
			clk : in std_logic;
			new_button : out std_logic
		  );
end Debouncer;

architecture behavioural of Debouncer is 

signal Q0, Q1, Q2 : std_logic;

begin
	process(clk)
	begin
		if rising_edge(clk) then
			Q2 <= button;
			Q1 <= Q2;
			Q0 <= Q1;
		end if;
	end process;
new_button <= Q2 and Q1 and Q0;

end architecture;