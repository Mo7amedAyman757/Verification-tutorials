vlib work
vlog image_pkg.sv image.sv  +cover 
vsim -voptargs=+acc work.image -cover
coverage save image.ucdb -onexit
run -all
quit -sim
