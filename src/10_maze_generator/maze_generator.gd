class_name MazeGenerator
extends Control

static var width := 36
static var wall_line_coords := [[0, 0], [1, 0], [1, 1], [0, 1]]

var cols := 32
var rows := 18
var grid := []
var stack := []
var current: Cell

var time_elpased := 0.0
var update_interval := 0.05


func _ready() -> void:
    for y in range(rows):
        for x in range(cols):
            var cell = Cell.new(self, x, y)
            grid.append(cell)

    current = grid[0]


func _process(delta: float) -> void:
    time_elpased += delta
    if time_elpased > update_interval:
        time_elpased = 0
        queue_redraw()


func _draw() -> void:
    for cell in grid:
        cell.draw()

    current.visited = true
    draw_rect(current.get_rect(), Color.LIGHT_PINK)
    var next = check_neighbors(current)
    if next:
        stack.push_back(current)
        remove_walls(current, next)
        current = next
    elif not stack.is_empty():
        current = stack.pop_back()


func index(i: int, j: int) -> int:
    if i < 0 or j < 0 or i > cols - 1 or j > rows - 1:
        return -1
    return i + j * cols


func check_neighbors(cell: Cell) -> Cell:
    var neighbors := []

    for coord in [[0, -1], [1, 0], [0, 1], [-1, 0]]:
        var ind = index(cell.x + coord[0], cell.y + coord[1])
        if ind != -1:
            var neighbor = grid[ind]
            if not neighbor.visited:
                neighbors.append(neighbor)

    if neighbors.size() == 0:
        return null

    return neighbors.pick_random()


func remove_walls(cell: Cell, next: Cell) -> void:
    var dx = next.x - cell.x
    var dy = next.y - cell.y
    var ind = [[0, -1], [1, 0], [0, 1], [-1, 0]].find([dx, dy])
    cell.walls[ind] = false
    next.walls[(ind + 2)%4] = false


class Cell:
    var canvas: Control
    var x: int
    var y: int
    # 上右下左
    var walls := [true, true, true, true]
    var visited := false

    func _init(a_canvas: Control, a_x: int, a_y: int) -> void:
        x = a_x
        y = a_y
        canvas = a_canvas

    func draw() -> void:
        var w = MazeGenerator.width
        var x_pos = x * w
        var y_pos = y * w

        if visited:
            canvas.draw_rect(Rect2(x_pos, y_pos, w, w), Color.REBECCA_PURPLE)

        for i in range(4):
            if walls[i]:
                canvas.draw_line(
                    Vector2(
                        x_pos + w * MazeGenerator.wall_line_coords[i][0],
                        y_pos + w * MazeGenerator.wall_line_coords[i][1]), 
                    Vector2(
                        x_pos + w * MazeGenerator.wall_line_coords[(i+1)%4][0],
                        y_pos + w * MazeGenerator.wall_line_coords[(i+1)%4][1]),
                    Color.WHITE
                )
    
    func get_rect() -> Rect2:
        var w = MazeGenerator.width
        var x_pos = x * w
        var y_pos = y * w
        return Rect2(x_pos, y_pos, w, w)
