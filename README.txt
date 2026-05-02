DUT folder:
	1) fsm.v – Controls the AES round sequence. Handles start, moves through the SubBytes and MixColumns stages, and asserts done at the end.
	2) subbytes.v – Performs the SubBytes step by applying the S-Box to all 16 bytes of the 128-bit state.
	3) sbox.v – The lookup table used by SubBytes. Maps each 8-bit input to its substituted 8-bit output.
	4) mix_coloumns.v – Implements the MixColumns operation on the 128-bit state. Processes each column independently and outputs the mixed result.
	5) fsm_gate.v - An FSM where the state register only updates when an enable is asserted, implementing clock gating to reduce unnecessary switching.
	6) slow.v - A standard-cell library “slow corner” Verilog model file (Artisan/TSMC) containing definitions/timing (module + specify) for hundreds of cells that synthesis uses when mapping your design.

TB (sv verification) folder:
	1) sv_tb.sv - A SystemVerilog testbench for simulating and verifying the FSM (Finite State Machine) design.

TB outputs folder:
	1) list3.do - ModelSim DO file to list and monitor FSM signals in the console.
	2) TB_console_outputs.png - Screenshot of ModelSim console showing all FSM tests passed.
	3) wave3.do - ModelSim DO file to display FSM signals in the waveform viewer.

DDLS-part3.pdf - A project report that describes the RTL design of an AES-based system, including the FSM, clock-gating structure, SubBytes and MixColumns blocks, along with the verification methodology and synthesis setup. 