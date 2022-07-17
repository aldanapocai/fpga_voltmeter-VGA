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
    signal out_incr: std_logic_vector(M-1 downto 0); --Salida del registro anterior incrementada por 1
    signal out_reg: std_logic_vector(M-1 downto 0); --Salida del registro, cuenta anterior
    signal out_rst: std_logic; --Salida del reset que entra al contador, sale de un OR (sistema o max_cuenta)
    signal out_comp: std_logic; --Salida del comparador, entra a la compuerta OR que resulta en la señal out_rst
    
    constant INC: std_logic_vector(M-1 downto 0) := (M-2 downto 0 => '0') & '1'; --Concateno (N-2) 0s con 1

    component reg is 
    generic(
        N: natural :=9
    );
    port(
        clk_i: in std_logic;
        rst_i: in std_logic;
        ena_i: in std_logic;
        D_i: in std_logic_vector(N-1 downto 0);
        Q_o: out std_logic_vector(N-1 downto 0)
    );
    end component;

    component sumNb is
        generic(
            N: natural := 9
        );
        port(
            a_i: in std_logic_vector(N-1 downto 0);
            b_i: in std_logic_vector(N-1 downto 0);
            ci_i: in std_logic;
            s_o: out std_logic_vector(N-1 downto 0);
            co_o: out std_logic
        );
    end component;



begin 
    reg_inst: reg
        generic map(
            N => M
        )
        port map(
            clk_i   => clk_i, 
            rst_i   => out_rst,  --conectado a la salida de la compuerta or: rst sistema o maxima cuenta
            ena_i   => ena_i,
            D_i     => out_incr, --Entra el nuevo valor
            Q_o     => out_reg --Sale el valor anterior(sumador)
        );

    sum_inst: sumNb
        generic map(
            N => M
        )
        port map(
            a_i => out_reg,
            b_i => INC,
            ci_i => '0',
            s_o => out_incr, --Suma a_i + b_i (out_reg + INC)
            co_o => open
        );    


    q_o <= out_reg; --Salida del contador

 --COMPARADOR: comparo de forma logica: decodificando el valor de max_cuenta
        --          1                   0             1                 0                   0               1                   0           1               1
    out_comp <= out_reg(8) and not out_reg(7) and out_reg(6) and not out_reg(5) and not out_reg(4) and out_reg(3) and not out_reg(2) and out_reg(1) and out_reg(0); --max_cuenta '101001011' = 331

    out_rst <= out_comp or rst_i; -- La cuenta se resetea al llegar a max_cuenta o por sistema
    
    q_rst_o <= out_comp;

    --          1                   0             1                 0                   0               1                   0               1                    0
    q_ena_o <= out_reg(8) and not out_reg(7) and out_reg(6) and not out_reg(5) and not out_reg(4) and out_reg(3) and not out_reg(2) and out_reg(1) and not out_reg(0); --max_cuenta '101001010' = 330


end;
