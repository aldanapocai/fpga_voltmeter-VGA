library IEEE;
use IEEE.std_logic_1164.all;

entity cont_330_tb is
end;

architecture cont_330_tb_arq of cont_330_tb is
    constant N_tb: natural := 9;
    signal clk_tb: std_logic := '0';
    signal rst_tb: std_logic := '1';
    signal ena_tb: std_logic := '1';
    signal q_tb: std_logic_vector(N_tb-1 downto 0);
    signal q_ena_o_tb: std_logic;
    signal q_rst_o_tb: std_logic;

    component cont_330 is 
        generic(
            M: natural := 9
        );
    
        port(
            clk_i:      in std_logic; --Clock sistema
            rst_i:      in std_logic; --Reset sistema
            ena_i:      in std_logic; --Enable sistema
            q_o:        out std_logic_vector(M-1 downto 0);--Cuenta
            q_ena_o:    out std_logic; --Avisa cuando pasar la cuenta del contador de 1s al registro, cuenta=330
            q_rst_o:    out std_logic --Avisa cuando resetear el contador binario, cuenta=331
        );

    end component;

begin
    clk_tb <= not clk_tb after 10 ns;
    rst_tb <= '0' after 100 ns;

    DUT: cont_330
        generic map(
            M => N_tb
        )
        port map(
            clk_i => clk_tb,
            rst_i => rst_tb,
            ena_i => ena_tb,
            q_o => q_tb,
            q_ena_o => q_ena_o_tb,
            q_rst_o => q_rst_o_tb
        );
end;