shader_type canvas_item;
uniform vec2 mouse_pos;

void fragment() {
    vec2 st = vec2(UV.x, 1.-UV.y) - vec2(.5);
    vec2 mouse = vec2(mouse_pos.x, 1.-mouse_pos.y);
    
    float zoom = pow(10., -mouse.x * 3.);
    
    // Mandelbrot Set
    vec2 c = st * zoom * 3.;
    // c += vec2(-.75, .15);
    c += vec2(-.69955, .37999);
    vec2 z = vec2(0.);

    // Julia Set
    // vec2 z = st * zoom * 3.;
    // vec2 c = vec2(0.285, 0.01);
    
    float iter = 0.;
    const float max_iter = 200.;
    
    // f(z) = z^2 + c
    for (float i = 0.; i < max_iter; i++) {
        z = vec2(z.x*z.x - z.y*z.y, 2.*z.x*z.y) + c;
        if (length(z) > 2.) {
            break;
        }
        iter++;
    }
    
    float bright = iter / max_iter;
    bright = sqrt(bright);
    
    if (iter == max_iter)
        bright = 0.1;
        
    vec3 color = vec3(bright);
    COLOR = vec4(color, 1.);
}
