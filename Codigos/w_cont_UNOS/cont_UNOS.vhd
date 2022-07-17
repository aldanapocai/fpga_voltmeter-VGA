library IEEE;
use IEEE.std_logic_1164.all;
use work.matrix_type.all;


entity cont_UNOS is 
    port(
        clk_i:      in std_logic; --Clock sistema
        rst_i:      in std_logic; --Reset sistema
        ena_i:      in std_logic; --Enable sistema
        Q_o:        out matrix --  contadores BCD de 4 bits cada uno 
    );
end;

architecture cont_UNOS_arq of cont_UNOS is
    
    signal ena_bcds: std_logic_vector(4 downto 0);
    signal ACU_bcds: std_logic_vector(4 downto 0); -- Conexiones entre los contadores BCDs
    
    type matrix is array (4 downto 0) of std_logic_vector(3 downto 0); -- Creacion de la salida tipo matriz 7x4
    signal Q_o_bcds: matrix;

    component cont_BCD is 
    port(
        clk_i: in std_logic; --Clock sistema    
        rst_i: in std_logic; --Reset sistema
        ena_i: in std_logic; --Enable sistema
        ACU_o: out std_logic; --Habilita siguiente decada del contador de UNOS
        q_o: out std_logic_vector(3 downto 0) --Cuenta
    );
    end component;

begin 

    ena_bcds(0) <= ena_i; --Habilito cont_BCD menos signicativo
    ena_bcds(1) <= ena_i and ACU_bcds(0);

    cont_BCD_bloques: for i in 0 to 4 generate
        cont_BCD_bloque_i: cont_BCD
            port map(
                clk_i   => clk_i,
                rst_i   => rst_i,
                ena_i   => ena_bcds(i),
                ACU_o   => ACU_bcds(i),
                q_o     => Q_o_bcds(i)
            );

            habilitador : if i>1 generate
                ena_bcds(i) <= ena_i and ACU_bcds(i-1) and ena_bcds(i-1); --Para habilitar el siguiente, se tienen en cuenta los anteriores contadores
            end generate habilitador;

    end generate cont_BCD_bloques;
    
    
	Q_o(4) <= Q_o_bcds(4);
	Q_o(3) <= Q_o_bcds(3);
	Q_o(2) <= Q_o_bcds(2);
	Q_o(1) <= Q_o_bcds(1);
	Q_o(0) <= Q_o_bcds(0);

end;
