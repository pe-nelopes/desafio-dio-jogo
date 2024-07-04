extends Node2D

@export var cooldown: float = 10.0
@export var skill_scene: PackedScene

var timer: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	timer+= delta
	
	if timer >= cooldown:
		timer = 0
		var skill = skill_scene.instantiate()
		add_child(skill)
