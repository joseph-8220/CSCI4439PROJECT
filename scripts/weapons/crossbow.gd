extends CharacterBody2D
var projectile_path=preload("res://scenes/projectile.tscn")
var weaponid = 4
var fire_rate: float = 2.5
var damage: int = 8
var maxrange: int = 1000
# A VENATOR DOESN'T TRAFFIC IN MERCY

@onready var bolt_box: Area2D = $Area2D
@onready var bolt_line: Line2D = $Line2D


func checkStats():
	damage = 8 + get_parent().player.dmgbuffcount
	get_parent().damage = damage
	get_parent().fire_rate = fire_rate
	$"../Sprite2D".frame = 6
	
func _ready():
	bolt_line.visible = false

func use(damage):
	bolt_line.visible = true
	var targets = bolt_box.get_overlapping_bodies()
	for body in targets:
		if body.is_in_group("enemy"):
			body.enemyhealth -= damage
	get_tree().get_first_node_in_group("player").knockback = -Vector2.from_angle(global_rotation) * 50
	await get_tree().create_timer(.15).timeout
	bolt_line.visible = false
	
	
	
