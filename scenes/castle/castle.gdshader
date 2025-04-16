shader_type canvas_item;

uniform vec4 color : source_color;

float polygon(vec2 st, float sides, float size)
{
    // map to -1.0 to 1.0 coordinate system
	vec2 st2 = 2.0 * st - 1.0;
	float angle = atan(st2.x, st2.y);
	float radius = 2.0 * PI / sides;
	float dist = cos(floor(0.5 + angle / radius) * radius - angle) * length(st2);
	return 1.0 - step(size, dist);
}

void fragment() {
	COLOR = color;
	//COLOR.a = polygon(UV, 3.0, 0.5);
}
