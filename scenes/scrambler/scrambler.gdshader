shader_type canvas_item;

float circle(vec2 st, vec2 center, float radius)
{
	return step(distance(st, center), radius);
}

void fragment()
{
	vec2 center = vec2(0.5, 0.5);
	float radius = 0.5;
	float modulation = 0.2;
	COLOR.a *= circle(UV, center, radius);
	COLOR.a *= modulation;
}
