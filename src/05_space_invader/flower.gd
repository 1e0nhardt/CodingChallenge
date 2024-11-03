extends Control

signal border_reached

var r := 20
var speed := 300
var direction := 1.0


func move(delta: float) -> void:
    position.x += delta * speed * direction
    if position.x > (get_viewport_rect().size.x - 5 - r*2) or position.x < 5:
        border_reached.emit()
    

func grow() -> void:
    r += 5
    queue_redraw()


func _draw() -> void:
    draw_circle(Vector2(r, r), r, Color.PALE_VIOLET_RED, true, -1.0, true)