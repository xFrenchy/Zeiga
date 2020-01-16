extends CanvasLayer

signal fight
signal run

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_FightButton_pressed():
	emit_signal("fight")


func _on_RunButton_pressed():
	emit_signal("run")


func hide():
	$RoomInformationLabel.hide()
	$FightButton.hide()
	$RunButton.hide()

func show():
	$RoomInformationLabel.show()
	$FightButton.show()
	$RunButton.show()
