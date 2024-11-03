extends Control

var ship_size := Vector2(15, 80)
var direction := 0.0
var speed := 200


func move(delta: float) -> void:
    position.x += delta * direction * speed


func _draw() -> void:
    draw_rect(Rect2(-ship_size/2, ship_size), Color.WHITE, true)