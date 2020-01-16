extends CanvasLayer

signal fight_inventory

# Called when the node enters the scene tree for the first time.
func _ready():
	$HealthNumberLabel.text = str(Globals.player_health)
	$RoomNumberLabel.text = str(Globals.room_number)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func hide():
	$CurrentRoomLabel.hide()
	$RoomNumberLabel.hide()
	$HealthLabel.hide()
	$HealthNumberLabel.hide()
	$Inventory.hide()


func show():
	$CurrentRoomLabel.show()
	$RoomNumberLabel.show()
	$HealthLabel.show()
	$HealthNumberLabel.show()
	$Inventory.show()


func _on_Inventory_pressed():
	emit_signal("fight_inventory")


func show_and_scroll_damage_taken(damage):
	$DamageTakenLabel.text = str(damage)
	$DamageTakenLabel.show()
	var original_pos = $DamageTakenLabel.margin_top
	while $DamageTakenLabel.margin_top > 0:
		$DamageTakenLabel.margin_top -= 1
		var timer = Timer.new()
		get_tree().get_root().add_child(timer)
		timer.wait_time = 0.025
		timer.start()
		yield(timer, "timeout")
		timer.queue_free()
		$DamageTakenLabel.show()
	$DamageTakenLabel.hide()
	$DamageTakenLabel.margin_top = original_pos


func set_health_number(number):
	$HealthNumberLabel.text = str(number)
	$HealthNumberLabel.show()


