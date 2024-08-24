# PD_training
Physical design training from VLSI System Design
## Table of content
- [Day1](#Day1)
    - [Asic design flow](#Introduction-to-ASIC-deign-flow)
    - [Synthesis of picv32a design](#Synthesis-of-picv32a-design)
- [Day2](#Day2)
    - [Floorplanning, powerplanning and placement theory](#Floorplanning-powerplanning-and-placement-theory)
    - [Running floorplan on picv32a](#Running-floorplan-on-picv32a)
    - [Running placement on picv32a](#Running-placement-on-picv32a)
- [Day3](#Day3)
    - [CMOS inverter characteristics](#CMOS-inverter-characteristics)
    - [Generating CMOS spice deck](#Generating-CMOS-spice-deck)
    - [Running spice deck file using ngspice](#Running-spice-deck-file-using-ngspice)
    - [Impact of varying PMOS width on CMOS inverter study](#Impact-of-varying-PMOS-width-on-CMOS-inverter-study)
    - [DRC checks](#DRC-checks)
- [Day4](#Day4)
    - [Generating LEF file from mag file](#Generating-LEF-file-from-mag-file)
    - [Adding custom inv to picv32a](#Adding-custom-inv-to-picv32a)
    - [STA theory](#STA-theory)
        - [setup and hold time of FF](#setup-and-hold-time-of-FF)
        - [prelayout analysis](#prelayout-analysis)
        - [Clock tree synthesis](#Clock-tree-synthesis)
        - [Crosstalk and clcok net shielding](#Crosstalk-and-clcok-net-shielding)
        - [timing analysis with real clock](#timing-analysis-with-real-clock)
    - [Pre-layout timing analysis on picv32a]
    - [CTS on picv32a]
    - [Post-layout timing analysis on picv32a]

## Day1
### Introduction to ASIC deign flow
ASIC design flow
1. Synthesis<br>mapping of lib std cells to RTL code, tool - yosys
2. Floorplanning<br>Planning die area of IC based on gate level netlist cells and core utilization %. Pin locations and macro locations (pre-placed cells) on die.
3. Powerplanning<br>Define pg grid structure. Global placement->optimal placement of instnces according to timing constraint, can be invalid placement. Detailed placement-> legalizing global placement.
4. CTS (clock tree synthesis)<br>placing clock network conneting sequential cells and clock instnces.
5. Routing<br>Signal routing between input and output data pins of instances.
6. Signoff<br>physical verification - DRC,LVS. timing verification - STA, CDC. fault check - DFT.


### Synthesis of picv32a design
Using picrv32a design for synthesis

Task: To find FF ratio in design-> FF ratio: 1613/14876=0.1084  (10.8%)
1. checking config.tcl in design/picrv32a/src dir.<br>![image](https://github.com/user-attachments/assets/81a43eda-af6f-4758-a49b-9cbbe9d7a57a)

2. preparing design in openlane<br>![image](https://github.com/user-attachments/assets/7dd53468-7c0d-4daf-8fb4-57c64de1cc5a)

3. running synthesis (command: run_synthesis)<br>![image](https://github.com/user-attachments/assets/28172628-20ea-48e2-89a5-efe6b778fe14)

4. verilog vs gate level netlist<br>![image](https://github.com/user-attachments/assets/f82e39ef-0833-42a1-95f9-03fcc2b2357e)

5. synthesis report<br>![image](https://github.com/user-attachments/assets/560886c5-0b92-469c-800e-516a98c0a34e)

## Day2
### Floorplanning powerplanning and placement theory
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

### Running floorplan on picv32a
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

### Running placement on picv32a
1. Design after placement<br>![image](https://github.com/user-attachments/assets/c94f091d-6cb3-40e2-a921-35ee62ff70a2)
1. Checking instance<br>![image](https://github.com/user-attachments/assets/53a5ea39-ca8f-42ab-9916-6ce686ff6469)

## Day3
### CMOS inverter characteristics
![image](https://github.com/user-attachments/assets/f944e620-1108-4be8-a627-2d50641705d6)
![image](https://github.com/user-attachments/assets/580731ed-561a-47ba-90c2-16e918dc6335)
![image](https://github.com/user-attachments/assets/76c171a3-11f8-4fe7-99a8-9d4a7163e498)
![image](https://github.com/user-attachments/assets/3df7e100-2b44-4738-8630-cef46ced26e9)

### Generating CMOS spice deck
1. clone source files from vsdcelldesign.git<br>![image](https://github.com/user-attachments/assets/097bede9-0260-44b4-af69-25a8c0930975)
2. copy tech file to local repo<br>![image](https://github.com/user-attachments/assets/ef36dd73-4a9c-491e-bb31-5fc1f42f8a6d)
3. open inverter layout mag file with magic<br>![image](https://github.com/user-attachments/assets/a337ae19-15ee-4156-93c3-c2b6211b54a3)
4. checking different components of cmos from layout in magic<br>![image](https://github.com/user-attachments/assets/28341162-3a2c-46bd-be87-2f8bb4e81bb6)
5. creating extract file from layout<br>![image](https://github.com/user-attachments/assets/8455a456-100b-4e97-959a-3dfdbb23afb6)
6. checking extracted file from magic<br>![image](https://github.com/user-attachments/assets/2a0b5a57-fb9d-4a09-a342-3a832f10b597)
7. extracting spice deck form magic<br>![image](https://github.com/user-attachments/assets/880b9fe7-75fa-4e3f-868c-d507793afdbb)
8. including lib file models in spice deck file<br>![image](https://github.com/user-attachments/assets/8accddcb-672b-42d2-9e6c-6b88d1abff89)
9. spice deck file after including nmos/pmos model from lib<br>![image](https://github.com/user-attachments/assets/b0de125a-6531-4c77-8605-1d491ee2cf4c)


### Running spice deck file using ngspice
1. SPICE ckt of CMOS inverter<br>![image](https://github.com/user-attachments/assets/6c6fba13-ce3f-4dce-9e28-e0923d31770c)
2. Spice deck of CMOS inverter with VTC plot<br>![image](https://github.com/user-attachments/assets/27ae2af9-8263-4beb-8e2f-29e3e2882e8c)

### Impact of varying PMOS width on CMOS inverter study
3. Impact of varying Wp on CMOS inverter study

   3.1 spice deck for static analysis<br>![image](https://github.com/user-attachments/assets/707b563f-c777-4fe8-8cc5-f27d4852eb0a)
   
   3.2 VTC of cmos inverter (VTC on left, derivative of plot on right)<br>![image](https://github.com/user-attachments/assets/ca8bad83-1d9c-4b41-ad8e-c1dd972af552)
   
   3.3 spice deck for dynamic analysis<br>![image](https://github.com/user-attachments/assets/15cbb6c3-93ec-448a-852d-c9a31d295d4f)
   
   3.4 transient output voltage waveform<br>![image](https://github.com/user-attachments/assets/90bfd97a-b6e3-4d27-9556-d3ef6b7a5d03)
   
   3.6 output files dumped after running spice files<br>![image](https://github.com/user-attachments/assets/7086b28f-3f7d-4552-95bb-fe742ea1298f)
   
   3.7 script to get static characteristics of cmos inverter from output files<br>![image](https://github.com/user-attachments/assets/12115580-719b-4ae1-beb7-bcdd68f10bcc)
   
   3.8 script to get dynamic characteristics of cmos inverter from output files<br>![image](https://github.com/user-attachments/assets/5e3ae4b7-97f8-4296-94b5-0dbe7f5521dc)
   
   3.9 static summary:<br>

    |  wp |  vm  | vil  | vih  |     vol     |    voh     |
    |-----|------|------|------|-------------|------------|
    |  37 | 1.33 | 0.96 | 1.48 | 0.243430731 | 3.13616532 |
    | 117 | 1.6  | 1.35 | 1.81 | 0.239540941 | 3.02077689 |
    | 197 | 1.73 | 1.52 | 1.97 | 0.197538491 | 3.02188905 |
    | 277 | 1.8  | 1.62 | 2.06 | 0.171349188 | 3.03557396 |

   3.10 dynamic summary:<br>
   Cload = 5fF, input slew = output slew = 400ps<br>
   
    |  wp |       rise_delay       |       rise_slew        |       fall_delay      |       fall_slew        |
    |-----|------------------------|------------------------|-----------------------|------------------------|
    |  37 | 1.5499999999999998e-10 | 8.000000000000014e-11  |  5.49999999999995e-11 | 5.099999999999993e-11  |
    | 117 | 7.899999999999983e-11  | 4.400000000000026e-11  | 7.300000000000006e-11 | 4.7000000000000355e-11 |
    | 197 | 5.300000000000013e-11  | 3.699999999999977e-11  | 8.299999999999982e-11 | 4.400000000000026e-11  |
    | 277 | 3.8000000000000076e-11 | 3.3000000000000196e-11 | 9.099999999999979e-11 | 4.300000000000078e-11  |

   3.11 observation
   - noise margin improves with increasing strength of nmos/pmos
   - Vm of inverter shift toward high voltage on increasing strangh of pmos inverter, same goes for VIL, VIH
   - on increasing driving strangth of pmos on inverter, rise delay and slew decreases -> pmos charges cload -> expected result; fall slew decreases but fall delay increases -> why? on increasing wp of pmos, drain cap of pos also increased, now nmos have to dischareg more caps -> resulting in more delay

### DRC checks
1. Important links:
    - MAagic DRC doc: http://opencircuitdesign.com/magic/
    - skywater DRC doc: https://skywater-pdk.readthedocs.io/en/main/
    - DRC rules: http://opencircuitdesign.com/magic/techref/maint2.html#drc
2. download and untar drc test examples<br>![image](https://github.com/user-attachments/assets/95433225-8963-4d8c-a892-c90aae96ab33)
3. load one of example mag file (met1.mag file)<br>![image](https://github.com/user-attachments/assets/4fb56394-4cc2-4cd7-942c-0e8d7203ef91)
4. loading techfile and checking drc on example<br>![image](https://github.com/user-attachments/assets/59c9e3cf-fd2e-4f73-bad8-bb64f153ae8c)
5. checking DRC rule from sky130A google website ([link](https://skywater-pdk.readthedocs.io/en/main/rules/periphery.html#m3))<br>![image](https://github.com/user-attachments/assets/ceb62ec2-153f-4e2c-8233-db795a454652)
6. load poly.mag and checking poly.9 example<br>![image](https://github.com/user-attachments/assets/781ed425-9329-40e3-856a-63b170a458f5)
7. checking poly.9 in website<br>![image](https://github.com/user-attachments/assets/7be26913-da40-4e73-bcf7-f0e93a32ca18)
8. checked distance between poly and ppolyres in poly.9, distance is 0.25um (approx), DRC voilation not flagged<br>![image](https://github.com/user-attachments/assets/45e1a543-776e-4ab4-afed-a359e72d74fd)
9. checking tech file for poly and ppolyres distance rule -> not found in tech file<br>
![image](https://github.com/user-attachments/assets/827f0b2e-a1fe-49ac-8f05-7ab68948931b)<br>
![image](https://github.com/user-attachments/assets/c724e3c9-4451-4adf-892c-cb09b421725a)
10. new rule added to ppolyres<br>![image](https://github.com/user-attachments/assets/963ff612-8f9e-42db-92c5-e62ec0b85cd1)
11. rerun case with new tech file, DRC voilated for poly and ppolyres distance<br>![image](https://github.com/user-attachments/assets/344c3b04-b16a-48fc-848f-cd176ad639ce)

## Day4
### Generating LEF file from mag file
Why LEF file needs to be dumped? why can't directly use layout file or gds file of cell?<br>
While doing placement of cell, information required for the cells are - bbox, pg pins/signal pins geoms. Details at transistor level - poly layer, diffusion layer, transistor loction is not needed. <br>
A LEF file is created for std cell containg all basic geom info of cell that is requied during placement of cell in PnR tool.

#### Changing grid size of layout
1. loading sky130_inv.mag file and check default grid<br>![image](https://github.com/user-attachments/assets/39054ed3-6c6f-437d-b265-56441d2677a8)
2. check tract.info for track pitch size and change grid size in magic according to this pitch<br>![image](https://github.com/user-attachments/assets/315f1b29-aed7-4ce1-b3e3-7df12852597d)
3. what values stored in track.info file? pitch info for each metal layers. Height of standard cells are measured are measured in terms of trach pitch.
4. layout with new grid<br>![image](https://github.com/user-attachments/assets/e03542d9-9bb2-46a1-b14c-8d5119b55bb5)
5. some layout checks
    - ports should be at intersection of grids
    - width of standard cell must be odd multiple of x pitch

#### Labeling ports in layout
1. adding port label to pin A<br>![image](https://github.com/user-attachments/assets/2b762ea9-92bb-48a9-88e8-5492054f2b13)
2. port number? port number decides order in which LEF is written for port
3. setting port class and port usage<br>![image](https://github.com/user-attachments/assets/a7a450d7-2920-46c3-bae9-6436c8987a59)
4. saving mag file with new name - sky130_myinv.mag<br>![image](https://github.com/user-attachments/assets/d827f097-c317-44f0-bd79-78326864ada4)
5. loading new mag file and dumping LEF file<br>![image](https://github.com/user-attachments/assets/52a3796a-3fc0-4582-91b2-e9ae9989de43)

### Adding custom inv to picv32a
1. inverter definition present in lib file<br>![image](https://github.com/user-attachments/assets/09beb37a-dbde-4328-a5f9-5cd8481ed48b)
2. copy lef file and lib file to src folder of picv32a<br>![image](https://github.com/user-attachments/assets/db3c2d09-8b88-479e-a4ca-277de2adb1ed)
3. commands to add in config.tcl to include custom inverter
    - `set ::env(LIB_SYNTH) "$::env(OPENLANE_ROOT)/designs/picorv32a/src/sky130_fd_sc_hd__typical.lib"`
    - `set ::env(LIB_FASTEST) "$::env(OPENLANE_ROOT)/designs/picorv32a/src/sky130_fd_sc_hd__fastest.lib"`
    - `set ::env(LIB_SLOWEST) "$::env(OPENLANE_ROOT)/designs/picorv32a/src/sky130_fd_sc_hd__slow.lib"`
    - `set ::env(LIB_TYPICAL) "$::env(OPENLANE_ROOT)/designs/picorv32a/src/sky130_fd_sc_hd__typical.lib"`
    - `set ::env(EXTRA_LEFS) \[glob ::env(OPENLANE_ROOT)/design/picov32a/src/*.lef\]`
4. config.tcl file<br>![image](https://github.com/user-attachments/assets/74bf1bb9-1d8f-4a7c-80f4-48cdeb48e4b2)
5. prepare picorv32a design with custom inv added<br>![image](https://github.com/user-attachments/assets/2aa2f0dd-6180-4357-91ab-da827a8f29b3)
6. run synthesis and check instance count of customer inverter(command to run synthesis: `run_synthesis`)<br>![image](https://github.com/user-attachments/assets/775a42e4-9dd1-4148-b36b-d6a2918846c1)
   <br>synthesis done - 1554 instances of sky130_myinv used
7. running floorplan and placement to see sky130_myinv in design<br>![image](https://github.com/user-attachments/assets/a648c138-dcdf-4953-ab3e-b9bb0919c4e2)
   <br>command to run floorplan: `run_floorplan`, command to run placement: `run_placemnt`

### STA theory
1. Delay table in lib file -> cell delay model -> depends on input slew and output load cap<br>![image](https://github.com/user-attachments/assets/54943c7c-c6de-484b-b78c-ba58b2d726ee)
#### setup and hold time of FF
1. setup time and of FF<br>![image](https://github.com/user-attachments/assets/51c45e68-ac23-4ad1-a950-29ced396bb4a)
2. hold time of FF<br>![image](https://github.com/user-attachments/assets/0c5f8c42-ba86-4398-94e7-e9a7bd8bb3c2)
#### prelayout analysis
1. pre-layout analysis: CTS is not done-> no clock network -> no clock skew. Ideal clock tree is assumed with clock skew = 0, and setup analysis is done on placed instnaces.
2. why not done hold analysis at this stage also?<br>
+ve clock skew relax setup slack -> worst setup slack will come with ideal clock. If setup voilations are fixed in this stage, no or very less setup voilations will be seen after CTS.<br>
0/-ve clock skew relax hold slack -> ideal clock network is ideal condition for hold check. checks should be done on worst condition.
3. setup analysis with ideal clock<br>![image](https://github.com/user-attachments/assets/e7867ec3-fa80-4689-a989-efab6fadf61d)
4. clock jitter<br>![image](https://github.com/user-attachments/assets/bb95b50d-7ad7-4a66-aa93-1dd7b365d531)
#### Clock tree synthesis
1. bad clock routing -> different clock delay time for FFs<br>![image](https://github.com/user-attachments/assets/a847caa1-00ad-43dd-bc29-e1e1d4320d28)
2. clock tree routing using H-tree algo<br>![image](https://github.com/user-attachments/assets/001b8f23-09fc-47ae-bf37-f0514b7ce51e)
3. adding clock buffer to fix high slew of clock signal at FF<br>
![image](https://github.com/user-attachments/assets/b7de9dc3-4ffb-481e-9659-9338f88623b6)<br>
![image](https://github.com/user-attachments/assets/1dae89ed-77d1-4f24-912d-973fe9e45f11)
#### Crosstalk and clcok net shielding
1. glitch<br>![image](https://github.com/user-attachments/assets/6ffa60a3-db5b-4ef2-9348-0f82731635ef)
2. additional delay due to crosstalk<br>![image](https://github.com/user-attachments/assets/8f8ffee6-db26-401d-ac94-3813a8138277)
3. clock net shielding<br>![image](https://github.com/user-attachments/assets/11697b37-f66d-486e-bee9-97c8f86e640b)
#### timing analysis with real clock
1. setup analysis using real clock network<br>![image](https://github.com/user-attachments/assets/57d176bd-1a9c-4454-bc7b-e6ac698d24a3)
2. hold analysis using real clock network<br>![image](https://github.com/user-attachments/assets/3d8ec996-bd18-4e65-b496-2a89db7e5ac8)




















 









