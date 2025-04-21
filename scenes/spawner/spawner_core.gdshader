shader_type canvas_item;

uniform vec4 color : source_color;

uniform sampler2D u_wound_texture : source_color;
uniform float u_wound_value : hint_range(0.0, 1.0);

const vec4 WHITE = vec4(1.0, 1.0, 1.0, 1.0);

float polygon(vec2 st, float sides, float size)
{
    // map to -1.0 to 1.0 coordinate system
	vec2 st2 = 2.0 * st - 1.0;
	float angle = atan(st2.x, st2.y);
	float radius = 2.0 * PI / sides;
	float dist = cos(floor(0.5 + angle / radius) * radius - angle) * length(st2);
	return 1.0 - step(size, dist);
}

float wound(vec2 st, sampler2D wound_texture, float wound_value)
{
	vec4 noise_color = texture(wound_texture, st);
	return noise_color.a * floor(wound_value + min(1.0, noise_color.r));
}

void fragment() {
	//COLOR = color;
	//COLOR.a = polygon(UV, 3.0, 0.5);
	if(texture(TEXTURE, UV) == WHITE)
	{
		COLOR = color;
	}
	COLOR.gb *= wound(UV, u_wound_texture, u_wound_value);
}
