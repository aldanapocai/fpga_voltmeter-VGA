--Estructura al inicio que almacena en un ffd los valores del voltaje en tiempo real

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity ffd_adc is
    port(
        clk_i: in std_logic;
        rst_i: in std_logic;
        ena_i: in std_logic;
        D_i: in std_logic;
        Q_n: out std_logic;
        Q_o: out std_logic

    );
end;

architecture ffd_adc_arq of ffd_adc is
    begin
        process(clk_i, rst_i) 
            begin
            if rst_i = '1' then  
            Q_o <= '0';
            Q_n <= '1';
            elsif rising_edge(clk_i) then 
                if ena_i = '1' then 
                Q_o <= D_i; 
                Q_n <= not D_i;
            end if;
        end if;
    end process;
end;