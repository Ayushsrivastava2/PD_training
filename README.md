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

  
