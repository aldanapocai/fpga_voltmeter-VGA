library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.utils.all;

entity mem_rom is 
    port(
        char: in std_logic_vector(3 downto 0);
        font_x, fort_y: in std_logic_vector(9 downto 0);
        rom_out: out std_logic
    );
end;

architecture mem_rom_arq of mem_rom is

    constant Cero: matrix_ROM:= (
                                "00111100",
                                "01000010",
                                "01000010",
                                "01000010",
                                "01000010",
                                "01000010",
                                "00111100",
                                "00000000"
                        );
    constant Uno: matrix_ROM:= (
                                "00001000",
                                "00011000",
                                "00001000",
                                "00001000",
                                "00001000",
                                "00001000",
                                "00011100",
                                "00000000"
                        );
    constant Dos: matrix_ROM:= (
                                "00111100",
                                "01000010",
                                "00000100",
                                "00001000",
                                "00010000",
                                "00100000",
                                "01111110",
                                "00000000"
                        );
    constant Tres: matrix_ROM:= (
                                "00111100",
                                "01000010",
                                "00000010",
                                "00001100",
                                "00000010",
                                "01000010",
                                "00111100",
                                "00000000"
                            );
    constant Cuatro: matrix_ROM:= (
                                "00001100",
                                "00010100",
                                "00100100",
                                "01000100",
                                "01000100",
                                "01111110",
                                "00000100",
                                "00000000"
                        );
    constant Cinco: matrix_ROM:= (
                                "01111100",
                                "01000000",
                                "01000000",
                                "00111100",
                                "00000010",
                                "01000010",
                                "00111100",
                                "00000000"
                        );
    constant Seis: matrix_ROM:= (
                                "00111100",
                                "01000000",
                                "01000000",
                                "01111100",
                                "01000010",
                                "01000010",
                                "00111100",
                                "00000000"
                        );
    constant Siete: matrix_ROM:= (
                                "00111110",
                                "00000010",
                                "00000100",
                                "00001000",
                                "00010000",
                                "00010000",
                                "00010000",
                                "00000000"
                        );
    constant Ocho: matrix_ROM:= (
                                "00011100",
                                "00100010",
                                "00100010",
                                "00011100",
                                "00100010",
                                "00100010",
                                "00011100",
                                "00000000"
                        );
    constant Nueve: matrix_ROM:= (
                                "00011100",
                                "00100010",
                                "00100010",
                                "00100010",
                                "00011110",
                                "00000010",
                                "00011100",
                                "00000000"
                        );
    constant V_volt: matrix_ROM:= (
                                "01000010",
                                "01000010",
                                "01000010",
                                "00100100",
                                "00100100",
                                "00011000",
                                "00011000",
                                "00000000"
                        );
    constant Punto: matrix_ROM:= (
                                "00000000",
                                "00000000",
                                "00000000",
                                "00000000",
                                "00000000",
                                "00011000",
                                "00011000",
                                "00000000"
                        );
    constant Blank: matrix_ROM:= (
                                "00000000",
                                "00000000",
                                "00000000",
                                "00000000",
                                "00000000",
                                "00000000",
                                "00000000",
                                "00000000"
                        );

    
    signal ROM: matrix3D_ROM:=(Cero, Uno, Dos, Tres, Cuatro, Cinco, Seis, Siete, Ocho, Nueve, V_volt, Punto);

    signal h_ind, v_ind: integer range 0 to 7; --Indices de posicion
    signal aux_char: integer range 0 to 11; --Indice del caracter
    signal pos_h, pos_v: std_logic_vector(2 downto 0); --señales para determinar el pixel

    signal v_flag: std_logic; --Condicion para habilitar salida
    signal char_out: std_logic; --Char de salida 

begin
    pos_h <= font_x(6) & font_x(5) & font_x(4);
    pos_v <= font_y(6) & font_y(5) & font_x(4);

    aux_char <= to_integer(unsigned(char));
    h_ind <= to_integer(unsigned(pos_h));
    v_ind <= to_integer(unsigned(pos_v));

    v_flag <= (not font_y(9)) and (not font_y(8)) and font_y(7);

    char_out <= ROM(aux_char)(v_ind)(h_ind);

    selector: entity work.mux_base
        port map(
            mux_x => '0',
            mux_y => char_out,
            mux_sel => v_flag,
            mux_out => rom_out
        );

end;


