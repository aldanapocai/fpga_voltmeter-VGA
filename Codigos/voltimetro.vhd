library IEEE;
use IEEE.std_logic_1164.all;
use work.utils.all;

entity voltimetro is

  port(
    clk: in std_logic;
    rst: in std_logic;
    ent_unos: in std_logic;
    sal_unos: out std_logic;
    hsync : out std_logic;
    vsync : out std_logic;
    red_out : out std_logic;
    grn_out : out std_logic;
    blu_out : out std_logic

  ) ;
 end; 

architecture voltimetro_arq of voltimetro is

  signal clk_aux: std_logic;
  signal rst_aux: std_logic;
  signal clk_VGA: std_logic;

	signal volt_in_diff: std_logic;
  
  signal D_ADC_aux: std_logic;
  signal Q_ADC_aux: std_logic;
  signal Qn_ADC_aux: std_logic;

  
  signal Q_ENA_aux: std_logic;
  signal Q_RST_aux: std_logic;

  signal rst_cont: std_logic;
  signal Q_cont_aux: matrix(4 downto 0);

  signal D1_aux_temp: std_logic_vector(3 downto 0);
  signal D2_aux_temp: std_logic_vector(3 downto 0);
  signal D3_aux_temp: std_logic_vector(3 downto 0);
  signal point_aux: std_logic_vector(3 downto 0);
  signal V_aux: std_logic_vector(3 downto 0);

  signal D1_aux: std_logic_vector(3 downto 0);
  signal D2_aux: std_logic_vector(3 downto 0);
  signal D3_aux: std_logic_vector(3 downto 0);

  signal MUX_out_aux: std_logic_vector(3 downto 0);

  signal pos_h_aux: std_logic_vector(9 downto 0);
  signal pos_v_aux: std_logic_vector(9 downto 0);
  signal rom_out_aux: std_logic;

  signal v_ena_reg_aux: std_logic;
  signal red_aux: std_logic;
  signal grn_aux: std_logic;
  signal blu_aux: std_logic;


  component clck_VGA
      port(
        clk_i: in std_logic;
        rst_i: in std_logic;
        ena_i: in std_logic;
        clk_o: out std_logic
      );
  end component;

  component ADC
      port(
        clk_i: in std_logic;
        rst_i: in std_logic;
        ena_i: in std_logic;|
        D_i: in std_logic; --Voltaje positivo de entrada
        --Qn_o: out std_logic; --Voltaje negativo de salida ?
        Q_ADC: out std_logic --Salida del modulo
      );
  end component;

    
  component cont_330
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


  component cont_UNOS
    port(
        clk_i:      in std_logic; --Clock sistema
        rst_i:      in std_logic; --Reset sistema
        ena_i:      in std_logic; --Enable sistema
        Q_o:        out matrix(2 downto 0) --  3 contadores BCD de 4 bits cada uno 
    );
  end component;


  component reg is 
  generic(
      N: natural :=4
  );
  port(
      clk_i: in std_logic;
      rst_i: in std_logic;
      ena_i: in std_logic;
      D_i: in matrix(2 downto 0);
      q_1: out std_logic_vector(N-1 downto 0);
      q_2: out std_logic_vector(N-1 downto 0);
      q_3: out std_logic_vector(N-1 downto 0);
      q_dot: out std_logic_vector(N-1 downto 0);
      q_v: out std_logic_vector(N-1 downto 0)
  );
  end component;

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
	

	
	component mux_n is 
    generic(
        N: natural := 4 --Cant de bits de cada dato
    );
    port(
        d1_i: in std_logic_vector(N-1 downto 0);
        d_dot_i: in std_logic_vector(N-1 downto 0);
        d2_i: in std_logic_vector(N-1 downto 0);
        d3_i: in std_logic_vector(N-1 downto 0);
        d_v_i: in std_logic_vector(N-1 downto 0);
        col_sel_i: in std_logic_vector(9 downto 0);
        row_sel_i: in std_logic_vector(9 downto 0);
        sal_o: out std_logic_vector(N-1 downto 0)
    );
  end component;

  component mem_rom is 
    port(
        char: in std_logic_vector(3 downto 0); --Recibido del MUX
        pos_col, pos_row: in std_logic_vector(9 downto 0); --Posiciones del caracter 
        rom_out: out std_logic
    );
  end component;


  component VGA_unit is
    general(
        N: natural:= 10 
    );
    port(
        clk_i: in std_logic;
        rst_i: in std_logic;
        ena_i: in std_logic; --Se usa?
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
  end component;
	
  begin

    rst_aux <= rst;
    clk_aux <= clk;

    i_div_freq: clck_VGA
    port map(
      clk_i => clk,
      rst_i => rst_aux,
      clk_o => clk_VGA
    );

    i_ADC: ADC
    port map(
      clk_i => clk_aux,
      rst_i => rst_aux,
      ena_i => '1',
      D_i => ent_unos, 
      Q_ADC => Q_ADC_aux
    );

    sal_unos <=  Q_ADC_aux;

    i_cont_330 : cont_330
        port map(
            clk_i => clk_aux,
            rst_i => rst_aux,
            ena_i => '1',
            --q_o => q_tb,--no se usa
            q_ena_o => Q_ENA_aux,
            q_rst_o => Q_RST_aux
        );

-- Mapeo del reset del contador UNOS, se puede utilizar el reset general o cuando el cont_33000 termina.
    rst_cont <= rst_aux or Q_RST_aux;

    i_cont_UNOS: cont_UNOS
      port map(
        clk_i => clk_aux, 
        rst_i => rst_cont,
        ena_i => Q_ADC_aux, --Cuenta los unos que le ingresan desde ADC
        Q_o   => Q_cont_aux
      );

    i_REGISTRO: reg  
      port map(
          clk_i     => clk_aux,
          rst_i     => rst_aux,
          ena_i     => Q_ENA_aux,
          D_i       => Q_cont_aux,
          q_1       => D1_aux_temp,
          q_2       => D2_aux_temp,
          q_3       => D3_aux_temp,
          q_dot     => point_aux, 
          q_v       => V_aux
      );

    i_reg_q1: reg_gral
      port map(
        clk_i => clk_aux,
        rst_i => '0',
        ena_i => v_ena_reg_aux,
        D_i   => D1_aux_temp,
        Q_o   => D1_aux
      );

    i_reg_q2: reg_gral
      port map(
        clk_i => clk_aux,
        rst_i => '0',
        ena_i => v_ena_reg_aux,
        D_i   => D2_aux_temp,
        Q_o   => D2_aux
      );

    i_reg_q3: reg_gral
      port map(
        clk_i => clk_aux,
        rst_i => '0',
        ena_i => v_ena_reg_aux,
        D_i   => D3_aux_temp,
        Q_o   => D3_aux
      );

    i_MUX: mux_n
      port map(
        d1_i        => D1_aux,
        d_dot_i     => point_aux,
        d2_i        => D2_aux,
        d3_i        => D3_aux,
        d_v_i       => V_aux,
        col_sel_i   => pos_h_aux,
        row_sel_i   => pos_v_aux,
        sal_o       => MUX_out_aux
      );

    i_ROM: mem_rom
      port map(
      char       =>  MUX_out_aux,
      pos_col    =>  pos_h_aux,
      pos_row    =>  pos_v_aux,
      rom_out    => rom_out_aux
    );

     -- Seleccion de color
     red_aux <= rom_out_aux and '0';
     grn_aux <= rom_out_aux and '1';
     blu_aux <= rom_out_aux and '1';
     
    i_VGA: VGA_unit
     port(
       clk_i   => clk_VGA,
       rst_i   => rst_aux,
       ena_i   => '1',
       red_i   => red_aux,
       grn_i   => grn_aux,
       blu_i   => blu_aux,
       sinh_o  => hsync,
       sinv_o  => vsync,
       red_o   => red_out,
       grn_o   => grn_out,
       blu_o   => blu_out,
       pos_h   => pos_h_aux,
       pos_v   => pos_v_aux,
       ena_reg => v_ena_reg_aux
   );
 
  end voltimetro;