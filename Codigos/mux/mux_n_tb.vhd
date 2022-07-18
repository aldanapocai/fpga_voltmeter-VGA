library IEEE;
use IEEE.std_logic_1164.all;
use work.utils.all; 

entity mux_n_tb is
end;

architecture mux_n_tb_arq of mux_n_tb is

    constant N_tb: natural := 4;
    signal d1_tb: std_logic_vector(N_tb-1 downto 0)    := "1000";       -- d1= 8, valor entero
    signal d_dot_tb: std_logic_vector(N_tb-1 downto 0) := "1011";       -- d_dot= 11, decodificado como 11
    signal d2_tb: std_logic_vector(N_tb-1 downto 0)    := "0011";       -- d1= 3 primer decimal
    signal d3_tb: std_logic_vector(N_tb-1 downto 0)    := "0001";       -- d1= 1 segundo decimal
    signal d_v_tb: std_logic_vector(N_tb-1 downto 0)   := "1010";       -- d1= d_v= 10, v decodificado como 10
    signal col_sel_tb: std_logic_vector(9 downto 0) := "0000000000"; -- comienza en posicion 0
    signal row_sel_tb: std_logic_vector(9 downto 0) := "0000000000"; -- comienza en posicion 0 
    signal sal_o_tb: std_logic_vector(N_tb-1 downto 0);

begin 
    col_sel_tb <= "0010000000" after 150 ns, "0100000000" after 250 ns, "0110000000" after 350 ns, "1000000000" after 450 ns;
    row_sel_tb <= "0010000000" after 10 ns;

    DUT: entity work.mux_n
        port map(
            d1_i        => d1_tb,
            d_dot_i     => d_dot_tb,
            d2_i        => d2_tb,
            d3_i        => d3_tb,
            d_v_i       => d_v_tb,
            col_sel_i   => col_sel_tb,
            row_sel_i   => row_sel_tb,
            sal_o       => sal_o_tb
        );

end;
