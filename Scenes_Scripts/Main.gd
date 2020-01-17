extends Node2D

var rooms_array = ["res://Scenes_Scripts/BabyDragon.tscn", "res://Scenes_Scripts/Minion.tscn", "res://Scenes_Scripts/TreasureRoom.tscn", "res://Scenes_Scripts/TravelingMerchant.tscn"]
var room
var room_node

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()	# set the seed for random numbers
	$EncounterMobHUD.hide()
	$InventoryHUD.hide()
	$FightingHUD.hide()

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
		$EncounterMobHUD/RoomInformationLabel.text = room_node.encounter_message
		$EncounterMobHUD.show()
		# At this point the user can only emit two signals, fight and run which are taken care with handler functions listening
	elif room_node.encounter_type == "Reward":
		room_node.roll_reward()
		$DefaultHUD.show()	# this updates our gold label for the HUD
	elif room_node.encounter_type == "Shop":	# This is our traveling merchant room
		#Hide our current hude
		$DefaultHUD.hide()
		room_node.connect("leave", self, "leave_merchant_room")


func _on_EncounterMobHUD_fight():
	$EncounterMobHUD.hide()
	Globals.fight(room_node)
	yield(Globals, "fight_over")	# wait for the fight to be over before we proceed
	if  Globals.player_health > 0:
		# Fight was successfull and we restore defaultHUD, and remove the monster from the screen
		$DefaultHUD.show()
		room_node.queue_free()
	else:
		# The player has died, switch to gameover screen
		pass


func _on_EncounterMobHUD_run():
	# chance of escape is a number between 0 and 100
	if Globals.attempt_to_run(room_node.chance_of_escape) == true:
		$EncounterMobHUD/RoomInformationLabel.text = "You've managed to escape!"
		$EncounterMobHUD/RoomInformationLabel.show()
		var timer = Timer.new()
		get_tree().get_root().add_child(timer)
		timer.connect("timeout", self, "switch_to_defaultHUD", [$EncounterMobHUD, timer])
		timer.wait_time = 2
		timer.start()
		# Remove the buttons so that the user doens't try to break my game
		$EncounterMobHUD/FightButton.hide()
		$EncounterMobHUD/RunButton.hide()
	else:
		# User did not manage to escape and must now fight, switch to FightingHUD
		$EncounterMobHUD.hide()
		Globals.fight(room_node)
		yield(Globals, "fight_over")	# wait for the fight to be over before we proceed
		if Globals.player_health > 0:
			# Fight was successfull and we restore defaultHUD, and remove the monster from the screen
			$DefaultHUD.show()
			room_node.queue_free()
		else:
			# The player has died, switch to gameover screen
			pass


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

