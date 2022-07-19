library IEEE;
use IEEE.std_logic_1164.all;

entity cont_hor_tb is
end;

architecture cont_hor_tb_arq of cont_hor_tb is
    constant N_tb: natural := 10;
    signal clk_tb: std_logic := '0';
    signal rst_tb: std_logic := '1';
    signal ena_tb: std_logic := '1';
    signal Q_ena_o_tb: std_logic;
    signal q_tb: std_logic_vector(N_tb-1 downto 0);


    component cont_hor is
        generic(
            N: natural := 10 --Necesito 10 bits para llegar a la max_cuenta = 801
        );
        port(
            clk_i: in std_logic;	-- Clock  sistema
            rst_i: in std_logic;	-- Reset  sistema
            ena_i: in std_logic;	-- Enable sistema
            Q_ena_o: out std_logic;   -- Salida cuenta = 800
            Q_o: out std_logic_vector(N-1 downto 0)    -- Salida acumuladora de estados anteriores, salida de AND
        );
    end component;

    begin
        clk_tb <= not clk_tb after 10 ns;
        rst_tb <= '0' after 100 ns;
    
        DUT: cont_hor
            generic map(
                N => N_tb
            )
            port map(
                clk_i => clk_tb,
                rst_i => rst_tb,
                ena_i => ena_tb,
                Q_ena_o => Q_ena_o_tb,
                q_o => q_tb
            );

end;