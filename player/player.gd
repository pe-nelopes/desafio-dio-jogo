class_name Player
extends CharacterBody2D

static var current_player: Player

@export var speed = 30.0
@export var attack: float = 5.0
@export var health: float = 100.0
@export var death_fx: PackedScene

var is_right: bool = false
var is_running: bool = false
var is_attacking: bool = false

var direction: Vector2
var tween: Tween

@onready var health_bar: ProgressBar = $HealthBar
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var hitbox: Area2D = $Hitbox




func _ready() -> void:
	current_player = self
	health_bar.max_value = health
	health_bar.value = health
	
	
func _physics_process(_delta):
	_attack_process()
	_move_process()


func _process(_delta):
	if not is_attacking:
		if(is_running):
			animation.play(&"walk")
		else:
			animation.play(&"idle")
			
		sprite.flip_h = not is_right


func take_damage(damage: float) -> void:
	health -= damage
	health_bar.value = health
	
	if tween and tween.is_running():
		tween.stop()
	
	modulate = Color.RED
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.2)
	
	if health <= 0 and death_fx:
		die()


func die() -> void:
	var death = death_fx.instantiate()
	death.position = self.position
	get_parent().add_child(death)
	
	queue_free()


func _attack_process() -> void:
	if not is_attacking and Input.is_action_just_pressed(&"attack"):
		is_attacking = true
		animation.play(&"attack")
		
		await get_tree().create_timer(0.3).timeout
		_check_attack_hitbox()
		await get_tree().create_timer(0.3).timeout
		is_attacking = false


func _check_attack_hitbox() -> void:
	if is_attacking:
		for hit in hitbox.get_overlapping_bodies():
			if hit.is_in_group(&"enemy") and _get_sword_hitbox(hit.transform):
				(hit as Enemy).take_damage(attack)


func _move_process() -> void:
	if not is_attacking:
		direction = Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down", 0.1)
		is_running = !direction.is_zero_approx()
		is_right = direction.x > 0 if direction.x != 0 else is_right

		velocity = direction * speed * Defs.SPD_SCALE
		move_and_slide()


func _get_sword_hitbox(hit :Transform2D) -> bool:
	var proj = _get_horizontal_axis().dot(hit.origin-self.transform.origin)
	
	return proj > 0.5

func _get_horizontal_axis() -> Vector2:
	if(is_right):
		return Vector2(1,0)
	else:
		return Vector2(-1,0)
