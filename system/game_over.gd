extends CanvasLayer

@onready var time_label: Label = %TimeLabel
@onready var monster_label: Label = %MonsterLabel

var time_value: String
var monster_count: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time_label.text = time_value
	monster_label.text = str(monster_count)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_time(time: String) -> void:
	time_value = time


func _on_button_pressed() -> void:
	Level.current_level.restart() # Replace with function body.
