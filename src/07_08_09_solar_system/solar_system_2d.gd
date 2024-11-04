extends Control

@onready var planet: Control = $Planet


func _ready():
    planet.spawn_moons(3, 1)


func _draw() -> void:
    draw_circle(Vector2(0, 0), 5, Color(1, 0, 0))