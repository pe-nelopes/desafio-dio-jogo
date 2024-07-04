extends Node2D

@onready var time_label: Label = $UI/Panel/GameTimer

var elapsed_time: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	elapsed_time+= delta
	var minutes: int = floori(elapsed_time)/60
	var seconds: int = floori(elapsed_time)%60
	time_label.text = "%02d:%02d" % [minutes, seconds]
