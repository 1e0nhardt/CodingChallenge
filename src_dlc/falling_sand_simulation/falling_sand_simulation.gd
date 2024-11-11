extends Control

const SAND_COLOR := Color("dcb159")
const BACKGROUND_COLOR := Color("f6f6f6")

@onready var canvas: TextureRect = %Canvas

var grid_size := Vector2i(64, 36) * 2
var image_size := Vector2(1152, 648)
var cell_size := Vector2(image_size.x / grid_size.x, image_size.y / grid_size.y)
var brush_radius := 2

var grid: Image
var grid_texture: ImageTexture

var handle_input_intervel := brush_radius
var frame_count := 0


func _ready() -> void:
    canvas.size = image_size
    grid = Image.create(grid_size.x, grid_size.y, false, Image.FORMAT_RGB8)
    grid.fill(BACKGROUND_COLOR)
    grid_texture = ImageTexture.create_from_image(grid)
    canvas.position -= Vector2(image_size.x / 2, image_size.y / 2)
    canvas.texture = grid_texture
    canvas.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

    # canvas.draw.connect(on_canvas_draw)


func _physics_process(_delta: float) -> void:
    frame_count += 1
    if frame_count > handle_input_intervel:
        frame_count = 0
        # 输入处理
        if Input.is_mouse_button_pressed(MouseButton.MOUSE_BUTTON_LEFT):
            var mouse_pos = canvas.get_local_mouse_position()
            var pixel_pos: Vector2i = floor(mouse_pos / cell_size)
            set_aerated_circle(pixel_pos)
            # if pixel_pos.x < 0 or pixel_pos.y < 0 or pixel_pos.x >= grid_size.x or pixel_pos.y >= grid_size.y:
            #     return
            # var color = vary_color(SAND_COLOR)
            # grid.set_pixelv(pixel_pos, color)

    # 更新画布
    grid_texture.update(grid)

    # Step
    for y in range(grid_size.y - 1, -1, -1):
        for x in range(grid_size.x):
            var pos = Vector2i(x, y)
            update_cell(pos)


func update_cell(pos: Vector2i) -> void:
    if is_empty(pos):
        return
        
    var below = pos + Vector2i(0, 1)
    var below_left = below + Vector2i(-1, 0)
    var below_right = below + Vector2i(1, 0)

    if is_empty(below):
        swap(pos, below)
    elif is_empty(below_left):
        swap(pos, below_left)
    elif is_empty(below_right):
        swap(pos, below_right)

    # return

    # if (below.y >= grid_size.y):
    #     return

    # if below.y < grid_size.y and is_empty(below):
    #     swap(pos, below)
    #     return

    # if below_left.x < 0 and is_empty(below_right):
    #     swap(pos, below_right)
    #     return

    # if below_right.x >= grid_size.x and is_empty(below_left):
    #     swap(pos, below_left)
    #     return

    # if (below_left.x < 0
    #     or below_right.x >= grid_size.x
    # ):
    #     return

    # if is_empty(below_left):
    #     swap(pos, below_left)
    # elif is_empty(below_right):
    #     swap(pos, below_right)


func is_empty(pos: Vector2i) -> bool:
    if not is_valid_position(pos):
        return false

    return grid.get_pixelv(pos) == BACKGROUND_COLOR


func is_valid_position(pos: Vector2i) -> bool:
    if pos.x < 0 or pos.x >= grid_size.x or pos.y < 0 or pos.y >= grid_size.y:
        return false
    return true


func swap(a: Vector2i, b: Vector2i) -> void:
    var temp = grid.get_pixelv(a)
    grid.set_pixelv(a, grid.get_pixelv(b))
    grid.set_pixelv(b, temp)


# 中点画圆算法
func set_aerated_circle(pos: Vector2i) -> void:
    var x: int = 0
    var y: int = -brush_radius
    var p: int = -brush_radius
    while x < -y:
        if p > 0:
            y += 1
            p += 2*(x+y) + 1
        else:
            p += 2*x + 1

        for x_fill in range(0, x + 1):
            random_set_grid_pixel_color(Vector2i(pos.x + x_fill, pos.y + y))
            random_set_grid_pixel_color(Vector2i(pos.x - x_fill, pos.y + y))
            random_set_grid_pixel_color(Vector2i(pos.x + x_fill, pos.y - y))
            random_set_grid_pixel_color(Vector2i(pos.x - x_fill, pos.y - y))

        for y_fill in range(y, 1):
            random_set_grid_pixel_color(Vector2i(pos.x + y_fill, pos.y + x))
            random_set_grid_pixel_color(Vector2i(pos.x - y_fill, pos.y + x))
            random_set_grid_pixel_color(Vector2i(pos.x + y_fill, pos.y - x))
            random_set_grid_pixel_color(Vector2i(pos.x - y_fill, pos.y - x))

        x += 1


func random_set_grid_pixel_color(pos: Vector2i) -> void:
    if is_valid_position(pos) and randf() < 0.5:
        grid.set_pixelv(pos, vary_color(SAND_COLOR))


func vary_color(color: Color) -> Color:
    color.s -= randf() * 0.1
    color.v += randf_range(-1, 1) * 0.1
    return color


func on_canvas_draw() -> void:
    var y = 0
    while  y <= image_size.y:
        canvas.draw_line(Vector2(0, y), Vector2(image_size.x, y), Color(0.6, 0.8, 0.2), 2)
        y += cell_size.y

    var x = 0
    while  x <= image_size.x:
        canvas.draw_line(Vector2(x, 0), Vector2(x, image_size.y), Color(0.6, 0.8, 0.2), 2)
        x += cell_size.x
