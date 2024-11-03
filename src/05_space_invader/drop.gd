extends Control

var speed: float = 400
var r := 10


func _process(delta: float) -> void:
    position.y -= delta * speed


func _draw() -> void:
    draw_circle(Vector2.ZERO, r, Color.LIGHT_BLUE, true, -1.0, true)


func collide_with(flowers: Array) -> Variant:
    for flower in flowers:
        if (flower.global_position - global_position).length() < flower.r + r:
            return flower

    return null
