extends Control
var player: Node2D
var world: Node2D
var weapon: Node2D
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	world = get_tree().get_first_node_in_group("main")
	weapon = get_tree().get_first_node_in_group("weapon")
	hide()




func _process(delta: float) -> void:
	
	if not get_tree().paused :
		show()
	if world:
		if world.intermission:
			$Panel/enemiesleft.text = ("Intermission")
		else:
			$Panel/enemiesleft.text = ("Enemies Remaining: " + str(world.mobstospawn - world.mobsdefeated))
		$Panel/currentwave.text = ("Wave: " + str(world.wave))
	var weap: String
	match player.weaponid:
		1:
			weap = "Pistol"
		2:
			weap = "Shotgun"
		3:
			weap = "Machine Gun"
		4:
			weap = "Crossbow"
		_:
			weap = "What?"
	$Panel/currentweapon.text = "Current Weapon: " + weap
	if player.can_dash:
		$Panel/DashColor.color = Color.GREEN
	else:
		$Panel/DashColor.color = Color.RED
	$Panel/firerate.text = "Fire Rate: " + str(snappedf(weapon.fire_rate, 0.01))
	$Panel/weapondamage.text = "Damage: " + str(weapon.damage)
	
	$Panel/health.text = ("Health: " + str(player.playerhealth))
	$Panel/score.text = ("Score: " + str(player.score))
	$Panel/money.text = "Money: " + str(player.money)
