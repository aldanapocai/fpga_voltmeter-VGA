library IEEE;
use IEEE.std_logic_1164.all;
use work.utils.all; 

entity mux_n is 
    generic(
        N: natural := 4 --Cant de bits de cada dato
    );
    port(
        d1_i: in std_logic_vector(N-1 downto 0);
        d_dot_i: in std_logic_vector(N-1 downto 0);
        d2_i: in std_logic_vector(N-1 downto 0);
        d3_i: in std_logic_vector(N-1 downto 0);
        d_v_i: in std_logic_vector(N-1 downto 0);
        col_sel_i: in std_logic_vector(9 downto 0);
        row_sel_i: in std_logic_vector(9 downto 0);
        sal_o: out std_logic_vector(N-1 downto 0)
    );
end;


architecture mux_n_arq of mux_n is
    signal selec_pant: std_logic_vector(N downto 0);
    signal char_in, char_out: matrix;

begin
    --Posicionado de los caracteres en pantalla, en 5 posiciones horizontales distintas y continuas
        -- y en la misma linea vertical (row)
                   --(not    (1         or       1      or       1)  )        and       0                       0                1      
    selec_pant(0) <= (not (col_sel_i(9) or col_sel_i(8) or col_sel_i(7)))  and   (not row_sel_i(9) and not row_sel_i(8) and row_sel_i(7)); --col = 000 y row= 001
                      --     0                  0                   1         and       0                       0                1
    selec_pant(1) <= (not col_sel_i(9) and not col_sel_i(8) and col_sel_i(7)) and   (not row_sel_i(9) and not row_sel_i(8) and row_sel_i(7)); --col = 001 y row= 001
                    --      0                   1                   0         and       0                       0                1
    selec_pant(1) <= (not col_sel_i(9) and col_sel_i(8) and not col_sel_i(7)) and (not row_sel_i(9) and not row_sel_i(8) and row_sel_i(7)); --col = 010 y row= 001
                    --      0                   1               1             and       0                       0                1        
    selec_pant(1) <= (not col_sel_i(9) and col_sel_i(8) and col_sel_i(7)) and  (not row_sel_i(9) and not row_sel_i(8) and row_sel_i(7)); --col = 011 y row= 001
                    --      1                   0               0             and
    selec_pant(1) <= (col_sel_i(9) and not col_sel_i(8) and not col_sel_i(7)) and  (not row_sel_i(9) and not row_sel_i(8) and row_sel_i(7)); --col = 100 y row= 001

    char_in(0) <= d1_i;
    char_in(1) <= d_dot_i;
    char_in(2) <= d2_i;
    char_in(3) <= d3_i;
    char_in(4) <= d_v_i;


    aaa: for i in 0 to N-1 generate 
        sal_o(i) <= (ent_i(i+N) and sel_i) or (ent_i(i and (not sel_i)));
    end generate;
end;