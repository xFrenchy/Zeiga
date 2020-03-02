extends Node2D

var rooms_array = ["res://Scenes_Scripts/BabyDragon.tscn", "res://Scenes_Scripts/Minion.tscn", "res://Scenes_Scripts/TreasureRoom.tscn", "res://Scenes_Scripts/TravelingMerchant.tscn", "res://Scenes_Scripts/DangerNoodle.tscn"]
var special_room_array = []
var room
var room_node

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()	# set the seed for random numbers
	$EncounterMobHUD.hide()
	$InventoryHUD.hide()
	$FightHUD.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# User pressed button to quit game, so quit game
func _on_DefaultHUD_game_over():
	get_tree().quit()


# User pressed button to go to the next room
func _on_DefaultHUD_next_room():
	# we're moving foward so the counter must increase
	$DefaultHUD.increase_room_counter()
	# randomly generate a new room (unless the room is a mulitple of 10)
	if Globals.room_number % 10 == 0:
		#Generate a specific room here
		pass
	else:
		room = load(rooms_array[randi() % rooms_array.size()])
		room_node = room.instance()
		add_child(room_node)
	# hide the current HUD, show the correct HUD
	# if room_node.encounter_type == Globals.EncounterType.Monster:
	if room_node.encounter_type == "Monster":
		# Show EncounterHUD
		$DefaultHUD.hide()
		Globals.currentMonster = room_node
		Globals.is_fight_ongoing = true
		$FightHUD.show()
		$FightHUD.display_msg_timer(room_node.encounter_message, 2)
		# At this point the fight is on going and when it's over, a signal will be emited and taken care of in another function
	elif room_node.encounter_type == "Reward":
		room_node.roll_reward()
		$DefaultHUD.show()	# this updates our gold label for the HUD
	elif room_node.encounter_type == "Shop":	# This is our traveling merchant room
		#Hide our current hude
		$DefaultHUD.hide()
		room_node.connect("leave", self, "leave_merchant_room")


func switch_to_defaultHUD(currentHud, timer):
	# Hide the current HUD
	currentHud.hide()
	# get rid of the room
	room_node.queue_free()
	# get rid of the timer
	timer.queue_free()
	# restore the default HUD
	$DefaultHUD.show()


func _on_DefaultHUD_inventory():
	$DefaultHUD.hide()
	$InventoryHUD.update()
	$InventoryHUD.show()


func _on_InventoryHUD_back():
	$InventoryHUD.hide()
	$DefaultHUD.show()


func leave_merchant_room():
	room_node.queue_free()	# remove the merchant node from our main scene
	$DefaultHUD.show()



func _on_FightHUD_fight_over():
	Globals.is_fight_ongoing = false
	if  Globals.player_health > 0:
		# Fight was successfull and we restore defaultHUD, and remove the monster from the screen
		$DefaultHUD.show()
		room_node.queue_free()
	else:
		# The player has died, switch to gameover screen
		pass
