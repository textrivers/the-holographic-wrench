extends Node

## emitted by AnyKeyControl.gd
## received by Player.gd, GUI.gd, Player_ghost.gd
signal initiate_fun

## emitted by ItemBox_2x4_.gd
## received by Reactor_Test.gd
signal item_found

## emitted by Wastebasket8x8_.gd
## received by GUI, Player, and others?
signal cease_and_desist_fun

## emitted by Player.gd
## received by Reactor_Test
signal reset_level
