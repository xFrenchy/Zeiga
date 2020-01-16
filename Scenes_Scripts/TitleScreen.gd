extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	var play_button = get_node("Play")
	play_button.connect("pressed", self, "pressed_handler", [play_button])
	var quit_button = get_node("Quit")
	quit_button.connect("pressed", self, "pressed_handler", [quit_button])
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func pressed_handler(button):
	#play game if pressed
	#print("Name of button pressed: ", button.get_name())
	if button.get_name() == "Play":
		get_tree().change_scene("res://Scenes_Scripts/Main.tscn")
		
	#exit if pressed
	if button.get_name() == "Quit":
		get_tree().quit()