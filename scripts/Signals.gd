extends Node

## emitted by AnyKeyControl.gd
## received by Player.gd, GUI.gd, Player_ghost.gd
signal initiate_fun

## emitted by ItemBox_2x4_.gd
## received by GUI.gd
signal item_found

## emitted by Wastebasket8x8_.gd
## received by GUI, Player, and others?
signal cease_and_desist_fun

## emitted by Player.gd
## received by LVL_basics.gd
signal reset_level

## emitted by Terminal_BASE.gd
## received by Player, GUI, others?
signal open_terminal

## emitted by MachineSystem.gd
## received by Player, GUI, others? 
## will probably have to be sent (with args) to carry out signal chain commits
signal close_terminal
