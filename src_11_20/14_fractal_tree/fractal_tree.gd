extends Control

# OO
var tree := []
var levels := 6

# L-System
var axiom := "F"
var rules := {
    "F": "FF+[+F-F-F]-[-F+F+F]"
}

# plant
# var axiom := "X"
# var rules := {
#     "X": "F+[[X]-X]-F[-FX]+X",
#     "F": "FF"
# }

var sentence := axiom
var line_len := 180.0

@onready var width = get_viewport().size.x
@onready var height = get_viewport().size.y


func _ready() -> void:
    # 15 OO method
    tree.append(Branch.new(self, Vector2(width / 2, height), Vector2(width / 2, height - 180), 0))
    for i in levels:
        generate_branches(i)


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_accept"):
        # 16 L-System method
        l_system_generate()
        line_len *= 0.5

        # 15 OO method
        # generate_branches(tree[-1].level + 1)


func _draw() -> void:
    # 14 recursive method
    # branch_recursive(Vector2(width / 2, height), PI / 2, 180, 15, Color.GREEN)
    
    # 15 OO method
    # for b in tree:
    #     b.draw()

    # 16 L-System method
    draw_sentence()


func branch_recursive(pos, angle, length, b_width, color) -> void:
    var x = pos.x + cos(angle) * length
    var y = pos.y - sin(angle) * length
    draw_line(pos, Vector2(x, y), color, b_width)

    if length > 10:
        branch_recursive(Vector2(x, y), angle + PI / 6, length * 0.7, b_width * 0.7, Color.GREEN)
        branch_recursive(Vector2(x, y), angle - PI / 6, length * 0.7, b_width * 0.7, Color.GREEN)


func generate_branches(level: int) -> void:
    for j in range(tree.size() - 1, -1, -1):
        if tree[j].finished:
            continue

        tree.append(tree[j].branch(level, true))
        tree.append(tree[j].branch(level, false))
        tree[j].finished = true
    
    queue_redraw()


func l_system_generate() -> void:
    var next_sentence = ""

    for ch in sentence:
        if ch in rules.keys():
            next_sentence += rules[ch]
        else:
            next_sentence += ch

    sentence = next_sentence
    queue_redraw()


func draw_sentence() -> void:
    var start := Vector2(width / 2, height)
    var end := Vector2()
    var angle := deg_to_rad(25)
    var dir := Vector2(0, -1)
    var stack := []

    for ch in sentence:
        match ch:
            'F':
                end = start + dir * line_len
                draw_line(start, end, Color.WHITE, 2)
                start = end
            '+':
                dir = dir.rotated(angle)
            '-':
                dir = dir.rotated(-angle)
            "[":
                stack.push_back([start, dir])
            "]":
                var last = stack.pop_back()
                start = last[0]
                dir = last[1]


class Branch:
    var canvas: Control
    var start: Vector2
    var end: Vector2
    var level: int
    var finished: bool = false

    func _init(a_canvas: Control, a_start: Vector2, a_end: Vector2, a_level: int) -> void:
        canvas = a_canvas
        start = a_start
        end = a_end
        level = a_level

    func branch(a_level: int, left: bool) -> Branch:
        var l_start = end
        var rotate_angle: float = 0.0
        if left:
            rotate_angle = PI / 6
        else:
            rotate_angle = -PI / 6
        var dir = (end - start).rotated(rotate_angle)
        var l_end = end + dir * 0.67
        return Branch.new(canvas, l_start, l_end, a_level)

    func draw() -> void:
        var color = Color.GREEN
        color.h += fmod(level * 0.1, 1.0)
        canvas.draw_line(start, end, color, 2)
