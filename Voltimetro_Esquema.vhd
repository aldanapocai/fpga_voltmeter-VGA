library IEEE;
use IEEE.std_logic_1164.all;

entity Voltimetro is
	port(
		sys_clk_i	: in std_logic;						-- Reloj del sistema (para la placa Nexys 2 es de 50 MHz)
		rst_i		: in std_logic;						-- Reset general
		ena_i		: in std_logic;						-- Habilitador general
		v_i			: in std_logic;						-- Entrada de la sucesion de unos y ceros provenientes
														-- del ffd de entrada. Se utiliza como habilitador del
														-- contador BCD de 5 digitos.
		red_o		: out std_logic_vector(2 downto 0);	-- Salida del color rojo
		grn_o		: out std_logic_vector(2 downto 0);	-- Salida del color verde
		blu_o		: out std_logic_vector(1 downto 0);	-- Salida del color azul
		hs_o		: out std_logic;					-- Sicronismo horizontal
		vs_o		: out std_logic						-- Sincronismo vertical
    );
    
	-- Mapeo de pines para el kit Nexys 2 (spartan 3E)
    attribute loc: string;			
	attribute loc of sys_clk_i	: signal is "B8";
	attribute loc of rst_i		: signal is "B18";
	attribute loc of ena_i		: signal is "G18";
	attribute loc of hs_o		: signal is "T4";
	attribute loc of vs_o		: signal is "U3";
	attribute loc of red_o		: signal is "R8 T8 R9";
	attribute loc of grn_o		: signal is "P6 P8 N8";
	attribute loc of blu_o		: signal is "U4 U5";
	attribute loc of v_i		: signal is "R17";
end;

architecture Voltimetro_arq of Voltimetro is

    signal red_s, grn_s, blu_s				: std_logic		-- senales a utilizar como entrada de color
	signal red_o_aux, grn_o_aux, blu_o_aux	: std_logic;	-- senales auxuliares para poder alimentar la salida
															-- VGA de la placa Nexys 2 (tiene 3 bits para los
															-- colores rojo y verde, y dos para el azul)
	signal clk_i: std_logic;								-- reloj de 25 MHz
	
begin
	
	-- Generacion de un reloj de 25 MHz
	-- Si bien no es la mejor mejor es muy practica
	genClock: process(sys_clk_i)
    begin
        if rising_edge(sys_clk_i) then
            clk_i <= not clk_i;
        end if;
    end process;
	 	
	-- Instancia del controlador VGA
	VGA_inst: VGA
		port map(
			clk_i 	=> clk_i,
			rst_i 	=> rst_i,
			ena_i 	=> ena_i,
			red_i 	=> red_s,
			grn_i 	=> grn_s,
			blu_i	=> blu_s,
			red_o	=> red_o_aux,
			grn_o 	=> grn_o_aux,
			blu_o	=> blu_o_aux,
			hs		=> hs,
			vs		=> vs,
			pixel_x	=> pixel_x,
			pixel_y	=> pixel_y
		);
	
	red_o <= (2 downto 0 => red_o_aux);	-- se transforma un bit de rojo en 3
	grn_o <= (2 downto 0 => grn_o_aux);	-- se transforma un bit de verde en 3
	blu_o <= (1 downto 0 => blu_o_aux);	-- se transforma un bit de azul en 2
	
	-- El resto del codigo puede continuar aqui o donde lo prefieran

	
end;