library IEEE;
use IEEE.std_logic_1164.all;

--Contador de 0 a 9: se resetea al llegar al 9 y tiene como salida el aviso de su max_cuenta

entity cont_BCD is 
    generic(
        N: natural := 4
    );
    port(
        clk_i: in std_logic; --Clock sistema    
        rst_i: in std_logic; --Reset sistema
        ena_i: in std_logic; --Enable sistema
        ACU_o: out std_logic; --Habilita siguiente decada del contador de UNOS
        q_o: out std_logic_vector(N-1 downto 0) --Cuenta
    );
end;

architecture cont_BCD_arq of cont_BCD is

    signal and_i_block, qi_block, ACU_block: std_logic_vector(N-1 downto 0); -- Conexiones internas de los bloques del contador
    signal out_rst: std_logic; --Salida del reset que entra al contador, sale de un OR (sistema o max_cuenta)
    signal out_comp: std_logic; --Salida del comparador, entra a la compuerta OR que resulta en la señal out_rst
    

    component v_ffd
        port(
            clk: in std_logic;
            rst: in std_logic;
            ena: in std_logic;
            D: in std_logic;
            Q: out std_logic
        );
    end component;

    component cont_bin_bloque
        port(
            clk_i: in std_logic;
            rst_i: in std_logic;
            ena_i: in std_logic;
            D_i: in std_logic;
            Q_o: out std_logic;
            ACU_o: out std_logic
        );	
    end component;

begin

    --Instancio primer ffd (0), el unico con conexiones distintas al resto
    ffd0: v_ffd
    port map(
        clk  => clk_i, --Clock sistema
        rst   => out_rst, --Reset contador (reset sistema or reset max_cuenta)
        ena   => ena_i, --Enable sistema
        D     => and_i_block(0), --En el ffd0 en realidad es Q0 negado
        Q     => qi_block(0)
    );

    and_i_block(0) <= not qi_block(0);
    ACU_block(0)   <= qi_block(0); --Primer valor

    cont_bin_bloque_bloques: for i in 1 to N-1 generate
        cont_bin_bloque_i: cont_bin_bloque
            port map(
                clk_i   => clk_i,
                rst_i   => out_rst,
                ena_i   => ena_i, 
                D_i     => and_i_block(i),
                Q_o     => qi_block(i),
                ACU_o   => ACU_block(i) 
            );
        and_i_block(i) <= ACU_block(i-1);

    end generate cont_bin_bloque_bloques;
    

 --COMPARADOR: comparo de forma logica: decodificando el valor de max_cuenta
         --         1                   0               1                   0
   out_comp <= qi_block(3) and not qi_block(2) and qi_block(1) and not qi_block(0); --max_cuenta= 10  = '1010'
         --       1                  0                   0               1   
   ACU_o <= qi_block(3) and not qi_block(2) and not qi_block(1) and qi_block(0); -- 1001 = 9 Avisa cuando habilitar el contador BCD correspondiente a la siguiente decada

   out_rst <= out_comp or rst_i; -- La cuenta se resetea al llegar a max_cuenta o por sistema

   q_o(3) <= qi_block(3);
   q_o(2) <= qi_block(2);
   q_o(1) <= qi_block(1);
   q_o(0) <= qi_block(0);
     
end;