# @tool
extends Control

var stars: Array = []
var speed: float = 20.0


func _ready() -> void:
    var width = size.x
    var height = size.y
    for i in range(500):
        var x = randf_range(-width, width)
        var y = randf_range(-height, height)
        var z = randf_range(0, width)
        stars.append(Star.new(x, y, z, self))


func _draw() -> void:
    draw_rect(get_rect(), Color(0.1, 0.1, 0.1))
    
    for star in stars:
        star.update(speed)
        star.draw()


func _process(_delta: float) -> void:
    queue_redraw()


class Star:
    var x: float
    var y: float
    var z: float
    var prev_z: float
    
    var canvas: Control

    func _init(a_x: float, a_y: float, a_z: float, a_canvas: Control):
        x = a_x
        y = a_y
        z = a_z
        prev_z = a_z
        canvas = a_canvas

    func update(speed: float) -> void:
        prev_z = z + speed * 2
        z -= speed

        if z <= 0:
            z = canvas.size.x
            x = randf_range(-canvas.size.x, canvas.size.x)
            y = randf_range(-canvas.size.y, canvas.size.y)
            prev_z = z

    func draw() -> void:
        var sx = x/z * canvas.size.x
        var sy = y/z * canvas.size.y

        var px = x/prev_z * canvas.size.x
        var py = y/prev_z * canvas.size.y

        var r = (1.0 - z/(canvas.size.x*2))**2 * 3

        canvas.draw_circle(Vector2(sx, sy) + canvas.size/2, r, Color.WHITE)
        canvas.draw_line(
            Vector2(px, py) + canvas.size/2, 
            Vector2(sx, sy) + canvas.size/2, 
            Color.WHITE, 
            4.0
        )
