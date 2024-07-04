extends Node2D

@export var mob_list: Array[PackedScene]
@export var spawn_interval: float = 10.0

@onready var spawn_position := $Path2D/SpawnPosition


var spawn_timer: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	spawn_timer+= delta
	
	if(spawn_timer >= spawn_interval):
		
		# Get a spawn point
		spawn_position.progress_ratio = randf()
		var point = spawn_position.global_position
		
		# Check if space is valid
		var param = PhysicsPointQueryParameters2D.new()
		param.position = point
		if get_world_2d().direct_space_state.intersect_point(param,1).is_empty():
			# Spawn the mob
			var mob = mob_list[ randi() % mob_list.size()].instantiate()
			mob.position = point
			owner.add_child(mob)
		
		spawn_timer = 0
