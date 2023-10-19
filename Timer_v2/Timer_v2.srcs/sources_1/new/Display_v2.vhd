----------------
--DISPLAY
----------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Display_v2 is
    port(clk: in std_logic;
         nr: in std_logic_vector(15 downto 0);
         an: out std_logic_vector(7 downto 0);
         cat: out std_logic_vector(6 downto 0));
end Display_v2;

architecture Behavioral of Display_v2 is

signal counter: std_logic_vector(15 downto 0) := (others => '0');
signal input_decoder: std_logic_vector(3 downto 0);

begin

--counting
process(clk, counter)
    begin 
        if(rising_edge(clk)) then counter <= counter + 1;
        end if;
end process;

--anodes
--the first 4 should be always turned off
process(counter)
    begin
        case counter(15 downto 14) is 
            when "00" => an <= "11111110";
            when "01" => an <= "11111101";
            when "10" => an <= "11111011";
            when others => an <= "11110111";
        end case;
end process;

--digits
process(counter, nr)
    begin
        case counter(15 downto 14) is 
            when "00" => input_decoder <= nr(3 downto 0);
            when "01" => input_decoder <= nr(7 downto 4);
            when "10" => input_decoder <= nr(11 downto 8);
            when others => input_decoder <= nr(15 downto 12);
        end case;
end process;

--cathodes
process(input_decoder)
begin
	 case input_decoder is
		when "0000" => cat<="0000001";
		when "0001" => cat<="1001111";
		when "0010" => cat<="0010010";
		when "0011" => cat<="0000110";
		when "0100" => cat<="1001100";
		when "0101" => cat<="0100100";
		when "0110" => cat<="0100000";
		when "0111" => cat<="0001111";
		when "1000" => cat<="0000000";
		when "1001" => cat<="0000100";
		when others => cat<="0111000";
		end case;
end process;

end Behavioral;
