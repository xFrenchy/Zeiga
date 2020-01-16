extends Node

var item_name : String = ""
var item_description : String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_name():
	return item_name


func get_description():
	return item_description

