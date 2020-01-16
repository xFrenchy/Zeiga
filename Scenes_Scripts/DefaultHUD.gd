extends CanvasLayer

signal next_room
signal inventory
signal game_over

var stats_showing : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$RoomNumberLabel.text = str(Globals.room_number)
	$RoomNumberLabel.show()
	$GoldNumberLabel.text = str(Globals.gold)
	$HealthNumberLabel.text = str(Globals.player_health)
	$StatsBackground.hide()	# This only shows up when someone pressed the button
	$StatsLabel.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NextRoom_pressed():
	emit_signal("next_room")


func _on_Inventory_pressed():
	emit_signal("inventory")


func _on_Stats_pressed():
	if stats_showing:
		$StatsBackground.hide()
		$StatsLabel.hide()
	else:
		$StatsLabel.text = "Attack: " + str(Globals.player_attack_stat) + "\nStrength: " + str(Globals.player_strength_stat) + "\nDefence: " + str(Globals.player_defence_stat)
		$StatsBackground.show()
		$StatsLabel.show()
	stats_showing = !stats_showing


func _on_Quit_pressed():
	emit_signal("game_over")

func increase_room_counter():
	Globals.room_number += 1
	$RoomNumberLabel.text = str(Globals.room_number)
	$RoomNumberLabel.show()


func set_health_number(number):
	$HealthNumberLabel.text = str(number)
	$HealthNumberLabel.show()


func hide():
	$CurrentRoomLabel.hide()
	$HealthLabel.hide()
	$HealthNumberLabel.hide()
	$RoomNumberLabel.hide()
	$NextRoom.hide()
	$Inventory.hide()
	$Stats.hide()
	$Quit.hide()
	$GoldLabel.hide()
	$GoldNumberLabel.hide()


func show():
	$CurrentRoomLabel.show()
	$HealthLabel.show()
	$HealthNumberLabel.text = str(Globals.player_health)
	$HealthNumberLabel.show()
	$RoomNumberLabel.show()
	$NextRoom.show()
	$Inventory.show()
	$Stats.show()
	$Quit.show()
	$GoldLabel.show()
	$GoldNumberLabel.text = str(Globals.gold)
	$GoldNumberLabel.show()


# turns off 3 buttons and leaves the inventory button on during a fight
#func switch_to_fightingHUD():
#	show()
#	$NextRoom.hide()
#	$Quit.hide()
#	$Stats.hide()


#func show_and_scroll_damage_taken(damage):
#	$PlayerDamageTaken.text = str(damage)
#	$PlayerDamageTaken.show()
#	var original_pos = $PlayerDamageTaken.margin_top
#	while $PlayerDamageTaken.margin_top > 0:
#		$PlayerDamageTaken.margin_top -= 1
#		var timer = Timer.new()
#		get_tree().get_root().add_child(timer)
#		timer.wait_time = 0.025
#		timer.start()
#		yield(timer, "timeout")
#		timer.queue_free()
#		$PlayerDamageTaken.show()
#	$PlayerDamageTaken.hide()
#	$PlayerDamageTaken.margin_top = original_pos


