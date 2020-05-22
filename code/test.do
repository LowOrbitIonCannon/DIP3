
vsim work.coolant_monitoring

restart

# open wave viewer
view wave

# display values in hexadecimal format
radix hex

# add compiled design entity to wave viewer
add wave -height 25 -radix default sim:/coolant_monitoring/*

force CLK 0 0, 1 10ns -r 20ns -cancel 900ns

force RESET 1 0, 0 45ns

#                   111 A       011 B       101 B       110 B       001 C       010 C       100 C       000 D
force S(0)  0 0,    1 100ns,    0 200ns,    1 300ns,    1 400ns,    0 500ns,    0 600ns,    1 700ns,    0 800ns
force S(1)  0 0,    1 100ns,    1 200ns,    0 300ns,    1 400ns,    0 500ns,    1 600ns,    0 700ns,    0 800ns
force S(2)  0 0,    1 100ns,    1 200ns,    1 300ns,    0 400ns,    1 500ns,    0 600ns,    0 700ns,    0 800ns

# run simulation for 800ns
run 900ns
