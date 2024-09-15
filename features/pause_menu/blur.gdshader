shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float amount: hint_range(0.0, 5.0) = 1.5;

void fragment() {
	vec4 color = textureLod(screen_texture, SCREEN_UV, amount);
	COLOR = vec4(color.rgb, 1.0);
}
