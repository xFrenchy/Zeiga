extends "res://Scenes_Scripts/Monster.gd"

var loot1 = load("res://Items/danger_noodle_meat.gd").new()
var danger_noodle_loot : Array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	max_health = health
	$HealthValueLabel.text = str(health) + "/" + str(max_health)
	$HealthValueLabel.show()
	loot1.init()
	danger_noodle_loot.append(loot1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# Danger Noodle always drops 35 coins and has a 50% chance of dropping meat
func roll_for_loot():
	Globals.gold += 35
	$DropInfoLabel.text = "You recieved: 35 gold"
	if randi() % 2 == 0:	# 50% chance of getting a drop from our drop table
		var index = randi() % danger_noodle_loot.size()
		Globals.player_inventory.append(danger_noodle_loot[index])
		$DropInfoLabel.text += ", " + danger_noodle_loot[index].get_name()
	$DropInfoLabel.show()