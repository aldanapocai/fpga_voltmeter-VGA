library IEEE;
use IEEE.std_logic_1164.all;

entity mux_n is 
    generic(
        N: natural := 4 --Cant de bits de cada dato
    );
    port(
        ent_i: in std_logic_vector();
        sal_o: out std_logic_vector(N-1 downto 0)
    );
end;


architecture mux_n_arq of mux_n is

begin
    aaa: for i in 0 to N-1 generate 
        sal_o(i) <= (ent_i(i+N) and sel_i) or (ent_i(i and (not sel_i)));
    end generate;
end;