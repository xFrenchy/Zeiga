extends "res://Scenes_Scripts/Monster.gd"
var loot1 = load("res://Items/Minion_Meat.gd").new()
var minion_loot : Array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	max_health = health
	$HealthValueLabel.text = str(health) + "/" + str(max_health)
	$HealthValueLabel.show()
	loot1.init()
	minion_loot.append(loot1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# Minion always drops 50 coins and has a 50% chance of dropping meat
func roll_for_loot():
	Globals.gold += 50
	$DropInfoLabel.text = "You recieved: 50 gold"
	if randi() % 2 == 0:	# 50% chance of getting a drop from our drop table
		var index = randi() % minion_loot.size()
		Globals.player_inventory.append(minion_loot[index])
		$DropInfoLabel.text += ", " + minion_loot[index].get_name()
	$DropInfoLabel.show()