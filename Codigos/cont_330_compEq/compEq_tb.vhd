library IEEE;
use IEEE.std_logic_1164.all;

entity compEq_tb is 
end;

architecture compEq_tb_arq of compEq_tb is

    component compEq is
        generic(
            N: natural :=4
        );
        port(
            a_i: in std_logic_vector(N-1 downto 0);
            b_i: in std_logic_vector(N-1 downto 0);
            s_o: out std_logic
        );
    end component;

    constant N_tb: natural := 9; 
    signal s: std_logic;
    signal a: std_logic_vector(N_tb-1 downto 0) := "101001011";
    signal b: std_logic_vector(N_tb-1 downto 0) := "101001011";
begin
    DUT: compEq
        generic map(
            N => N_tb
        )
        port map(
            a_i  => a,
            b_i  => b,
            s_o  => s
        );
end;