extends Node

enum EncounterType {
	Monster,
	Empty
	}

signal fight_over

var player_health = 100
var player_attack_stat = 15
var player_strength_stat = 15
var player_defence_stat = 15
var gold = 0
var room_number = 0
var player_inventory : Array = []
var is_fight_ongoing = false

var hitting_sound_wav = preload("res://Music_Sounds/PlayerHit.wav")
var taking_hit_sound_wav = preload("res://Music_Sounds/PlayerIsHit.wav")
var fightingHUD_scene = preload("res://Scenes_Scripts/FightingHUD.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# keep fighting until the monster or player dies
func fight(monster) -> bool:
	is_fight_ongoing = true
	var hit_sound = AudioStreamPlayer2D.new()
	var taking_hit_sound = AudioStreamPlayer2D.new()
	var hud = fightingHUD_scene.instance()
	hit_sound.set_stream(hitting_sound_wav)
	hit_sound.volume_db = -7
	taking_hit_sound.set_stream(taking_hit_sound_wav)
	taking_hit_sound.volume_db = -10
	# remember to remove this when exiting to avoid memory leak
	get_tree().get_root().add_child(hud)	
	get_tree().get_root().add_child(hit_sound)
	get_tree().get_root().add_child(taking_hit_sound)
	#connect the hud with the fighting inventory signal
	
	while player_health > 0 and monster.health > 0:
		# wait 1.5 seconds
		yield(get_tree().create_timer(1.5), "timeout")
		# Check if player is alive and monster is alive
		if player_health > 0 and monster.health > 0:
			# player attacks
			monster.defend(player_attack())
			# wait for however long it takes the monster to defend
			hit_sound.play()
		else:
			# the attack before this was from a monster, so the player must be dead
			hud.queue_free()
			hit_sound.queue_free()
			taking_hit_sound.queue_free()
			is_fight_ongoing = false
			emit_signal("fight_over")
			return false	# false is the player dying, true is player winning the fight

		# wait 1.5 seconds
		yield(get_tree().create_timer(1.5), "timeout")

		if player_health > 0 and monster.health > 0:
			# monster attacks
			var damage_monster = monster.attack()
			player_defend(damage_monster)
			hud.show_and_scroll_damage_taken(damage_monster)
			taking_hit_sound.play()
			hud.set_health_number(player_health)
		else:
			# the attack came from the player so the monster must be dead
			monster.roll_for_loot()
			hud.queue_free()
			hit_sound.queue_free()
			taking_hit_sound.queue_free()
			# Wait a little bit for the death sound affect and drop table loot to show up
			yield(get_tree().create_timer(1.5), "timeout")
			is_fight_ongoing = false
			emit_signal("fight_over")
			return true
	emit_signal("fight_over")
	return true


func attempt_to_run(chance):
	if randi() % 100 < chance:
		# succeful running away attempt
		return true
	else:
		return false


# function for rolling an attack for the player
func player_attack():
	#TODO, make attack impact rolling a hit more, potentially having a small chance of adding a percentage
	# of our attack stat as extra damage on top of our roll. This way it feels like we hit higher more often
	var damage = randi() % player_strength_stat
	# for accuracy, if the roll is less than 20% of our max hit, we have a (attackStat)% chance of re-rolling for another hit
	var reroll_threshold : float = player_strength_stat * 0.20
	if damage < reroll_threshold:
		# we want to check if we get lucky and get to reroll
		var chance = randi() % 100
		if chance >= 0 and chance <= player_attack_stat:
			# we are lucky and reroll, note that we could reroll for even lower technically, look at TODO for a better option
			damage = randi() % player_strength_stat
			return damage
	return damage


#function for defending against an attack for the player
func player_defend(damage):
	# Player defence will have a chance to reduce the incoming attack by a percentage
	var chanceToReduce = randi() % 100
	# The higher the defence stat, the higher range we cover to be able to reduce
	if chanceToReduce >= 0 and chanceToReduce <= player_defence_stat:
		# reduce the damage by 15% of the player's defence stat
		var reducedDmg = player_defence_stat * 0.15
		damage -= reducedDmg
		if damage < 0:
			damage = 0
		# now update the player's health
		player_health -= damage
	else:
		player_health -= damage
	return

