extends CanvasLayer

signal back

var current_index : int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$IndexLabel.text = str(current_index)
	$HealthNumberLabel.text = str(Globals.player_health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func show():
	$InventoryBackground.show()
	$InventoryH1Label.show()
	$InventoryH2Label.show()
	$InventoryH3Label.show()
	$InventoryH4Label.show()
	$IndexLabel.show()
	$HealthLabel.show()
	$HealthNumberLabel.text = str(Globals.player_health)
	$HealthNumberLabel.show()
	$Up.show()
	$Right.show()
	$Left.show()
	$Down.show()
	$Use.show()
	$Back.show()


func hide():
	$InventoryBackground.hide()
	$InventoryH1Label.hide()
	$InventoryH2Label.hide()
	$InventoryH3Label.hide()
	$InventoryH4Label.hide()
	$IndexLabel.hide()
	$HealthLabel.hide()
	$HealthNumberLabel.hide()
	$Up.hide()
	$Right.hide()
	$Left.hide()
	$Down.hide()
	$Use.hide()
	$Back.hide()


func update():
	var counter = 1
	$InventoryH1Label.text = ""		# reset
	for i in Globals.player_inventory:
		if counter < 16:
			$InventoryH1Label.text += str(counter) + ". " + i.item_name + "\n"	# currently the inventory is full of strings, this will need to be change when it's objects
		elif counter > 15 and counter < 31:
			$InventoryH2Label.text += str(counter) + ". " + i.item_name + "\n"
		elif counter > 30 and counter < 46:
			$InventoryH3Label.text += str(counter) + ". " + i.item_name + "\n"
		elif counter > 45 and counter < 61:
			$InventoryH4Label.text += str(counter) + ". " + i.item_name + "\n"
		counter += 1
	show()

func _on_Back_pressed():
	emit_signal("back")


func _on_Up_pressed():
	current_index -= 1
	if current_index <= 0:
		current_index = 60
	$IndexLabel.text = str(current_index)
	$IndexLabel.show()


func _on_Right_pressed():
	current_index += 15
	if current_index > 60:
		current_index = current_index % 15
	$IndexLabel.text = str(current_index)
	$IndexLabel.show()


func _on_Down_pressed():
	current_index += 1
	if current_index > 60:
		current_index = 1
	$IndexLabel.text = str(current_index)
	$IndexLabel.show()


func _on_Left_pressed():
	current_index -= 15
	if current_index <= 0:
		current_index = (current_index % 15) + 46
	$IndexLabel.text = str(current_index)
	$IndexLabel.show()


func _on_Use_pressed():
	if current_index <= Globals.player_inventory.size():
		var result = Globals.player_inventory[current_index - 1].use()
		if result == true:
			Globals.player_inventory.remove(current_index - 1)
			# update inventory and health
			update()
			show()
		else:
			print("Cannot use this item!")	# later on print this message in a label instead
