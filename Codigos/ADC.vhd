--Estructura al inicio que almacena en un ffd los valores del voltaje en tiempo real

library IEEE;
use IEEE.std_logic_1164.all;

entity ADC is 
    port(
        clk_i: in std_logic;
        rst_i: in std_logic;
        ena_i: in std_logic;
        D_i: in std_logic; --Voltaje positivo de entrada
        Qn_o: out std_logic; --Voltaje negativo de salida
        Q_ADC: out std_logic; --Salida del modulo
    );
end;

architecture ADC_arq of ADC is

    begin
        ffd0: entity work.ffd_adc
            port map(
                clk_i     => clk_i,
                rst_i     => rst_i,
                ena_i     => ena_i,
                D_i       => D_i,
                Q_o       => Q_ADC,
                Q_n       => Qn_o
            );

end;