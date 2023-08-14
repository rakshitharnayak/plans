compile:
		vlib work;
			vlog -sv queue_fifo.sv

simulate:
		vsim queue_data_type -l queue_data_type.log -c -do "run -all; exit;"

all:
	make compile && make simulate
