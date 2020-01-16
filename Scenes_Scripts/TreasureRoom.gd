extends "res://Scenes_Scripts/Room.gd"
var minion_meat = load("res://Items/Minion_Meat.gd").new()
var baby_drag_meat = load("res://Items/Baby_Dragon_Meat.gd").new()

var loot : Array = ["stat buff", "gold", "food"]
var stat_buff : Array = [5, 4, 3, 2, 1]
var gold_loot : Array = [1000, 750, 500, 300, 150, 100, 75, 50]
var food_loot : Array = []
var drop_recieved : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	#$EncounterNoise.play()
	minion_meat.init()
	baby_drag_meat.init()
	food_loot.append(minion_meat)
	food_loot.append(baby_drag_meat)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func roll_reward():
	# we need to determine how many rolls the player gets based on how far he is in the dungeon
	$LootInfoLabel.text = ""
	$EncounterMsgLabel.text = encounter_message
	$EncounterMsgLabel.show()
	for i in range(Globals.room_number / 10 + 1):
		# roll for the type of loot
		var loot_type = loot[randi() % loot.size()]
		if loot_type == "stat buff":
			# There is a chance of getting a +1-+5 boost in any of our stats, 5 being the rarest, 1 being the most common
			var denominator = stat_buff.size() * 5
			for i in stat_buff:
				if randi() % denominator == 0:
					# we recieve this drop, choose which stat it goes in
					var stat_choice = randi() % 3
					if stat_choice == 0:
						Globals.player_attack_stat += i
						$LootInfoLabel.text += "+" + str(i) + " atttack\n"
					elif stat_choice == 1:
						Globals.player_strength_stat += i
						$LootInfoLabel.text += "+" + str(i) + " strength\n"
					elif stat_choice == 2:
						Globals.player_defence_stat += i
						$LootInfoLabel.text += "+" + str(i) + " defence\n"
					break	# break out of above for loop
				elif denominator == 5:
					# This means that we failed every other drop, this is the default drop
					# This is duplicated code, we can make this better
					var stat_choice = randi() % 3
					if stat_choice == 0:
						Globals.player_attack_stat += i
						$LootInfoLabel.text += "+1 attack\n"
					elif stat_choice == 1:
						Globals.player_strength_stat += i
						$LootInfoLabel.text += "+1 strength\n"
					elif stat_choice == 2:
						Globals.player_defence_stat += i
						$LootInfoLabel.text += "+1 defence\n"
				else:
					denominator -= 5
		elif loot_type == "gold":
			var denominator = gold_loot.size() * 5
			for i in gold_loot:
				if randi() % denominator == 0:
					# we recieve this drop add i to our gold count
					Globals.gold += i
					$LootInfoLabel.text += "+" + str(i) + " gold\n"
					break
				elif denominator == 5:
					Globals.gold += i
					$LootInfoLabel.text += "+50 gold\n"
				else:
					denominator -= 5
		elif loot_type == "food":
			var index = randi() % food_loot.size()
			Globals.player_inventory.append(food_loot[index])
			$LootInfoLabel.text += "+1 " + food_loot[index].get_name() + "\n"
	$LootInfoLabel.show()
	yield(get_tree().create_timer(2.5), "timeout")
	$LootInfoLabel.hide()
	$EncounterMsgLabel.hide()

