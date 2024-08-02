# PD_training
Physical design training from VLSI System Design

## Day1
### Theory
ASIC design flow
1. Synthesis: 
  mapping of lib std cells to RTL code, tool - yosys
3. Floorplanning: 
  Planning die area of IC based on gate level netlist cells and core utilization %. Pin locations and macro locations (pre-placed cells) on die.
4. Powerplanning: 
  Define pg grid structure. Global placement->optimal placement of instnces according to timing constraint, can be invalid placement. Detailed placement-> legalizing global placement.
5. CTS (clock tree synthesis)
6. Routing
7. Signoff: physical verification - DRC,LVS. timing verification - STA, CDC.

### Day1-Lab
Using picrv32a design for synthesis
Task: To find FF ratio in design-> FF ratio: 1613/14876=0.1084  (10.8%)
1. checking config.tcl in design/picrv32a/src dir.<br>![image](https://github.com/user-attachments/assets/81a43eda-af6f-4758-a49b-9cbbe9d7a57a)

3. preparing design in openlane<br>![image](https://github.com/user-attachments/assets/7dd53468-7c0d-4daf-8fb4-57c64de1cc5a)

4. running synthesis (command: run_synthesis)<br>![image](https://github.com/user-attachments/assets/28172628-20ea-48e2-89a5-efe6b778fe14)

5. verilog vs gate level netlist<br>![image](https://github.com/user-attachments/assets/f82e39ef-0833-42a1-95f9-03fcc2b2357e)

6. synthesis report<br>![image](https://github.com/user-attachments/assets/560886c5-0b92-469c-800e-516a98c0a34e)


  
