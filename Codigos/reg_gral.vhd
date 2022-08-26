library IEEE;
use IEEE.std_logic_1164.all;

entity reg_gral is 
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

architecture reg_gral_arq of reg_gral is


begin
    registro: for i in 0 to N-1 generate
        ffds: entity work.ffd
            port map(
                clk_i => clk_i,
                rst_i => rst_i,
                ena_i => ena_i,
                D_i => D_i(i),
                Q_o => Q_o(i)
            );
    end generate registro;
end;