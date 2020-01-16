extends Position2D

#export(preload("res://Scenes_Scripts/Globals.gd").EncounterType) var enumeration

#export var encounter_type = enumeration.Empty
export var encounter_type = "Empty"
export var encounter_message = "Write encounter message here"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_EncounterTimer_timeout():
	$EncounterNoise.playing = true
