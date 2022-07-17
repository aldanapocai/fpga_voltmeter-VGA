library IEEE;
use IEEE.std_logic_1164.all;


entity compEq is
    generic(
        N: natural :=4
    );
    port(
        a_i: in std_logic_vector(N-1 downto 0);
        b_i: in std_logic_vector(N-1 downto 0);
        s_o: out std_logic
    );
end;

architecture compEq_arq of compEq is 
    signal aux: std_logic_vector(N downto 0); --Salida del And anterior 

begin
    aux(0) <= '1';
    estruc: for i in 1 to N-1 generate 
        aux(i+1) <= not (a_i(i) xor b_i(i)) and aux(i);
    end generate;
    s_o <= aux(N); --A la salida se le asigna un 1 o 0 segun si a y b son iguales o no, esto esta almacendo en la señal aux(N)
end;