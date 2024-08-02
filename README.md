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

3. preparing design in openlane
4. running synthesis (command: run_synthesis)
5. verilog vs gate level netlist
6. synthesis report

  
