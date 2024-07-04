extends Node2D

@onready var label: Label = $Node2D/Label
var value: float

func set_value(new_value: float):
	self.value = new_value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = "%d" % value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
