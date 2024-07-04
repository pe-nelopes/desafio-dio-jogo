extends Node2D

@export var damage: float = 10

@onready var hitbox: Area2D = $Hitbox


func deal_damage() -> void:
	for hit in hitbox.get_overlapping_bodies():
		if hit.is_in_group(&"enemy"):
			(hit as Enemy).take_damage(damage)
