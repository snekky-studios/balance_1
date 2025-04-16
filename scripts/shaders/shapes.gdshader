shader_type canvas_item;

float circle(vec2 st, vec2 center, float radius)
{
	return step(distance(st, center), radius);
}

float rectangle(vec2 st, vec2 top_left, vec2 bottom_right)
{
	float top = 1.0 - step(st.y, top_left.y);
	float left = 1.0 - step(st.x, top_left.x);
	float bottom = step(st.y, bottom_right.y);
	float right = step(st.x, bottom_right.x);
	return top * left * bottom * right;
}

float parallelogram(vec2 st, vec2 start, vec2 end, float thickness)
{
	float top = 1.0 - step(st.y, start.y);
	float bottom = step(st.y, end.y);
	float left_edge = mix(start.x, end.x, st.y);
	float left = 1.0 - step(st.x + 0.5 * thickness, left_edge);
	float right_edge = mix(start.x, end.x, st.y);
	float right = step(st.x - 0.5 * thickness, right_edge);
	return top * bottom * left * right;
}

float polygon(vec2 st, float sides, float size)
{
    // map to -1.0 to 1.0 coordinate system
	vec2 st2 = 2.0 * st - 1.0;
	float angle = atan(st2.x, st2.y);
	float radius = 2.0 * PI / sides;
	float dist = cos(floor(0.5 + angle / radius) * radius - angle) * length(st2);
	return 1.0 - step(size, dist);
}

void fragment()
{
	vec2 center = vec2(0.5, 0.5);
	float radius = 0.5;
	COLOR.a = circle(UV, center, radius);

    vec2 start_rect = vec2(0.1, 0.1);
	vec2 end_rect = vec2(0.8, 0.7);
	//COLOR.a = rectangle(UV, start_rect, end_rect);

    vec2 start_para = vec2(0.05, 0.00);
    vec2 end_para = vec2(0.25, 0.45);
    //COLOR.a = parallelogram(UV, start_para, end_para, 0.1);

    float triangle_sides = 3.0;
    //COLOR.a = polygon(UV, triangle_sides, 0.4);
}