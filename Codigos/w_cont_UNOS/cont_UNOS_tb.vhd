library IEEE;
use IEEE.std_logic_1164.all;       
use work.matrix_type.all;

entity v_cont_UNOS_tb is
end;

architecture v_cont_UNOS_tb_arq of v_cont_UNOS_tb is
    -- Entradas (se inicializan)
    signal clk_tb : std_logic := '0';
	signal rst_tb : std_logic := '1';
    signal ena_tb : std_logic := '0';
    -- Salidas
    signal Q_tb : matrix;

    component cont_UNOS is 
    port(
        clk_i:      in std_logic; --Clock sistema
        rst_i:      in std_logic; --Reset sistema
        ena_i:      in std_logic; --Enable sistema
        Q_o:        out matrix -- 3 contadores BCD de 4 bits cada uno 
    );
    end component;
	
begin 
 	clk_tb <= not clk_tb after 10 ns;
	ena_tb <= '1' after 100 ns;
	rst_tb <= '0' after 100 ns;

    DUT : cont_UNOS
        port map (
            clk_i => clk_tb,
            rst_i => rst_tb,
            ena_i => ena_tb,
            Q_o => Q_tb
        );
end;