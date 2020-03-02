extends "res://Items/Item.gd"

var heal_value = 5
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func init():
	item_name = "Danger Noodle meat"
	item_description = "A piece of meat from a danger noodle, probably heals a little bit"


func use():
	if Globals.player_health <= 100:
		Globals.player_health += heal_value
		return true
	return false