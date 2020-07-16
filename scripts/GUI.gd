extends Control

var start_moment
var current_moment
var end_moment
var pause_buffer = 0
var elapsed
var str_elapsed

var min_label
var sec_label
var msec_label

var timing = false
var time_paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect("initiate_fun", self, "mark_start")
	Signals.connect("cease_and_desist_fun", self, "mark_stop")
	Signals.connect("item_found", self, "increment_item_count")
	Signals.connect("open_terminal", self, "pause_time")
	Signals.connect("close_terminal", self, "unpause_time")
	
	if game_data.scene_counter != 1:
		print(str(game_data.scene_counter))
		$Panel3/HBoxContainer/StrTimeLabel.set_text(game_data.exit_string)
		
	min_label = $Panel2/HBoxContainer/MinLabel
	sec_label = $Panel2/HBoxContainer/SecLabel
	msec_label = $Panel2/HBoxContainer/MSecLabel

func _physics_process(delta):
	if time_paused == true:
		pause_buffer += int(delta * 1000)
		return
		
	current_moment = OS.get_ticks_msec()
	if timing == true:
		elapsed = (current_moment - start_moment) - pause_buffer
		var minutes = (elapsed / 1000) / 60
		var seconds = (elapsed / 1000) % 60
		var milliseconds = elapsed % 1000
		
		str_elapsed = "%02d:%02d:%03d" % [minutes, seconds, milliseconds]
	
		min_label.set_text("%02d" % [minutes])
		sec_label.set_text("%02d" % [seconds])
		msec_label.set_text("%02d" % [milliseconds])

func mark_start():
	timing = true
	start_moment = OS.get_ticks_msec()

func mark_stop():
	timing = false
	end_moment = OS.get_ticks_msec()
	if elapsed > game_data.exit_elapsed:
		game_data.exit_elapsed = elapsed
		game_data.exit_string = str_elapsed

func increment_item_count():
	$Panel/CenterContainer/Label.set_text(str(game_data.items_found_counter) + " items found")

func pause_time():
	time_paused = true

func unpause_time():
	time_paused = false
