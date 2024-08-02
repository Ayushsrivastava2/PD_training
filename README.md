# PD_training
Physical design training from VLSI System Design

## Day1
## Theory
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



  
