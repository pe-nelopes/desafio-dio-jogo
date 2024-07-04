class_name Enemy
extends CharacterBody2D

@export_category("Stats")
@export var health: float = 20.0
@export var attack: float = 1.0
@export var speed: float = 10.0

@export_category("Drops")
@export var drop_chance: float = 1
@export var drop_list: Array[PackedScene]

@export_category("Effects")
@export var damage_fx: PackedScene
@export var death_fx: PackedScene

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var attack_range: Area2D = $AttackRange



var is_attacking: bool = false
var is_right: bool = false


func _physics_process(_delta):
	is_right = velocity.x > 0 if velocity.x != 0 else is_right
	damage_check()


func _process(_delta: float) -> void:
	if velocity.is_zero_approx():
		animation.play(&"idle")
	else:
		animation.play(&"walk")
		
	$Sprite2D.flip_h = not is_right

func take_damage(damage: float) -> void:
	health -= damage
	
	var effect = damage_fx.instantiate()
	effect.set_value(damage)
	effect.position = self.position
	get_parent().add_child(effect)
	
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.2)
	
	if health <= 0 and death_fx:
		die()


func die() -> void:
	var death = death_fx.instantiate()
	death.position = self.position
	get_parent().add_child(death)
	
	if randf() < drop_chance:
		var drop = drop_list.pick_random().instantiate()
		drop.position = self.position
		get_parent().add_child(drop)
	
	queue_free()


func damage_check():
	if not is_attacking:
		var target = $FollowBehaviour.target
		
		if not target:
			return
		
		if target in attack_range.get_overlapping_bodies():
			is_attacking = true
			
			if target is Player:
				target.take_damage(attack)

			var attack_direction = (target.position - self.position).normalized()
			attack_direction*= 20
			
			var tween_offset = create_tween()
			tween_offset.tween_property($Sprite2D, "offset", attack_direction, 0.1)				
			tween_offset.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
			tween_offset.tween_property($Sprite2D, "offset", Vector2(), 0.2)
			
			await get_tree().create_timer(1).timeout
			is_attacking = false
	
