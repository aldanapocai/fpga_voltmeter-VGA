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

	component ffd is
		port(
			clk_i: in std_logic;
			rst_i: in std_logic;
			ena_i: in std_logic;
			D_i: in std_logic;
			Q_o: out std_logic
		);
	end component;

	signal And_i: std_logic;	-- Salida del ACU (compuerta AND anterior), entra sig AND y XOR
	signal Di_ff: std_logic;	--  XOR y ffd
	signal Qi: std_logic;		--  salida ffd y salida del modulo

begin
    ffd0: ffd
       port map(
		clk_i => clk_i,		-- Clock del sistema
		rst_i => rst_i,		-- Rest de ffd
		ena_i => ena_i,		-- Enable del ffd
		D_i => Di_ff,
		Q_o => Qi
	  );
    ACU_o <= And_i and Qi;
    Di_ff <= And_i xor Qi;
    And_i <= D_i; --Primera 
    Q_o <= Qi; --Ultima
end;