library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--Unidad controladora de VGA

entity VGA_unit is
    generic(
        N: natural:= 10 
    );
    port(
        clk_i: in std_logic;
        rst_i: in std_logic;
        ena_i: in std_logic; 
        red_i: in std_logic;
        grn_i: in std_logic;
        blu_i: in std_logic;
        sinh_o: out std_logic;
        sinv_o: out std_logic;
        red_o: out std_logic;
        grn_o: out std_logic;
        blu_o: out std_logic;
        pos_h: out std_logic_vector(N-1 downto 0);
        pos_v: out std_logic_vector(N-1 downto 0);
        ena_reg: out std_logic
    );
end;


architecture VGA_unit_arq of VGA_unit is
    
    constant hpixels: unsigned(N-1 downto 0) := to_unsigned(800, 10);	-- Pixeles en una linea (800, "1100100000")
	constant vlines: unsigned(N-1 downto 0) := to_unsigned(521, 10);	-- Lineas en el display (521, "1000001001")

	constant hpw: natural := 96; 									-- Ancho del pulso de sincronismo horizontal 
	constant hbp: unsigned(7 downto 0) := to_unsigned(144, 8);		-- Backporch horizontal (144, "0010010000")
	constant hfp: unsigned(N-1 downto 0) := to_unsigned(784, 10);	 	-- Frontporch horizontal (784, "1100010000")

	constant vpw: natural := 2; 									-- Ancho del pulso de sincronismo vertical
	constant vbp: unsigned(N-1 downto 0) := to_unsigned(31, 10);	 	-- Back porch vertical (31, "0000011111")
	constant vfp: unsigned(N-1 downto 0) := to_unsigned(511, 10);		-- Front porch vertical (511, "0111111111")

	signal hc, vc: std_logic_vector(N-1 downto 0);					-- Contadores horizontal y vertical

	signal vidon: std_logic;										-- Permite visualizar valores en pantalla

    signal ena_h, ena_v: std_logic;

    signal aux_pos_h, aux_pos_v: std_logic_vector(N-1 downto 0); --Posicion dentro de la pantalla

    component cont_vert is
        generic(
            N: natural := 10 --Necesito 10 bits para llegar a la max_cuenta = 522
        );
        port(
            clk_i: in std_logic;		-- Clock del sistema
            ena_i: in std_logic;		-- Enable del sistema	
            rst_i: in std_logic;
            Q_o: out std_logic_vector(N-1 downto 0);
            v_rst: out std_logic
            );
    end component;

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

    component mux_base is
        port(
            mux_x:   in std_logic;
            mux_y:   in std_logic;
            mux_sel: in std_logic;
            mux_out: out std_logic
        ); 
    end component;

    begin
        ena_h <= '1';

        cont_h: cont_hor
            port map(
                clk_i    => clk_i,
                rst_i    => rst_i,
                ena_i    => ena_h,
                Q_ena_o  => ena_v,
                Q_o      => hc --cuenta horizontal
            );
            
        cont_v: cont_vert
            port map(
                clk_i    => clk_i,
                ena_i    => ena_v,
                rst_i    => rst_i,
                Q_o     => vc, --cuenta vertical
                v_rst    => ena_reg --ultima linea pantalla
            );
    --los pulsos de sincronimos estan determinads por una cuenta horizontal menor a 97 y una  cuenta vertical menor a 3 
    sinh_o <= not(hc(9) or hc(8) or hc(7) or (hc(6) and hc(5) and (hc(4) or hc(3) or hc(2) or hc(1) or hc(0))));
    sinv_o <= not(vc(9) or vc(8) or vc(7) or vc(6) or vc(5) or vc(4) or vc(3) or vc(2) or (vc(1) and vc(0)));
    
    --Vidon habilitado (pantalla visible): (backporch hor < cuenta hor <  frontponch hor) & (backporch vert < cuenta vert < frontporch vert ) 
    vidon <= ((hc(9) or hc(8) or (hc(7) and (hc(6) or hc(5) or (hc(4) and (hc(3) or hc(2) or hc(1) or hc(0))))))	-- hbp < hc
                and (not hc(9) or not hc(8) or (not hc(7) and not hc(6) and not hc(5) and not hc(4))))					-- hc < hfp
            and
            ((vc(9) or vc(8) or vc(7) or vc(6) or vc(5))	-- vbp < vc
                and (not vc(9) and not (vc(8) and vc(7) and vc(6) and vc(5) and vc(4) and vc(3) and vc(2) and vc(1) and vc(0))));	-- vc < vfp

    --Salidas por pantalla solo cuando existe entrada y se esta en la posicion de la pantalla visible
    red_o <= red_i and vidon;									
    grn_o <= grn_i and vidon; 
    blu_o <= blu_i and vidon;	


    --Posicion dentro de la pantalla
    aux_pos_h <= std_logic_vector(unsigned(hc) - hbp);
    aux_pos_v <= std_logic_vector(unsigned(vc) - vbp);
    

    mux_bloque: for i in 0 to N-1 generate
        mux_base_pos_h: mux_base
            port map(
                mux_x       => hc(i),
                mux_y       => aux_pos_h(i),
                mux_sel     => vidon,
                mux_out     => pos_h(i)
            );

        mux_base_pos_v: mux_base
            port map(
                mux_x       => vc(i),
                mux_y       => aux_pos_v(i),
                mux_sel     => vidon,
                mux_out     => pos_v(i)
            ); 
    end generate;



end;