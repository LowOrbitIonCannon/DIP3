--VHDL DI P1 Aufgabe Überwachung der Motorkühlung mittels MooreAutomat und Metastabilität
-- Funktion:  Motorkühlung überwachung
-- Autor:  Loic Fernau & Niklas Bamman
-- Datum:   13.05.2020
-- 

ENTITY LED_PANEL IS
  port(
        S : in bit_vector(2 downto 0); -- 3bit input vector 
        --binary_output : out bit_vector(1 downto 0);-- 2bit output vector to check
        clock : in bit; -- Clock
		reset: in bit;
    	GN_L : out bit; -- Green LED
		GE_L : out bit; -- Gelb LED
		RT_L : out bit -- Rot LED
  );
END LED_PANEL;

ARCHITECTURE OVERWATCH OF LED_PANEL IS
	Type statetype IS (INIT, A, B, C, D); --enumerated State Types
	signal state : statetype := INIT; -- initilize with INIT
	signal LED: bit_vector(2 downto 0);
BEGIN


fsm1: PROCESS(state) --Asign output vector to state 
BEGIN
	CASE state IS
		WHEN INIT =>
			LED <= "111";
			
		WHEN A =>
			LED <= "100";	
			
		WHEN B =>
			LED <= "010";
			
		WHEN C =>
			LED <= "011";
			
		WHEN D =>
			LED <= "001";
			
	END CASE;
	--Asign output LEDs
	GN_L <= LED(2);
	GE_L <= LED(1);
	RT_L <= LED(0);
		
END PROCESS;


fsm2: PROCESS(S,clock,reset) --Asigen State to Input
BEGIN
	if (reset = '1')  then --Reset on startup
	
			state <= INIT;

	elsif rising_edge(clock) then --if clocked parse output

		if (S(2) and S(1) and S(0)) = '1' then

			state <= A;

		elsif (S(2) or S(1) or S(0)) = '0' then

			state <= D;

		elsif (S(2) or S(1) or S(0)) = '1' then

			state <= C;

		else 

			state <= B;

		end if;

	end if;

END PROCESS;

END OVERWATCH;



