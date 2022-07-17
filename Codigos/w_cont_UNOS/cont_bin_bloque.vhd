library IEEE;
use IEEE.std_logic_1164.all;

entity cont_bin_bloque is
	port(
		clk_i: in std_logic;	-- Clock  sistema
		rst_i: in std_logic;	-- Reset  sistema
		ena_i: in std_logic;	-- Enable sistema
		D_i: in std_logic;    -- Entrada contador
		Q_o: out std_logic;   -- Salida contador
		ACU_o: out std_logic    -- Salida acumuladora de estados anteriores, salida de AND
	);
end;

architecture cont_bin_bloque_arq of cont_bin_bloque is

	component v_ffd is
		port(
			clk: in std_logic;
			rst: in std_logic;
			ena: in std_logic;
			D: in std_logic;
			Q: out std_logic
		);
	end component;

	signal And_i: std_logic;	-- Salida del ACU (compuerta AND anterior), entra sig AND y XOR
	signal Di_ff: std_logic;	--  XOR y ffd
	signal Qi: std_logic;		--  salida ffd y salida del modulo

begin
    ffd: v_ffd
       port map(
		clk => clk_i,		-- Clock del sistema
		rst => rst_i,		-- Rest de ffd
		ena => ena_i,		-- Enable del ffd
		D => Di_ff,
		Q => Qi
	  );
    ACU_o <= And_i and Qi;
    Di_ff <= And_i xor Qi;
    And_i <= D_i; --Primera 
    Q_o <= Qi; --Ultima
end;