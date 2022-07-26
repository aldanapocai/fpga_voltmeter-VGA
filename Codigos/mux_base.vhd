library IEEE;
use IEEE.std_logic_1164.all;

entity mux_base is
    port(
        mux_x:   in std_logic;
        mux_y:   in std_logic;
        mux_sel: in std_logic;
        mux_out: out std_logic
    ); 
end;

architecture mux_base_arq of mux_base is

begin
    mux_out <= ((mux_x and not(mux_sel))) or ((mux_y and mux_sel));

end;