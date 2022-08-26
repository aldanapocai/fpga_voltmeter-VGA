library IEEE;
use IEEE.std_logic_1164.all;

entity reg_gral_tb is
end;

architecture reg_gral_tb_arq of reg_gral_tb is
    constant N_tb: natural := 4;
    signal clk_tb: std_logic := '0';
    signal rst_tb: std_logic := '1';
    signal ena_tb: std_logic := '1';
    signal D_tb : std_logic_vector(N_tb-1 downto 0) := "0000";
    signal Q_tb : std_logic_vector(N_tb-1 downto 0);

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

begin 

    clk_tb <= not clk_tb after 10 ns;
    rst_tb <= '0' after 100 ns;
    ena_tb <= '1' after 100 ns, '0' after 200 ns, '1' after 350 ns;
    D_tb <= "0001" after 150 ns, "0010" after 250 ns, "1000" after 350 ns, "1111" after 450 ns;

    DUT: reg_gral
        generic map(
            N => N_tb
        )
        port map(
            clk_i  => clk_tb,
            rst_i  => rst_tb,
            ena_i  => ena_tb,
            D_i    => D_tb,
            Q_o    => Q_tb
        );
end;