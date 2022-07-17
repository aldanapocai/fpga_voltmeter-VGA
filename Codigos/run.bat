
Script para utilizar GHDL y GTKWave (modificarlo en función de las necesidades)
ghdl -s ../Fuentes/sum1b.vhd ../Fuentes/sum1b_tb.vhd

ghdl -a ../Fuentes/sum1b.vhd ../Fuentes/sum1b_tb.vhd

ghdl -e sum1b_tb

ghdl -r sum1b_tb --vcd=sum1b_tb.vcd --stop-time=1000ns

gtkwave sum1b_tb.vcd
 
