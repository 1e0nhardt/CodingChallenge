extends TextureRect

@export var grid_width: int = 32
@export var grid_height: int = 32

var img: Image
var snake: Snake
var food: Vector2i
var move_interval := 0.15
var time_elapsed: float = 0
var game_over := false


func _ready() -> void:
    texture_filter = TEXTURE_FILTER_NEAREST
    img = Image.create(grid_width, grid_height, false, Image.FORMAT_RGB8)

    snake = Snake.new(Vector2i(5, 5), 3, img)
    snake.draw()
    spawn_food()
    draw_food()

    texture = ImageTexture.create_from_image(img)


func _process(delta: float) -> void:
    time_elapsed += delta
    if time_elapsed > move_interval:
        var direction: Vector2i = Vector2i.ZERO
        if Input.is_key_pressed(KEY_W):
            direction = Vector2i(0, -1)
        elif Input.is_key_pressed(KEY_A):
            direction = Vector2i(-1, 0)
        elif Input.is_key_pressed(KEY_S):
            direction = Vector2i(0, 1)
        elif Input.is_key_pressed(KEY_D):
            direction = Vector2i(1, 0)

        if direction:
            game_over = snake.move(direction)
            time_elapsed = 0
            if game_over:
                set_process(false)
                $Label.show()

    img.fill(Color.BLACK)
    snake.draw()
    if snake.ate_food:
        snake.ate_food = false
        spawn_food()
    draw_food()
    texture.update(img)


func spawn_food() -> void:
    var candidate := Vector2i(randi_range(0, grid_width - 1), randi_range(0, grid_height- 1))

    while snake.collide_with(candidate):
        candidate = Vector2i(randi_range(0, grid_width- 1), randi_range(0, grid_height- 1))

    food = candidate


func draw_food() -> void:
    img.set_pixelv(food, Color.WHITE)


class Snake:
    var body: Array[Vector2i] = []
    var _img: Image
    var ate_food := false

    func _init(start_pos: Vector2i, length: int, img: Image) -> void:
        _img = img
        for i in length + 1:
            body.append(start_pos + Vector2i.LEFT * i)

    func move(dir: Vector2i) -> bool:
        ate_food = false
        var target = body[0] + dir

        if (collide_with(target)
            or target.x < 0 or target.y < 0
            or target.x >= _img.get_width() or target.y >= _img.get_height()
        ):
            return true

        if eat(target):
            body.append(body[-1])
            ate_food = true

        for i in range(body.size() - 1, 0, -1):
            body[i] = body[i-1]

        body[0] = target

        return false

    func eat(pos: Vector2i) -> bool:
        return _img.get_pixelv(pos) == Color.WHITE

    func collide_with(pos: Vector2i) -> bool:
        var ret = body.find(pos)
        return ret != -1 and ret != (body.size() - 1)

    func draw() -> void:
        for i in body.size() - 1:
            _img.set_pixelv(body[i], Color.WHITE)
        
        _img.set_pixelv(body[0], Color.RED)
        
