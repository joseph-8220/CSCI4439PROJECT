extends Control
var shopping: bool = false
var player: Node2D 
var weapongroup: Node2D
var world: Node2D
var powcost: int
var specost: int
var vitcost: int
var soldout: bool
var weacost: int
var special: int
@onready var buynoise: AudioStreamPlayer2D = $buynoise
@onready var blocknoise: AudioStreamPlayer2D = $blocknoise
@onready var click: AudioStreamPlayer2D = $click

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	weapongroup = get_tree().get_first_node_in_group("weapon")
	world = get_tree().get_first_node_in_group("main")
	powcost = 10
	specost = 10
	vitcost = 10
	weacost = 25
	soldout = false
	rollshop()

func stopshopping():
	$AnimationPlayer.play_backwards("dropdown")
	shopping = false
func startshopping():
	$AnimationPlayer.play("dropdown")
	shopping = true
	

func _process(delta) -> void:
	player.shopping = shopping
	if Input.is_action_just_pressed("shop") and not get_tree().paused and world.intermission and world.wave != 0:
		click.play()
		if shopping:
			stopshopping()
		else:
			startshopping()
	if not world.intermission and shopping:
		stopshopping()
	
	
	
	if shopping:
		$Panel/health/vitbutton.text = "BUY\n($" + str(vitcost) + ")\n(" + str(player.vitbuffcount) + ")"
		$Panel/damage/powbutton.text = "BUY\n($" + str(powcost) + ")\n(" + str(player.dmgbuffcount) + ")"
		$Panel/speed/spebutton.text = "BUY\n($" + str(specost) + ")\n(" + str(player.spebuffcount) + ")"
		
	match special:
		1:
			$Panel/SPECIAL.texture.region = Rect2(32,0,16,16)
			$Panel/SPECIAL/Label.text = "The Pistol\nThis again?\nMiddling individual damage.\nMiddling fire rate.\nDamage and fire rate increases with power."
		2:
			$Panel/SPECIAL.texture.region = Rect2(48,0,16,16)
			$Panel/SPECIAL/Label.text = "The Shotgun\nThe kind with the most tent poles.\nFire a fan of pellets.\nKnocks the user back.\nDestroys enemy projectiles.\nMedium-slow fire rate.\nNumber of pellets increases with power."
		3:
			$Panel/SPECIAL.texture.region = Rect2(64,0,16,16)
			$Panel/SPECIAL/Label.text = "The Machine Gun\nFully Automatic!\n...at the cost of low individual damage.\nBlistering fire rate.\nFire rate increases with power."
		4:
			$Panel/SPECIAL.texture.region = Rect2(112,0,16,16)
			$Panel/SPECIAL/Label.text = "The Crossbow\nA shepherd protects the flock.\nFire piercing hitscan bolts for high damage.\nSlow fire rate.\nDestroys enemy projectiles.\nBolt size increases with power."
		_:
			$Panel/SPECIAL/Label.text = "uh oh" + str(special)
	if soldout:
		$Panel/SPECIAL/weapbutton.text = "SOLD OUT"
	else:
		$Panel/SPECIAL/weapbutton.text = "BUY\n($" + str(weacost) + ")"

func rollshop() -> int:
	var roll: int = randi_range(1,4)
	while roll == player.weaponid:
		roll = randi_range(1,4)
	special = roll
	soldout = false
	return roll

func _on_powbutton_pressed() -> void:
	checkButtons(1)
func _on_spebutton_pressed() -> void:
	checkButtons(2) 
func _on_vitbutton_pressed() -> void:
	checkButtons(3)
func _on_weapbutton_pressed() -> void:
	checkButtons(4)
func checkButtons(id):
	if shopping:
		match id:
			1:
				if canBuy(powcost):
					player.money -= powcost
					powcost += 5
					player.dmgbuffcount += 1
					weapongroup.checkStats()
					buynoise.play()
				else:
					blocknoise.play()
			2:
				if canBuy(specost):
					player.money -= specost
					specost += 5
					player.spebuffcount += 1
					player.checkStats()
					buynoise.play()
				else:
					blocknoise.play()
			3:
				if canBuy(vitcost):
					player.money -= vitcost
					vitcost += 5
					player.vitbuffcount += 1
					player.checkStats()
					buynoise.play()
				else:
					blocknoise.play()
			4:
				if canBuy(weacost) and not soldout:
					weapongroup._equip(special)
					soldout = true
					player.money -= weacost
					weacost += 15
					buynoise.play()
				else:
					blocknoise.play()
			_:
				pass
				
func canBuy(cost) -> bool:
	return player.money >= cost
