extends Control

var drops: Array = []


func _ready() -> void:
    for i in 300:
        var drop = Drop.new(
            self,
            randf_range(0, size.x), 
            randf_range(-300, -50), 
            randf_range(0, 20)
        )
        drop.y_speed = randf_range(5, 15)
        drops.append(drop)


func _physics_process(_delta: float) -> void:
    for drop in drops:
        drop.fall()
    queue_redraw()


func _draw() -> void:
    draw_rect(get_rect(), Color8(230, 230, 250), true)
    for drop in drops:
        drop.draw()


class Drop:
    var x: float
    var y: float
    var z: float
    var length: float
    var y_speed: float = 10
    var width: float = 3
    var gravity: float = 0.1
    var canvas: Control

    func _init(a_canvas: Control, a_x: float, a_y: float, a_z: float) -> void:
        canvas = a_canvas
        x = a_x
        y = a_y
        z = a_z
        length = Util.map(z, 0, 20, 40, 10)
        width = Util.map(z, 0, 20, 5, 1)
        gravity = Util.map(z, 0, 20, 0.2, 0.1)

    func fall():
        y += y_speed
        y_speed += gravity
        if y > canvas.size.y:
            y = randf_range(-300, 0)
            y_speed = randf_range(5, 15)
            z = randf_range(0, 20)

    func draw():
        canvas.draw_line(Vector2(x, y), Vector2(x, y + length), Color8(138, 43, 226), 3)


