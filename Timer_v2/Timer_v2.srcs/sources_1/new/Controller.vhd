-----------------------
--CONTROLLER
-----------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

ENTITY Controller IS
  PORT (ss, m, s: in std_logic;
  	   clk, tc: in std_logic;
  	   rst, incr_s, incr_m, mode, keep, alarm_out: out std_logic);
END Controller;


ARCHITECTURE ArchOfController OF Controller IS

--making our own type that declares the system's states
TYPE STATES IS (IDLE, COUNT_UP, HOLD, INCREMENT, COUNT_DOWN, ALARM);
SIGNAL curr_st, next_st: STATES; --memorize the current state and the next one

BEGIN

-------- la fiecare stare trebuie initalizate toate outpurile cu o valoare? sau e de ajuns sa initalizez una cu 1 si restul vor fi 0
PROCESS(m, s, ss, tc, curr_st)
	BEGIN    
	CASE curr_st IS
	WHEN IDLE =>
		IF(ss = '1') THEN next_st <= COUNT_UP;
		ELSIF((m = '1' AND s = '0') or (m = '0' and s = '1')) THEN next_st <= INCREMENT; 
		ELSIF((m = '1' AND s = '1') OR (m = '0' AND s = '0')) THEN next_st <= IDLE; 
		END IF;

	WHEN COUNT_UP =>
        IF(ss = '1') THEN next_st <= HOLD; 
        ELSIF((m = '1' AND s = '0') or (m = '0' and s = '1')) THEN next_st <= INCREMENT; 
        ELSIF((m = '1' AND s = '1') or tc = '1') THEN next_st <= IDLE;
        ELSIF(m = '0' AND s = '0') THEN next_st <= COUNT_UP;
        END IF;

	WHEN HOLD => 
	    IF(ss = '1') THEN next_st <= COUNT_UP;
        ELSIF((m = '1' AND s = '0') or (m = '0' and s = '1')) THEN next_st <= INCREMENT; 
        ELSIF(m = '1' AND s = '1') THEN next_st <= IDLE;
        ELSIF(m = '0' AND s = '0') THEN next_st <= HOLD;
        END IF;

	WHEN INCREMENT => 
		IF(ss = '0') THEN next_st <= INCREMENT; 
		ELSE next_st <= COUNT_DOWN;
		END IF;

	WHEN COUNT_DOWN => 
        IF(tc = '1') THEN next_st <= ALARM;
        ELSIF((m = '1' AND s = '0') or (m = '0' and s = '1')) THEN next_st <= INCREMENT; 
        ELSIF(m = '1' AND s = '1') THEN next_st <= IDLE;
        ELSIF(m = '0' AND s = '0') THEN next_st <= COUNT_DOWN;
        END IF;

	WHEN ALARM =>
		if(ss = '1') then next_st <= IDLE;
        else next_st <= ALARM;
        end if;
	END CASE;
END PROCESS;

--process for changing the current state
PROCESS(next_st, m, s, clk)
	BEGIN 	
	IF(m = '1' AND s = '1') THEN curr_st <= IDLE;
	ELSIF(rising_edge(clk)) THEN curr_st <= next_st;
	END IF;
END PROCESS;

--process for determining the outputs of the controller, send to the other elements 
outputs: process(curr_st, m, s)
    begin
    	case curr_st is
    	   when IDLE => 
            rst <= '1';
            mode <= '0';
            keep <= '0'; 
            alarm_out <= '0';
            if(s = '1' and m = '0') then
            	incr_s <= '1';
            elsif(s = '0' and m = '1') then
            	incr_m <= '1';
            else
	            incr_s <= '0';
	            incr_m <= '0';
	       end if;
            
        	when COUNT_UP  =>
            rst <= '0';
            mode <= '0';
            keep <= '0'; 
            alarm_out <= '0';
            if(s = '1' and m = '0') then
            	incr_s <= '1';
            elsif(s = '0' and m = '1') then
            	incr_m <= '1';
            else
	            incr_s <= '0';
	            incr_m <= '0';
	       end if;
                     
           when HOLD =>
            rst <= '0';
            mode <= '0';
            keep <= '1'; 
            alarm_out <= '0';
             if(s = '1' and m = '0') then
            	incr_s <= '1';
            elsif(s = '0' and m = '1') then
            	incr_m <= '1';
            else
	            incr_s <= '0';
	            incr_m <= '0';
	       end if;
            
         when INCREMENT =>         
            rst <= '0';
            mode <= '0';
            keep <= '1'; 
            alarm_out <= '0';
            if(s = '1' and m = '0') then
            	incr_s <= '1';
            elsif(s = '0' and m = '1') then
            	incr_m <= '1';
            else
	            incr_s <= '0';
	            incr_m <= '0';
	       end if;
	       
         when COUNT_DOWN =>
            rst <= '0';
            mode <= '1';
            keep <= '0'; 
            alarm_out <= '0';
            if(s = '1' and m = '0') then
            	incr_s <= '1';
            elsif(s = '0' and m = '1') then
            	incr_m <= '1';
            else
	            incr_s <= '0';
	            incr_m <= '0';
	       end if;
            
         when ALARM =>
            rst <= '1';
            incr_s <= '0';
            incr_m <= '0';
            mode <= '0';
            keep <= '0'; 
            alarm_out <= '1';
            
       end case;
        
end process outputs;

END ArchOfController;