extends CanvasLayer

signal fight_over

# Called when the node enters the scene tree for the first time.
func _ready():
	$InventoryHUD.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if Globals.currentMonster.health <= 0:
#		emit_signal("fight_over")

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



# Function to hide all buttons because we don't want the user to interact with the scene while something is happening
func hide_buttons():
	$HitButton.hide()
	$InventoryButton.hide()
	$RunButton.hide()


# Function to show all buttons when we want to allow the user to interact with the scene again
func show_buttons():
	$HitButton.show()
	$InventoryButton.show()
	$RunButton.show()


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
	hide_buttons()
	yield(get_tree().create_timer(0.5), "timeout")
	Globals.currentMonster.defend(Globals.player_attack())
	if Globals.currentMonster.health <= 0:
		hide()
		# Enemy is dead, player recieves loot
		Globals.currentMonster.roll_for_loot()
		yield(get_tree().create_timer(1.5), "timeout")
		emit_signal("fight_over")
		return
	var damage_monster = Globals.currentMonster.attack()
	yield(get_tree().create_timer(1.5), "timeout")
	Globals.player_defend(damage_monster)
	show_and_scroll_damage_taken(damage_monster)
	$HealthNumberLabel.text = str(Globals.player_health)
	$HealthNumberLabel.show()
	if Globals.player_health <= 0:
		hide()
		emit_signal("fight_over")
	else:
		show_buttons()


func _on_InventoryButton_pressed():
	hide_buttons()
	# This is because the inventory has it's own health label and the fight and inventory labels don't line up
	$HealthLabel.hide()
	$HealthNumberLabel.hide()
	$InventoryHUD.update()
	$InventoryHUD.show()
	var size_of_inventory = Globals.player_inventory.size()
	yield($InventoryHUD, "back")
	$InventoryHUD.hide()
	if Globals.player_inventory.size() < size_of_inventory:
		# inventory was used, enemy attacks
		$HealthLabel.show()
		$HealthNumberLabel.text = str(Globals.player_health)
		$HealthNumberLabel.show()
		var damage_monster = Globals.currentMonster.attack()
		yield(get_tree().create_timer(1.5), "timeout")
		Globals.player_defend(damage_monster)
		show_and_scroll_damage_taken(damage_monster)
		$HealthNumberLabel.text = str(Globals.player_health)
		$HealthNumberLabel.show()
		if Globals.player_health <= 0:
			hide()
			emit_signal("fight_over")
		else:
			show_buttons()
	else:
		show_buttons()
		$HealthLabel.show()
		$HealthNumberLabel.show()


func _on_RunButton_pressed():
	# chance of escape is a number between 0 and 100
	hide_buttons()
	if randi() % 100 < Globals.currentMonster.chance_of_escape:
		# user managed to escape
		$InfoLabel.text = "You managed to escape!"
		$InfoLabel.show()
		yield(get_tree().create_timer(1.5), "timeout")
		hide()
		emit_signal("fight_over")
	else:
		# User did not manage to escape, monsters use their turn now
		$InfoLabel.text = "Failed to escape!"
		$InfoLabel.show()
		var damage_monster = Globals.currentMonster.attack()
		yield(get_tree().create_timer(1.5), "timeout")
		$InfoLabel.hide()
		Globals.player_defend(damage_monster)
		show_and_scroll_damage_taken(damage_monster)
		$HealthNumberLabel.text = str(Globals.player_health)
		$HealthNumberLabel.show()
		if Globals.player_health <= 0:
			hide()
			emit_signal("fight_over")
		else:
			show_buttons()
