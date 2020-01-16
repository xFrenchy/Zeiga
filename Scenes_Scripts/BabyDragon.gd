extends "res://Scenes_Scripts/Monster.gd"

var loot1 = load("res://Items/Baby_Dragon_Meat.gd").new()
var loot : Array = []
var extra_damage : int = 0
signal special_attack_done

# Called when the node enters the scene tree for the first time.
func _ready():
	max_health = health
	$HealthValueLabel.text = str(health) + "/" + str(max_health)
	$HealthValueLabel.show()
	loot1.init()
	loot.append(loot1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func special_attack():
	extra_damage = 0
	if randi() % 20 == 0:
		# Special attack occurs here, add between 5-8 damage extra on top of it's regular attack
		extra_damage = (randi() % 4) + 5
		$AttackInfoLabel.text = "The baby dragon used his weak firey breath!"
		$AttackInfoLabel.show()
		# display message for 1 second
		yield(get_tree().create_timer(1.5), "timeout")
		$AttackInfoLabel.hide()
	emit_signal("special_attack_done")
	return extra_damage		# if extra damage is 0, no special attack happened
	# I wonder if this return is happening at all


func attack():
	# A baby dragon should hit a bit higher than a minion but can be dangerous early on
	# A baby dragon should be a proceed with caution but can drop good early food
	var damage = randi() % strength_stat
	# stats affect monsters the same way it affects our player
	var reroll_threshold : float = strength_stat * 0.20
	if damage < reroll_threshold:
		# we want to check if we get lucky and get to reroll
		var chance = randi() % 100
		if chance >= 0 and chance <= attack_stat:
			# we are lucky and reroll, note that we could reroll for even lower technically, look at TODO for a better option
			damage = randi() % strength_stat
	#var extra_damage = special_attack()
	#yield(self, "special_attack_done")	# wait for the special attack role
	damage += extra_damage
	return damage


# Baby Dragon always drops 100 coins and has a 75% chance of dropping meat
func roll_for_loot():
	Globals.gold += 75
	$DropInfoLabel.text = "You recieved: 75 gold"
	if randi() % 3 != 0:	#75% chance of getting loot
		var index = randi() % loot.size()
		Globals.player_inventory.append(loot[index])
		$DropInfoLabel.text += ", " + loot[index].get_name()
	$DropInfoLabel.show()

