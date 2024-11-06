extends Control

## Reaction Diffusion Algorithm: https://karlsims.com/rd.html

const KERNEL = [
    [0.05,  0.2, 0.05],
    [ 0.2, -1.0, 0.2 ],
    [0.05,  0.2, 0.05]
]

var width := 160
var height := 90
var grid: Image
var next: Image
var tex: ImageTexture

var dA := 1.0
var dB := 0.5
var feed := 0.055
var kill := 0.062

@onready var canvas: TextureRect = $Canvas


func _ready() -> void:
    grid = Image.create(width, height, false, Image.FORMAT_RGBH)
    next = Image.create(width, height, false, Image.FORMAT_RGBH)
    grid.fill(Color(1.0, 0.0, 0.0))
    next.fill(Color(1.0, 0.0, 0.0))
    tex = ImageTexture.create_from_image(grid)
    canvas.texture = tex
    canvas.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

    for i in range(60, 70):
        for j in range(40, 50):
            grid.set_pixel(i, j, Color(0.0, 0.0, 1.0))


# 非常慢
func _process(_delta: float) -> void:
    for y in range(1, grid.get_height() - 1):
        for x in range(1, grid.get_width() - 1):
            var p := grid.get_pixel(x, y)
            var q = Color()
            q.r = p.r + (dA * laplacian(x, y, true) - p.r * p.b * p.b + feed * (1.0 - p.r)) * 1
            q.b = p.b + (dB * laplacian(x, y, false) + p.r * p.b * p.b - (kill + feed) * p.b) * 1
            next.set_pixel(x, y, q)
    
    swap()
    tex.update(grid)


func laplacian(x: int, y: int, A: bool) -> float:
    var sum := 0.0
    for i in range(-1, 2):
        for j in range(-1, 2):
            if x + i < 0 or x + i >= grid.get_width() or y + j < 0 or y + j >= grid.get_height():
                continue
            if A:
                sum += grid.get_pixel(x+i, y+j).r * KERNEL[i+1][j+1]
            else:
                sum += grid.get_pixel(x+i, y+j).b * KERNEL[i+1][j+1]
    return sum


func swap() -> void:
    var tmp := grid
    grid = next
    next = tmp