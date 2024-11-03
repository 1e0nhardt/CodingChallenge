extends Control

var cells := []


func _ready() -> void:
    for i in range(30):
        var cell = Cell.new(
            self,
            randf_range(0, get_viewport_rect().size.x),
            randf_range(0, get_viewport_rect().size.y),
            randf_range(20, 30)
        )
        cells.append(cell)


func _process(_delta: float) -> void:
    for cell in cells:
        cell.move()


func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
            var cells_to_remove := []
            for i in cells.size():
                if (cells[i].pos - event.position).length() < cells[i].r:
                    cells.append_array(cells[i].mitosis())
                    cells_to_remove.append(cells[i])
            
            for cell in cells_to_remove:
                cell.free_rid()
                cells.erase(cell)

            cells_to_remove.clear()


class Cell extends RefCounted:
    var pos := Vector2()
    var r := 1.0
    var canvas: Control
    var color := Color()
    var rid: RID
    var mat_rid: RID
    var material: Material

    func _init(
        a_canvas: Control,
        x: float, y: float, a_r: float,
        a_color: Color = Color(randf() * 0.5 + 0.5, randf() * 0.5 + 0.5, randf() * 0.5 + 0.5)
    ) -> void:
        canvas = a_canvas
        pos = Vector2(x, y)
        r = a_r
        color = a_color
        rid = RenderingServer.canvas_item_create()
        material = ShaderMaterial.new()
        material.shader = load("res://src/06_mitosis/mitosis_cell.gdshader")
        material.set_shader_parameter("u_color", color)
        mat_rid = material.get_rid()

        RenderingServer.canvas_item_set_parent(rid, canvas.get_canvas_item())
        RenderingServer.canvas_item_add_rect(rid, Rect2(-Vector2.ONE*r, Vector2.ONE*2*r), Color.BLACK)
        RenderingServer.canvas_item_set_transform(rid, Transform2D(0, pos))
        RenderingServer.canvas_item_set_material(rid, mat_rid)

    func move():
        pos += Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
        RenderingServer.canvas_item_set_transform(rid, Transform2D(0, pos))

    func mitosis() -> Array[Cell]:
        var new_cell = Cell.new(canvas, pos.x, pos.y, r * 0.8, color)
        var new_cell_2 = Cell.new(canvas, pos.x, pos.y, r * 0.8, color)
        return [new_cell, new_cell_2]

    func free_rid() -> void:
        RenderingServer.free_rid(rid)
