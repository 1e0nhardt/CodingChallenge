shader_type canvas_item;

uniform vec3 u_color;

void fragment() {
    float r = length(UV - 0.5);
	COLOR = vec4(u_color, (0.25 + r*r) * smoothstep(0.51, 0.49, r));
}
