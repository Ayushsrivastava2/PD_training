# PD_training
Physical design training from VLSI System Design

## Day1
### Theory
ASIC design flow
1. Synthesis<br>mapping of lib std cells to RTL code, tool - yosys
2. Floorplanning<br>Planning die area of IC based on gate level netlist cells and core utilization %. Pin locations and macro locations (pre-placed cells) on die.
3. Powerplanning<br>Define pg grid structure. Global placement->optimal placement of instnces according to timing constraint, can be invalid placement. Detailed placement-> legalizing global placement.
4. CTS (clock tree synthesis)<br>placing clock network conneting sequential cells and clock instnces.
5. Routing<br>Signal routing between input and output data pins of instances.
6. Signoff<br>physical verification - DRC,LVS. timing verification - STA, CDC. fault check - DFT.


### Lab
Using picrv32a design for synthesis

Task: To find FF ratio in design-> FF ratio: 1613/14876=0.1084  (10.8%)
1. checking config.tcl in design/picrv32a/src dir.<br>![image](https://github.com/user-attachments/assets/81a43eda-af6f-4758-a49b-9cbbe9d7a57a)

2. preparing design in openlane<br>![image](https://github.com/user-attachments/assets/7dd53468-7c0d-4daf-8fb4-57c64de1cc5a)

3. running synthesis (command: run_synthesis)<br>![image](https://github.com/user-attachments/assets/28172628-20ea-48e2-89a5-efe6b778fe14)

4. verilog vs gate level netlist<br>![image](https://github.com/user-attachments/assets/f82e39ef-0833-42a1-95f9-03fcc2b2357e)

5. synthesis report<br>![image](https://github.com/user-attachments/assets/560886c5-0b92-469c-800e-516a98c0a34e)

## Day2
### Theory
FloorPlanning<br>
Area estimation of die = sum of instances size in gate netlist / core area utilization<br>
core area utilization ideally should be around 50-60% to give extra space for buffers and other instances that will get added downstream.<br>
Preplaced cell = hard IPs/macros etc. that are placed in floorplan stage itself before any other instance. Location of pre-placed cells are set by users. Preplaced cells like memory macros are surrounded by decqp cells.<br>
Decap cells = cap instances whcih provide charger to switching instances and their reduces IR drop. Ensures ideal voltage reaches switching instanes so that logic 0 or 1 doesn't go to unstable state.<br>
Tap cells = avoid latchup condition occur in CMOS devices. Connect newll to VDD and substrate.<br>

Powerplanning<br>
Define PDN of IC. handshake between frontend and backend team is required. frontend team define pin and backend team define location of pins.<br>

Placement<br>
gloabl placement - placement of instances with no legalization<br>
detailed placement - placement with no overlaps of instances. all instances in cell rows.<br>
placeing buffers in placement: estimate cap between instnces based on distance. place buffer in path of instance with long distance. <br>
how to check placement is correct or not?  - ideal clock network is assumed (clk skew = 0), setup check is done on placed instances.<br>

### Lab
1. checking variables for floorplanning in openlane in README.md in configurations
2. from 3 files variables given to floorplanning in openlane - configuration/config.tcl, design/picrv32a/config.tcl, design/picrv32a/sky130A*.tcl (pdk tcl)<br>priority order: pdk tcl > design/picrv32a/config.tcl > configuration/config.tcl
3. running floorplan (command used: run_floorplan)<br>![image](https://github.com/user-attachments/assets/cd425872-9388-401f-ba80-f5ce678f931a)

4. floorplan def file<br>![image](https://github.com/user-attachments/assets/c94192d7-9abc-4e7f-a846-84a4c423c387)

5. DEF file stats
    - Die area: 660um x 671um
    - pins: 489
    - components: 21230
    - nets: 14978
7. viewing design using magic<br>![image](https://github.com/user-attachments/assets/f6cbb7a3-de90-4e94-92ed-f248ec66904e)
8. running floorplan with different variables
   1.1 first set of variables<br>![image](https://github.com/user-attachments/assets/7d224b5f-fab2-40fd-a35c-a4ff77dd83ab)
   1.2 floorplan:<br>![image](https://github.com/user-attachments/assets/de8be58d-9b00-4408-a98a-b9b93be36326)
   1.3 pins after floorplan<br>![image](https://github.com/user-attachments/assets/d82f9068-dc5a-43bd-a6e2-60796899fcc0)
   2.1 second set of variables<br>![image](https://github.com/user-attachments/assets/5c1e9719-8816-4759-bba2-ebcd968bfaa8)
   2.2 new floorplan:<br>![image](https://github.com/user-attachments/assets/0acda414-eee3-43bd-8d4f-75e36aba59ed)
9. All instnces are places at left bottom corner<br>![image](https://github.com/user-attachments/assets/18fc82d6-580e-4c8d-8c1b-0b6563c8344f)
10. Design after placement<br>![image](https://github.com/user-attachments/assets/c94f091d-6cb3-40e2-a921-35ee62ff70a2)
11. Checking instance<br>![image](https://github.com/user-attachments/assets/53a5ea39-ca8f-42ab-9916-6ce686ff6469)

## Day3
### Theory

### Lab
1. SPICE ckt of CMOS inverter<br>![image](https://github.com/user-attachments/assets/6c6fba13-ce3f-4dce-9e28-e0923d31770c)
2. Spice decxk of CMOS inverter with VTC plot<br>![image](https://github.com/user-attachments/assets/27ae2af9-8263-4beb-8e2f-29e3e2882e8c)
3. Impact of varying Wp on CMOS inverter study

   3.1 spice deck for static analysis<br>![image](https://github.com/user-attachments/assets/707b563f-c777-4fe8-8cc5-f27d4852eb0a)
   3.2 VTC of cmos inverter (VTC on left, derivative of plot on right)<br>![image](https://github.com/user-attachments/assets/ca8bad83-1d9c-4b41-ad8e-c1dd972af552)
   3.3 spice deck for dynamic analysis<br>![image](https://github.com/user-attachments/assets/15cbb6c3-93ec-448a-852d-c9a31d295d4f)
   3.4 transient output voltage waveform<br>![image](https://github.com/user-attachments/assets/90bfd97a-b6e3-4d27-9556-d3ef6b7a5d03)

   3.5 static summary:<br>

    |  wp |  vm  | vil  | vih  |     vol     |    voh     |
    |-----|------|------|------|-------------|------------|
    |  37 | 1.33 | 0.96 | 1.48 | 0.243430731 | 3.13616532 |
    | 117 | 1.6  | 1.35 | 1.81 | 0.239540941 | 3.02077689 |
    | 197 | 1.73 | 1.52 | 1.97 | 0.197538491 | 3.02188905 |
    | 277 | 1.8  | 1.62 | 2.06 | 0.171349188 | 3.03557396 |

   3.6 dynamic summary:<br>
   Cload = 5fF, input slew = output slew = 400ps<br>
   
    |  wp |       rise_delay       |       rise_slew        |       fall_delay      |       fall_slew        |
    |-----|------------------------|------------------------|-----------------------|------------------------|
    |  37 | 1.5499999999999998e-10 | 8.000000000000014e-11  |  5.49999999999995e-11 | 5.099999999999993e-11  |
    | 117 | 7.899999999999983e-11  | 4.400000000000026e-11  | 7.300000000000006e-11 | 4.7000000000000355e-11 |
    | 197 | 5.300000000000013e-11  | 3.699999999999977e-11  | 8.299999999999982e-11 | 4.400000000000026e-11  |
    | 277 | 3.8000000000000076e-11 | 3.3000000000000196e-11 | 9.099999999999979e-11 | 4.300000000000078e-11  |





