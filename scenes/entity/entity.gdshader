shader_type canvas_item;

uniform vec4 color : source_color;

uniform sampler2D u_dissolve_texture : source_color;
uniform float u_dissolve_value : hint_range(0.0, 1.0);

uniform sampler2D u_wound_texture : source_color;
uniform float u_wound_value : hint_range(0.0, 1.0);

const vec4 WHITE = vec4(1.0, 1.0, 1.0, 1.0);

float circle(vec2 st, vec2 center, float radius)
{
	return step(distance(st, center), radius);
}

float dissolve(vec2 st, sampler2D dissolve_texture, float dissolve_value)
{
    vec4 noise_color = texture(dissolve_texture, st);
    return noise_color.a * floor(dissolve_value + min(1, noise_color.r));
}

float wound(vec2 st, sampler2D wound_texture, float wound_value)
{
	vec4 noise_color = texture(wound_texture, st);
	return noise_color.a * floor(wound_value + min(1.0, noise_color.r));
}

void fragment()
{
	//COLOR = texture(TEXTURE, UV);
	if(texture(TEXTURE, UV) == WHITE)
	{
		COLOR = color;
	}
	vec2 center = vec2(0.5, 0.5);
	float radius = 0.5;
	//COLOR.a *= circle(UV, center, radius);
	COLOR.a *= dissolve(UV, u_dissolve_texture, u_dissolve_value);
	COLOR.gb *= wound(UV, u_wound_texture, u_wound_value);
}
