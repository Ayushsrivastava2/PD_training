
.option scale=0.01u
.include ./libs/nshort.lib
.include ./libs/pshort.lib

M001 Y A VPWR VPWR pshort_model.0 w=37 l=23 ad=1443 pd=152 as=1517 ps=156
M002 Y A VGND VGND nshort_model.0 w=35 l=23 ad=1445 pd=152 as=1365 ps=148
VDD VPWR 0 3.3V
VSS VGND 0 0V
Vin A 0 3.3V
C0 A Y 0.05fF
C1 Y VPWR 0.11fF
C2 A VPWR 0.07fF
C3 Y 0 0.24fF
C4 VPWR 0 0.59fF

* .op
.control
* STATIC RUN - VTC AT DIFFERENT WP
let Wp=37
alter M001 w = Wp
repeat 4
    dc Vin 0 3.3 0.01
    wrdata outputs/Y_wp{$&Wp}.out Y
    wrdata outputs/deriv_Y_wp{$&Wp}.out deriv(Y)
    let Wp = Wp + 80
    alter @M001[w] = Wp
    * plot Y vs A
end
plot dc1.v(Y) dc2.v(Y) dc3.v(Y) dc4.v(Y) A
plot deriv(dc1.v(Y)) deriv(dc2.v(Y)) deriv(dc3.v(Y)) deriv(dc4.v(Y))
.endc


.end
