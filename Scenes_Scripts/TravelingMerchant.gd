extends "res://Scenes_Scripts/Room.gd"

signal leave
var index : int = 1
var isOpen : bool = false
var minion_meat = load("res://Items/Minion_Meat.gd").new()
var baby_drag_meat = load("res://Items/Baby_Dragon_Meat.gd").new()
var shopItems = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	$HealthNumberLabel.text = str(Globals.player_health)
	$HealthNumberLabel.show()
	$GoldNumberLabel.text = str(Globals.gold)
	$GoldNumberLabel.show()
	$RoomNumberLabel.text = str(Globals.room_number)
	$RoomNumberLabel.show()
	$InventoryHUD.hide()
	$ShopBackground.hide()
	$Up.hide()
	$Index.text = str(index)
	$Index.hide()
	$Down.hide()
	$Buy.hide()
	minion_meat.init()
	baby_drag_meat.init()
	shopItems[minion_meat] = 30
	shopItems[baby_drag_meat] = 45

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func show():
	$Sprite.show()
	$HealthLabel.show()
	$HealthNumberLabel.text = str(Globals.player_health)
	$HealthNumberLabel.show()
	$GoldLabel.show()
	$GoldNumberLabel.text = str(Globals.gold)
	$GoldNumberLabel.show()
	$CurrentRoomLabel.show()
	$RoomNumberLabel.text = str(Globals.room_number)
	$RoomNumberLabel.show()
	$OpenShop.show()
	$Inventory.show()
	$Leave.show()


func hide():
	$Sprite.hide()
	$HealthLabel.hide()
	$HealthNumberLabel.hide()
	$GoldLabel.hide()
	$GoldNumberLabel.hide()
	$CurrentRoomLabel.hide()
	$RoomNumberLabel.hide()
	$OpenShop.hide()
	$Inventory.hide()
	$Leave.hide()

func _on_Leave_pressed():
	emit_signal("leave")


func _on_Inventory_pressed():
	hide()
	if isOpen == true:
		$ShopBackground.hide()
		$ShopItemsLabel.hide()
		$Up.hide()
		$Index.hide()
		$Down.hide()
		$Buy.hide()
		isOpen = false
		$OpenShop.text = "Open shop"
	$InventoryHUD.update()
	$InventoryHUD.show()


func _on_InventoryHUD_back():
	$InventoryHUD.hide()
	show()


func _on_OpenShop_pressed():
	if isOpen == false:
		$ShopBackground.show()
		$Up.show()
		$Index.show()
		$Down.show()
		$Buy.show()
		isOpen = true
		$ShopItemsLabel.text = ""
		var counter = 1
		var items = shopItems.keys()
		var cost = shopItems.values()
		for i in range(shopItems.size()):
			$ShopItemsLabel.text += str(counter) + "." + items[i].get_name() + "     " + str(cost[i]) + " gold\n"
			counter += 1
		$ShopItemsLabel.show()
		$OpenShop.text = "Close shop"
		$OpenShop.show()
	else:
		$ShopBackground.hide()
		$ShopItemsLabel.hide()
		$Up.hide()
		$Index.hide()
		$Down.hide()
		$Buy.hide()
		isOpen = false
		$OpenShop.text = "Open shop"
		$OpenShop.show()


func _on_Up_pressed():
	index -= 1
	if index <= 0:
		index = 1
	$Index.text = str(index)
	$Index.show()


func _on_Down_pressed():
	index += 1
	if index > shopItems.size():
		index = shopItems.size()
	$Index.text = str(index)
	$Index.show()


func _on_Buy_pressed():
	var items = shopItems.keys()
	var cost = shopItems.values()
	if cost[index-1] < Globals.gold:
		Globals.gold -= cost[index-1]	# removed the gold that the item costs, now add it to the inventory
		Globals.player_inventory.append(items[index-1])	# add item to the inventory
	$GoldNumberLabel.text = str(Globals.gold)
	$GoldNumberLabel.show()

