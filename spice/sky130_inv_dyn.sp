
.option scale=0.01u
.include ./libs/nshort.lib
.include ./libs/pshort.lib

M001 Y A VPWR VPWR pshort_model.0 w=37 l=23 ad=1443 pd=152 as=1517 ps=156
M002 Y A VGND VGND nshort_model.0 w=35 l=23 ad=1445 pd=152 as=1365 ps=148
VDD VPWR 0 3.3V
VSS VGND 0 0V
Vin A 0 PULSE(0V 3.3 200p 0.4n 0.4n 2n 4n)
C0 A Y 0.05fF
C1 Y VPWR 0.11fF
C2 A VPWR 0.07fF
C3 Y 0 5.0fF
C4 VPWR 0 0.59fF

* .op
.control
* DYNAMIC RUN - DELAY AT DIFFERENT WP
* tran 1n 20nn
* plot A
let Wp=37
alter M001 w = Wp
repeat 4
    tran 1p 6n
    wrdata outputs/tr_Y_wp{$&Wp}.out Y
    let Wp = Wp + 80
    alter @M001[w] = Wp
end
plot tran1.v(Y) tran2.v(Y) tran3.v(Y) tran4.v(Y) vs time A
wrdata outputs/tr_A.out A
.endc

.end