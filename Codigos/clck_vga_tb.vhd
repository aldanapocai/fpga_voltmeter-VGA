library IEEE;
use IEEE.std_logic_1164.all;

entity clck_VGA_tb is
end;

architecture clck_VGA_tb_arq of clck_VGA_tb is

    signal clk_tb : std_logic := '0';
    signal rst_tb : std_logic := '1';
    signal ena_tb : std_logic := '0';
    signal clk_out_tb: std_logic;

begin
    
    clk_tb <= not clk_tb after 10 ns;
    rst_tb <= '0' after 10 ns;
    ena_tb <= '1' after 10 ns;

    DUT: entity work.clck_vga 
        port map(
            clk_i => clk_tb,
            rst_i => rst_tb,
            ena_i => ena_tb,
            clk_o => clk_out_tb
        );

end;