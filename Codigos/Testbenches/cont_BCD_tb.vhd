library IEEE;
use IEEE.std_logic_1164.all;

entity cont_BCD_tb is
end;

architecture cont_BCD_tb_arq of cont_BCD_tb is
    constant N_tb: natural := 4;
    signal clk_tb: std_logic := '0';
    signal rst_tb: std_logic := '1';
    signal ena_tb: std_logic := '1';
    signal ACU_o_tb: std_logic;
    signal q_tb: std_logic_vector(N_tb-1 downto 0);



    component cont_BCD is 
        generic(
            N: natural := 4
        );
        port(
            clk_i: in std_logic; --Clock sistema    
            rst_i: in std_logic; --Reset sistema
            ena_i: in std_logic; --Enable sistema
            ACU_o: out std_logic; --Habilita siguiente decada del contador de UNOS
            q_o: out std_logic_vector(N-1 downto 0) --Cuenta
        );
    end component;

begin
    clk_tb <= not clk_tb after 10 ns;
    rst_tb <= '0' after 100 ns;

    DUT: cont_BCD
        generic map(
            N => N_tb
        )
        port map(
            clk_i => clk_tb,
            rst_i => rst_tb,
            ena_i => ena_tb,
            ACU_o => ACU_o_tb,
            q_o => q_tb

        );
end;