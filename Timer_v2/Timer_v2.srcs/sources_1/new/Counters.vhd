---------------------
--CASCADED COUNTERS
---------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity Counters is 
	port(clk, rst, mode, hold: in std_logic;
		incr_s, incr_m: in std_logic;
		tc: out std_logic;
		nr: out std_logic_vector(15 downto 0));
end Counters;

architecture Behavioral of Counters is

component Counter_S0 is 
	port(clk, rst_ct, incr_s, mode, hold: in std_logic;
         tc: out std_logic; --terminal count
         nr: out std_logic_vector(3 downto 0));
end component;

component Counter_S1 is 
 	port(clk, rst_ct, mode, hold, tc_s0, incr_s: in std_logic;
         tc: out std_logic;
         nr: out std_logic_vector(3 downto 0));
end component;

component Counter_M0 is 
	port(clk, rst_ct, incr_m, mode, hold, tc_s1, incr_s: in std_logic;
         tc: out std_logic;
         nr: out std_logic_vector(3 downto 0));
end component;

component Counter_M1 is 
 	port(clk, rst_ct, mode, hold, tc_m0, incr_m, incr_m0: in std_logic;
         tc: out std_logic;
         nr: out std_logic_vector(3 downto 0));
end component;

signal arr: std_logic_vector(15 downto 0);
signal tc_s0, tc_s1, tc_m0, tc_m1: std_logic;
signal cb_m0, cb_m1: std_logic;

begin 



C1: Counter_S0
	port map(clk => clk, rst_ct => rst, incr_s => incr_s, 
			mode => mode, hold => hold, tc => tc_s0, nr => arr(3 downto 0));

C2: Counter_S1
	port map(clk => clk, rst_ct => rst, tc_s0 => tc_s0, incr_s => incr_s,
			mode => mode, hold => hold, tc => tc_s1, nr => arr(7 downto 4));

cb_m0 <= tc_s0 and tc_s1;

C3: Counter_M0
	port map(clk => clk, rst_ct => rst, incr_m => incr_m, tc_s1 => cb_m0, incr_s => incr_s, 
			mode => mode, hold => hold, tc => tc_m0, nr => arr(11 downto 8));

cb_m1 <= cb_m0 and tc_m0;

C4: Counter_M1
	port map(clk => clk, rst_ct => rst, tc_m0 => cb_m1, incr_m => incr_m, incr_m0 => tc_m0,
			mode => mode, hold => hold, tc => tc_m1, nr => arr(15 downto 12));

nr <= arr;
--terminal count is active when the number reaches 9959 in ascending mode and 0 in descending mode
tc <= '1' when (arr = "1001100101011001" and mode = '0') or (arr = 0 and mode = '1') else '0';

end Behavioral; 