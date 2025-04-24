shader_type canvas_item;

uniform sampler2D u_dissolve_texture : source_color;
uniform float u_dissolve_value : hint_range(0.0, 1.0);

float dissolve(vec2 st, sampler2D dissolve_texture, float dissolve_value)
{
    vec4 noise_color = texture(dissolve_texture, st);
    return noise_color.a * floor(dissolve_value + min(1, noise_color.r));
}

void fragment() {
	COLOR.a *= dissolve(UV, u_dissolve_texture, u_dissolve_value);
}
