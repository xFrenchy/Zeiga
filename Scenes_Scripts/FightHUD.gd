extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func show():
	$HitButton.show()
	$InventoryButton.show()
	$RunButton.show()
	$HealthLabel.show()
	$HealthNumberLabel.text = str(Globals.player_health)
	$HealthNumberLabel.show()


func hide():
	$HitButton.hide()
	$InventoryButton.hide()
	$RunButton.hide()
	$HealthLabel.hide()
	$HealthNumberLabel.hide()


func spawn_enemy(enemy):
	get_tree().get_root().add_child(enemy)
