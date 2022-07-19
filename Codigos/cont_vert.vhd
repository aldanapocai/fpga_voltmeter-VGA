library IEEE;
use IEEE.std_logic_1164.all;

entity cont_vert is
    generic(
        N: natural := 10 --Necesito 10 bits para llegar a la max_cuenta = 522
    );
	port(
		clk_i: in std_logic;		-- Clock del sistema
		ena_i: in std_logic;		-- Enable del sistema	
		rst_i: in std_logic;
		Q_o: out std_logic_vector(9 downto 0);
		v_rst: out std_logic
	);
end cont_vert;

architecture cont_vert_arq of cont_vert is
    signal Di_aux, Qi_aux, ACU_aux: std_logic_vector(N-1 downto 0);
    signal rst_aux, out_comp: std_logic; --Nueva entrada del reset (salida del or) y salida del comparador

    begin
        ffd0: entity work.ffd
            port map(
                clk_i   => clk_i,
                rst_i   => rst_aux,
                ena_i   => ena_i,
                D_i     => Di_aux(0),
                Q_o     => Qi_aux(0) 
            );

        Di_aux(0)  <= not Qi_aux(0);
        ACU_aux(0) <= Qi_aux(0);
        
        cont_bin_bloques: for i in 1 to N-1 generate
            cont_bin_bloques_i: entity work.cont_bin_bloque
                port map(
                    clk_i   => clk_i,
                    rst_i   => rst_aux,
                    ena_i   => ena_i,
                    D_i     => Di_aux(i),
                    Q_o     => Qi_aux(i),
                    ACU_o   => ACU_aux(i)
                );
            Di_aux(i)  <= ACU_aux(i-1);
        end generate;

        out_comp <= Qi_aux(9) and (not Qi_aux(8)) and (not Qi_aux(7)) and (not Qi_aux(6)) and (not Qi_aux(5)) and (not Qi_aux(4)) and Qi_aux(3) and (not Qi_aux(2)) and Qi_aux(1) and (not Qi_aux(0)); --522 "1000001010" para que se resetee cont_vert
        rst_aux  <= rst_i or out_comp;

        --Asigno salidas
        v_rst  <= Qi_aux(9) and (not Qi_aux(8)) and (not Qi_aux(7)) and (not Qi_aux(6)) and (not Qi_aux(5)) and (not Qi_aux(4)) and Qi_aux(3) and (not Qi_aux(2)) and (not Qi_aux(1)) and Qi_aux(0); --max cuenta = 521 

        Q_o      <= Qi_aux;
end;
