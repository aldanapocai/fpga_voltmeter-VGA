library IEEE;
use IEEE.std_logic_1164.all;
use work.matrix_type.all;

entity reg is 
    generic(
        N: natural :=4
    );
    port(
        clk_i: in std_logic;
        rst_i: in std_logic;
        ena_i: in std_logic;
        D_i: in matrix;
        q_1: out std_logic_vector(N-1 downto 0);
        q_2: out std_logic_vector(N-1 downto 0);
        q_3: out std_logic_vector(N-1 downto 0);
        q_dot: out std_logic_vector(N-1 downto 0);
        q_v: out std_logic_vector(N-1 downto 0);
    );
end;

architecture reg_arq of reg is 

    component reg_gral is 
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
    end component;

    constant dot_aux: std_logic_vector(0 to N-1) := ('1','0','1','1');
    constant v_aux: std_logic_vector(0 to N-1) := ('1','0','1','0');
    signal Q_reg_aux: matrix;

begin

    registro: for i in 0 to N generate
        regs_gral: reg_gral
            port map(
                clk_i => clk_i,
                rst_i => rst_i,
                ena_i => ena_i,
                D_i => D_i(i),
                Q_o => Q_reg_aux(i)
            );
    end generate registro;

    q_dot <= dot_aux;
    q_v <= v_aux;
    q_1 <= Q_reg_aux(4);
    q_2 <= Q_reg_aux(3);
    q_3 <= Q_reg_aux(2);

end;
