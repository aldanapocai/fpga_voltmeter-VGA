--flipflop

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity v_ffd is
    port(
        clk_i: in std_logic;
        rst_i: in std_logic;
        ena_i: in std_logic;
        D_i: in std_logic;
        Q_o: out std_logic
    );
end;

architecture v_ffd_arq of v_ffd is
    begin
        process(clk_i, rst_i) --escucha por cambios en clk_i, si no hay cambios se mantiene en el anterior (esos cambios pueden ser flancos ascendentes como descendentes)
            begin
            if rst_i = '1' then  --verifica si esta en reset, entonces le asigna a la salida "0"
            Q_o <= '0';
            elsif rising_edge(clk_i) then --rising_edge(clk_i) ==  (clk_i’event and clk_i=’l’) verifica flanco ascendente
                if ena_i = '1' then 
                Q_o <= D_i; -- si el enabled esta en "1" se le asigna la entrada a la salida, sino Q_o mantiene el valor anterior
            end if;
        end if;
    end process;
end;