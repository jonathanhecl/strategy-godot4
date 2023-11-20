extends CharacterBody2D
class_name Unit

@export var health: int = 100
@export var damage: int = 20
@export var move_speed: float = 50.0
@export var attack_range: float = 20.0
@export var attack_rate: float = 0.5
@export var is_player: bool = false

var agent: NavigationAgent2D
var sprite: Sprite2D

var last_attack_time: float
var target: CharacterBody2D

func _ready():
	agent = $NavigationAgent2D
	sprite = $Sprite
	
	var gm = get_node("/root/Main")
	if is_player:
		gm.players.append(self)
	else:
		gm.enemies.append(self)
	
func _physics_process(delta):
	if agent.is_navigation_finished():
		return
	var direction = global_position.direction_to(agent.get_next_path_position())
	velocity = direction * move_speed
	move_and_slide()
		
func _process(delta):
	check_target()

func check_target():
	if target == null:
		return
	
	var dist = global_position.distance_to(target.global_position)
	if dist <= attack_range:
		agent.target_position = global_position
		try_attack_target()
	else:
		agent.target_position = target.global_position
	
func move_to_location(location):
	target = null
	agent.target_position = location
	
func set_target(new_target):
	target = new_target
	
func try_attack_target():
	if target == null:
		return
		
	var cur_time = Time.get_unix_time_from_system()
	if cur_time - last_attack_time < attack_rate:
		return
		
	target.take_damege(damage)
	last_attack_time = cur_time

func take_damege(damage_to_take):
	health -= damage_to_take
	
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	
	if health <= 0:
		queue_free()
		return
		
	sprite.modulate = Color.WHITE
