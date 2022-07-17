--Registro generico de N bits

library IEEE;
use IEEE.std_logic_1164.all;

entity reg is 
    generic(
        N: natural :=4
    );
    port(
        clk_i: in std_logic;
        rst_i: in std_logic;
        ena_i: in std_logic;
        D_i: in std_logic_vector(N-1 downto 0);
        Q_o: out std_logic_vector(N-1 downto 0)
    );
end;

architecture reg_arq of reg is

begin
    process(clk_i)
    begin
        if rising_edge(clk_i) then --en flanco ascendente
            if rst_i = '1' then 
                Q_o <= (N-1 downto 0 => '0'); --Asigno N '0's a la salida
            elsif ena_i = '1' then
                Q_o <= D_i; --Asigno entrada a la salida
            end if;
        end if;
    end process;
end;