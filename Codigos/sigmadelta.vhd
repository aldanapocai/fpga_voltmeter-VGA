library IEEE;
use IEEE.std_logic_1164.all;



entity sigmadelta is

    port(
        clk: in std_logic; 
        rst: in std_logic;
        ena: in std_logic;
        v_in: in std_logic; 
        v_out: out std_logic
    );

end;


architecture sigmadelta_arq of sigmadelta is
    begin
  
        registro: entity work.ffd
        port map(
            clk_i => clk,
            rst_i => rst,
            ena_i => ena,
            D_i   => v_in,
            Q_o   => v_out
        );

end;