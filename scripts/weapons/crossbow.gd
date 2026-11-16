extends CharacterBody2D
var weaponid = 4
var fire_rate: float = 2.5
var damage: int = 8
var maxrange: int = 1000

# A VENATOR DOESN'T TRAFFIC IN MERCY

@onready var bolt_box: Area2D = $Area2D
@onready var bolt_line: Line2D = $Line2D
@onready var base_width: float = bolt_line.width
@onready var crossbow_sound: AudioStreamPlayer2D = $CrossbowSound

func checkStats():
	damage = 8 + get_parent().player.dmgbuffcount
	get_parent().damage = damage
	if fire_rate  > 0.1:
		fire_rate = 2.5 - get_parent().player.dmgbuffcount * 0.03
	get_parent().fire_rate = fire_rate 
	$"../Sprite2D".frame = 6
	var widthmultiplier = 1.0 + (get_parent().player.dmgbuffcount * 0.15)
	bolt_box.scale.y = widthmultiplier
	bolt_line.width = base_width * widthmultiplier
func _ready():
	bolt_line.visible = false

func use(damage):
	bolt_line.visible = true
	crossbow_sound.pitch_scale = randf_range(0.85, 1.10)
	crossbow_sound.play()
	var targets = bolt_box.get_overlapping_bodies()
	for body in targets:
		if body.is_in_group("enemy"):
			body.enemyhealth -= damage
	var areas = bolt_box.get_overlapping_areas()
	for area in areas:
		if area.is_in_group("enemy_projectile"):
			area.queue_free()
	get_tree().get_first_node_in_group("player").knockback = -Vector2.from_angle(global_rotation) * 50
	await get_tree().create_timer(.15).timeout
	bolt_line.visible = false
	
	
	
