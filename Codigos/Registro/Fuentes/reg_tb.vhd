library IEEE;
use IEEE.std_logic_1164.all;
use work.matrix_type.all;

entity reg_tb is
end;


architecture reg_tb_arq of reg_tb is

    constant N_tb: natural:= 4;

    signal clk_tb: std_logic := '0';
    signal rst_tb: std_logic := '1';
    signal ena_tb: std_logic := '0';

    signal q1_tb: std_logic_vector(N_tb-1 downto 0);	
    signal q2_tb: std_logic_vector(N_tb-1 downto 0);	
    signal q3_tb: std_logic_vector(N_tb-1 downto 0);
    signal q_dot_tb: std_logic_vector(N_tb-1 downto 0);
    signal q_v_tb: std_logic_vector(N_tb-1 downto 0);
    
    signal D_tb : matrix := ("0000", "0101", "0110", "1000", "1001");

begin
    clk_tb <= not clk_tb after 10 ns;
    rst_tb <= '0' after 50 ns;
    ena_tb <= '1' after 100 ns, '0' after 150 ns, '1' after 250 ns;
    D_tb <= ("1001", "0101", "0000", "0110", "1000") after 200 ns;

    DUT: entity work.reg 
        port map(
            clk_i => clk_tb,
            rst_i => rst_tb,
            ena_i => ena_tb,
            D_i => D_tb,
            q_1 => q1_tb,
            q_2 => q2_tb,
            q_3 => q3_tb,
            q_dot => q_dot_tb,
            q_v => q_v_tb

    );
end; 








