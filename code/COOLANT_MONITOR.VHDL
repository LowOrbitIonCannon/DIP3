--VHDL DI P1 Aufgabe Überwachung der Motorkühlung mittels MooreAutomat und Metastabilität
-- Funktion:  Motorkühlung überwachung
-- Autor:  Loic Fernau & Niklas Bamman
-- Datum:   13.05.2020
-- 

entity COOLANT_MONITORING is
	port(
		CLK : in bit; -- Clock
		RESET: in bit;
		S : in bit_vector(2 downto 0); -- 3bit input vector 
		RT_L : out bit; -- Rot LED
		GE_L : out bit; -- Gelb LED
		GN_L : out bit -- Green LED
	);
end COOLANT_MONITORING;

architecture FSM of COOLANT_MONITORING is
	type FSM_STATE is (INIT, A, B, C, D); --enumerated State Types
	signal NEXT_STATE : FSM_STATE := INIT; -- initialize with INIT
	signal STATE : FSM_STATE := INIT;
	signal LED: bit_vector(2 downto 0);
	signal S_INT: bit_vector(2 downto 0);
	signal S_BUFFER: bit_vector(2 downto 0);
begin

	-- Synchronisations-Flipflop
	SYNC_D_FF: process(CLK)
	begin
		if CLK'event and CLK = '1' then
			S_INT <= S;
		end if;
	end process SYNC_D_FF;

	-- Puffer-Flipflop
	BUFFER_D_FF: process(CLK)
	begin
		if CLK'event and CLK = '1' then
			S_BUFFER <= S_INT;
		end if;
	end process BUFFER_D_FF;

	-- Eingangsschaltnetz
	INPUT_LUT: process(S_BUFFER)
	begin
		case S_BUFFER is
			when "111" => NEXT_STATE <= A;
			when "011" => NEXT_STATE <= B;
			when "101" => NEXT_STATE <= B;
			when "110" => NEXT_STATE <= B;
			when "001" => NEXT_STATE <= C;
			when "010" => NEXT_STATE <= C;
			when "100" => NEXT_STATE <= C;
			when "000" => NEXT_STATE <= D;
		end case;
	end process INPUT_LUT;

	-- Puffer-Flipflop
	STATE_REGISTER: process(CLK, RESET)
	begin
		if CLK'event and CLK = '1' then
			STATE <= NEXT_STATE;
		end if;

		if RESET = '1'  then
			STATE <= INIT;
		end if;
	end process STATE_REGISTER;

	-- Ausgangsschaltnetz
	OUTPUT_LUT: process(STATE)
	begin
		case STATE is
			when INIT => LED <= "111";
			when A => LED <= "100";
			when B => LED <= "010";
			when C => LED <= "011";
			when D => LED <= "001";
		end case;
	end process OUTPUT_LUT;

	-- Ausgänge zuweisen
	OUTPUT: process(LED)
	begin
		RT_L <= LED(0);
		GE_L <= LED(1);
		GN_L <= LED(2);
	end process OUTPUT;

end FSM;
