library IEEE;
use IEEE.std_logic_1164.all;


entity cont_330 is 
    generic(
        M: natural := 9
    );
    port(
        clk_i:      in std_logic; --Clock sistema
        rst_i:      in std_logic; --Reset sistema
        ena_i:      in std_logic; --Enable sistema
        q_o:        out std_logic_vector(M-1 downto 0);--Cuenta
        q_ena_o:    out std_logic; --Avisa cuando pasar la cuenta del contador de 1s al registro, cuenta=330
        q_rst_o:    out std_logic --Avisa cuando resetear el contador binario, cuenta=331
    );
end;

architecture cont_330_arq of cont_330 is
    signal and_i_block, qi_block, ACU_block: std_logic_vector(M-1 downto 0); -- Conexiones internas de los bloques del contador
    signal out_rst: std_logic; --Salida del reset que entra al contador, sale de un OR (sistema o max_cuenta)
    signal out_comp: std_logic; --Salida del comparador, entra a la compuerta OR que resulta en la señal out_rst
    

    component ffd is
        port(
            clk_i: in std_logic;
            rst_i: in std_logic;
            ena_i: in std_logic;
            D_i: in std_logic;
            Q_o: out std_logic
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
    ffd0: ffd
        port map(
            clk_i  => clk_i, --Clock sistema
            rst_i   => out_rst, --Reset contador (reset sistema or reset max_cuenta)
            ena_i   => ena_i, --Enable sistema
            D_i     => and_i_block(0), --En el ffd0 en realidad es Q0 negado
            Q_o     => qi_block(0)
        );
    
    and_i_block(0) <= not qi_block(0);
    ACU_block(0)   <= qi_block(0); --Primer valor


    cont_bin_bloque_bloques: for i in 1 to M-1 generate
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
        --          1                   0             1                 0                   0               1                   0           1               1
    out_comp <= qi_block(8) and not qi_block(7) and qi_block(6) and not qi_block(5) and not qi_block(4) and qi_block(3) and not qi_block(2) and qi_block(1) and qi_block(0); --max_cuenta '101001011' = 331

    --          1                   0             1                 0                   0               1                   0               1                    0
    q_ena_o <= qi_block(8) and not qi_block(7) and qi_block(6) and not qi_block(5) and not qi_block(4) and qi_block(3) and not qi_block(2) and qi_block(1) and not qi_block(0); --max_cuenta '101001010' = 330

    --COMPARADOR usando componente externo
    -- compEqinst:  entity work.compEq
    --     generic map(
    --         N => M
    --     )
    --     port map (
    --         a_i => qi_block,
    --         b_i => "101001011", 
    --         s_o => out_comp
    --     );
    
    
    q_rst_o <= out_comp; --Avisa cuando resetear el contador binario (afuera), cuenta=331

    out_rst <= out_comp or rst_i; -- La cuenta se resetea al llegar a max_cuenta o por sistema
    

    q_o <= qi_block;

end;
