--Reloj en voltimetro_esquema_a7_35_top_level es de 50 MHz, pero el reloj de entrada
--de la VGA tiene que ser de 25 MHz

library IEEE;
use IEEE.std_logic_1164.all;

entity clck_VGA is
    port(
        clk_i: in std_logic;
        rst_i: in std_logic;
        ena_i: in std_logic;
        clk_o: out std_logic
    );
end;

architecture clck_VGA_arq of clck_VGA is
    
    signal q_aux, d_aux: std_logic;

    begin
        d_aux <= not q_aux;

        ffd: entity work.ffd
            port map(
                clk_i => clk_i,
                rst_i => rst_i,
                ena_i => ena_i,
                D_i  => d_aux,
                Q_o  => q_aux
            );

        clk_o <= q_aux;

end;