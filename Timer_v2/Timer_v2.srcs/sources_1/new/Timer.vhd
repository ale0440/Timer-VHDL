LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Timer IS
  PORT (ss, m, s: in std_logic;
  	   clk: in std_logic;
  	   alarm_out: out std_logic;
  	   cathodes: out std_logic_vector(6 downto 0);
  	   anodes: out std_logic_vector(7 downto 0));
END Timer;

ARCHITECTURE TypeArchitecture OF Timer IS

component Debouncer is 
	Port (button : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           new_button : out  STD_LOGIC);
end component;

component FrequencyDivider is
	Port (clk : in  STD_LOGIC;
           divided_clk : out  STD_LOGIC);
end component; 

component Controller is 
	PORT (ss, m, s: in std_logic;
  	  	 clk, tc: in std_logic;
  	     rst, incr_s, incr_m, mode, keep, alarm_out: out std_logic);
end component; 

component Counters is 
	port(clk, rst, mode, hold: in std_logic;
		incr_s, incr_m: in std_logic;
		tc: out std_logic;
		nr: out std_logic_vector(15 downto 0));
end component;

component Display_v2 is 
	port(clk: in std_logic;
         nr: in std_logic_vector(15 downto 0);
         an: out std_logic_vector(7 downto 0);
         cat: out std_logic_vector(6 downto 0));
end component; 

component Freq_Controller is
    Port ( clk : in  STD_LOGIC;
           divided_clk : out  STD_LOGIC);
end component;

signal new_ss, new_m, new_s, new_clk: std_logic;
signal tc: std_logic;
---controller outputs
signal rst, incr_s, incr_m, mode, keep: std_logic;
signal arr: std_logic_vector(15 downto 0) := (others => '0');
signal clk_controller: std_logic;

BEGIN

d1: Debouncer port map(button => ss, clk => clk, new_button => new_ss);
d2: Debouncer port map(button => m, clk => clk, new_button => new_m);
d3: Debouncer port map(button => s, clk => clk, new_button => new_s);

f1: FrequencyDivider port map(clk => clk, divided_clk => new_clk);
f2: Freq_Controller port map(clk => clk, divided_clk => clk_controller);

c1: Controller port map(ss => new_ss, m => new_m, s => new_s,
				    clk => clk_controller, tc => tc, rst => rst, incr_s => incr_s, 
				    incr_m => incr_m, mode => mode, keep => keep, alarm_out => alarm_out);

c2: Counters port map(clk => new_clk, rst => rst, mode => mode, hold => keep, 
				  incr_s => incr_s, incr_m => incr_m, tc => tc, nr => arr);

c3: Display_v2 port map(clk => clk, nr => arr, an => anodes, cat => cathodes);

END TypeArchitecture;
