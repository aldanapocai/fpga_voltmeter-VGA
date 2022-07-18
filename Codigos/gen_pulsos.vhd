--Para el sincronimo de VGA

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity genPulsos is
    generic(
        N: natural := 10;
        max_cuenta: natural := 800;
        P_A: natural := 120; --flanco asc del pulso (en ciclos de reloj)
        P_D: natural := 126; --flanco des del pulso (en ciclos de reloj)
    );
    port(
        clk_i: in std_logic;
        clk_i: in std_logic;
        Q_o: out std_logic;
        max_count_ena: out std_logic
    );
end;

architecture genPulsos_arq of genPulsos is
    signal rstOr, enaSignal, salComp1, salComp2: std_logic;
    signal cuenta: std_logic_vector(N-1 dowto 0);

begin ffd_inst: entity work.v_ffd
    port map(
        clk_i => clk_i,
        rst_i => rstOr,
        ena_i =>  salComp1,
        D_i   =>  '1',
        Q_o   =>  Q_o
    );

    rstOr <= rst_i or salComp2;

  --  salComp1 <= '1' when (unsigned(cuenta) == to_unsigned(P_A, N)) else '0';
--  salComp2 <= '1' when (unsigned(cuenta) == P_D) else '0';

    const_inst: entity work.contNbits