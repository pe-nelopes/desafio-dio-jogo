extends Node

@export var enemy: Enemy
@export var target: Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Player.current_player:
		target = Player.current_player
		
		
func _physics_process(_delta: float) -> void:
	var direction: Vector2
	if enemy and is_instance_valid(target):
		direction = (target.position - enemy.position).normalized()
	else:
		direction = Vector2.ZERO		
	
	enemy.velocity = direction * enemy.speed * Defs.SPD_SCALE
	enemy.move_and_slide()
