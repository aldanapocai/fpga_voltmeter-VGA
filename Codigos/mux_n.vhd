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
    signal char_in, char_out: matrix(N downto 0); --5x4

begin
    --Posicionado de los caracteres en pantalla, en 5 posiciones horizontales distintas y continuas
        -- y en la misma linea vertical (row)
                   --(not    (1         or       1      or       1)  )        and       0                       0                1      
    selec_pant(0) <= (not (col_sel_i(9) or col_sel_i(8) or col_sel_i(7)))     and   ((not row_sel_i(9)) and (not row_sel_i(8)) and row_sel_i(7)); --col = 000 y row= 001
                      --     0                  0                   1         and       0                       0                1
    selec_pant(1) <= ((not col_sel_i(9)) and (not col_sel_i(8)) and col_sel_i(7)) and   ((not row_sel_i(9)) and (not row_sel_i(8)) and row_sel_i(7)); --col = 001 y row= 001
                    --      0                   1                   0         and       0                       0                1
    selec_pant(2) <= ((not col_sel_i(9)) and col_sel_i(8) and (not col_sel_i(7))) and ((not row_sel_i(9)) and (not row_sel_i(8)) and row_sel_i(7)); --col = 010 y row= 001
                    --      0                   1               1             and       0                       0                1        
    selec_pant(3) <= ((not col_sel_i(9)) and col_sel_i(8) and col_sel_i(7)) and  ((not row_sel_i(9)) and (not row_sel_i(8)) and row_sel_i(7)); --col = 011 y row= 001
                    --      1                   0               0             and
    selec_pant(4) <= (col_sel_i(9) and (not col_sel_i(8)) and (not col_sel_i(7))) and  ((not row_sel_i(9)) and (not row_sel_i(8)) and row_sel_i(7)); --col = 100 y row= 001

    char_in(0) <= d1_i;
    char_in(1) <= d_dot_i;
    char_in(2) <= d2_i;
    char_in(3) <= d3_i;
    char_in(4) <= d_v_i;


    chars_out: for i in 0 to N generate 
        char_out(i) <= (char_in(i)(3) and selec_pant(i)) & (char_in(i)(2) and selec_pant(i)) & (char_in(i)(1) and selec_pant(i)) & (char_in(i)(0) and selec_pant(i));
    end generate;

    sal_o <= char_out(4) or char_out(3) or char_out(2) or char_out(1) or char_out(0);
end;