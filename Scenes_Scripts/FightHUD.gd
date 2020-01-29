extends CanvasLayer

signal hit
signal run
signal inventory
signal fight_over

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
	$InfoLabel.show()


func hide():
	$HitButton.hide()
	$InventoryButton.hide()
	$RunButton.hide()
	$HealthLabel.hide()
	$HealthNumberLabel.hide()
	$InfoLabel.hide()

#Displays a message for a certain amount of time and then goes away
func display_msg_timer(message, time):
	$InfoLabel.text = message
	$InfoLabel.show()
	yield(get_tree().create_timer(time), "timeout")
	$InfoLabel.hide()


func show_and_scroll_damage_taken(damage):
	$DamageTakenLabel.text = str(damage)
	$DamageTakenLabel.show()
	var original_pos = $DamageTakenLabel.margin_top
	while $DamageTakenLabel.margin_top > 0:
		$DamageTakenLabel.margin_top -= 1
		yield(get_tree().create_timer(0.025), "timeout")
		$DamageTakenLabel.show()
	$DamageTakenLabel.hide()
	$DamageTakenLabel.margin_top = original_pos


func spawn_enemy(enemy):
	get_tree().get_root().add_child(enemy)


func _on_HitButton_pressed():
	Globals.currentMonster.defend(Globals.player_attack())
	var damage_monster = Globals.currentMonster.attack()
	Globals.player_defend(damage_monster)
	show_and_scroll_damage_taken(damage_monster)
	$HealthNumberLabel.text = str(Globals.player_health)
	$HealthNumberLabel.show()
	emit_signal("hit")


func _on_InventoryButton_pressed():
	emit_signal("inventory")


func _on_RunButton_pressed():
	emit_signal("run")
