extends "res://Scenes_Scripts/Room.gd"


# For textureprogress healthbar, check what the lowest number 'value' can be before the texture disappears
export var mob_name = ""
export var health = 0
export var attack_stat = 0
export var strength_stat = 0
export var defence_stat = 0
export var has_special_attack = false
export var chance_of_escape = 0.00
var max_health = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#encounter_type = Globals.EncounterType.Monster
	encounter_type = "Monster"
	$HealthBar.max_value = health
	$HealthBar.value = health
	$HealthBar.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func attack():
	# A minion should hit low and should never be able to kill the player unless the player was low to begin with
	# A minion should be a slight annoyance with potential to have ok loot to compensate for
	var damage = randi() % strength_stat
	# stats affect monsters the same way it affects our player
	var reroll_threshold : float = strength_stat * 0.20
	if damage < reroll_threshold:
		# we want to check if we get lucky and get to reroll
		var chance = randi() % 100
		if chance >= 0 and chance <= attack_stat:
			# we are lucky and reroll, note that we could reroll for even lower technically, look at TODO for a better option
			damage = randi() % strength_stat
			return damage
	$HitNoise.play()
	return damage

func defend(damage):
	var chanceToReduce = randi() % 100
	# The higher the defence stat, the higher range we cover to be able to reduce
	if chanceToReduce >= 0 and chanceToReduce <= defence_stat:
		# reduce the damage by 15% of the minion's defence stat
		var reducedDmg = defence_stat * 0.15
		damage -= reducedDmg
		if damage < 0:
			damage = 0
		# now update the player's health
		health -= damage
	else:
		health -= damage
	# Make the damage show up in the label
	$DamageTaken.text = str(damage)
	$DamageTaken.show()
	# Update healthbar to reflect damage taken
	if health <= 0:
		health = 0
		$DeathNoise.play()
	$HealthBar.value = health
	$HealthBar.show()
	# Update health value label
	$HealthValueLabel.text = str(health) + "/" + str(max_health)
	$HealthValueLabel.show()
	var timer = Timer.new()
	get_tree().get_root().add_child(timer)
	timer.wait_time = 1
	timer.start()
	yield(timer, "timeout")
	$DamageTaken.hide()
	timer.queue_free()
	return

