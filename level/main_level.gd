class_name Level
extends Node2D

@export_category("Difficulty settings")
@export var initial_rate: float = 60.0
@export var spawn_growth_per_minute: float = 30.0
@export var wave_duration: float = 20.0
@export var break_intensity: float = 0.5

@export_category("Game over screen")
@export var game_over_scene: PackedScene


@onready var time_label: Label = $UI/Panel/GameTimer
@onready var mob_spawner: MobSpawner = %MobSpawner
@onready var ui: CanvasLayer = $UI


var level_over: bool = false

static var current_level: Level


var level_time: float = 0.0
var monster_count: int = 0
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_level = self

func _physics_process(delta: float) -> void:
	if level_over:
		return
		
	level_time+= delta
		
	var spawn_rate = initial_rate + spawn_growth_per_minute * (level_time/60)
	
	var sin_wave = sin(level_time*TAU/wave_duration)
	var wave_factor = remap(sin_wave, -1,1,break_intensity,1)
	spawn_rate*= wave_factor
	
	mob_spawner.spawn_interval = 60/spawn_rate

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if level_over:
		return
		
	if time_label:
		time_label.text = get_time_string()


func increase_mosnter_counter() -> void:
	monster_count+=1

func end_level() -> void:
	level_over = true
	mob_spawner.queue_free()
	ui.queue_free()
	
	var game_over = game_over_scene.instantiate()
	game_over.set_time(get_time_string())
	game_over.monster_count = monster_count
	add_child(game_over)


func restart() -> void:
	get_tree().reload_current_scene()
	
	
func get_time_string() -> String:
	var minutes: int = floori(level_time)/60
	var seconds: int = floori(level_time)%60
	return "%02d:%02d" % [minutes, seconds]
