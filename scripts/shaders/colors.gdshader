shader_type canvas_item;

uniform float u_offset_brightness = 0.5;
uniform float u_magnitude = 0.5;
uniform float u_direction = 1.0; // positive directions go in, negative out

const int HORIZONTAL = 0;
const int VERTICAL = 1;

// color gradient pulses outward or inward from the center of a material
float color_pulse_channel(vec2 st, float time, float offset_brightness, float magnitude, float direction, vec2 center, float offset_index)
{
	return offset_brightness + magnitude * sin(time * 2.0 * PI + (direction * distance(st, center) * PI) + 2.0 * offset_index * (PI / 3.0));
}

vec4 color_pulse(vec2 st, float time, float offset_brightness, float magnitude, float direction, vec2 center)
{
	float r = color_pulse_channel(st, time, offset_brightness, magnitude, direction, center, 0.0);
	float g = color_pulse_channel(st, time, offset_brightness, magnitude, direction, center, 1.0);
	float b = color_pulse_channel(st, time, offset_brightness, magnitude, direction, center, 2.0);
	return vec4(r, g, b, 1.0);
}

// color gradient slides along a material
float color_slide_channel(vec2 st, float time, float offset_brightness, float magnitude, int orientation, float direction, float offset_index)
{
    //float movement = 0.0;
    //if(orientation == HORIZONTAL)
    //{
        //movement = direction * st.x;
    //}
    //else if(orientation == VERTICAL)
    //{
        //movement = direction * st.y;
    //}
	// avoids conditional
	float movement = direction * (float(orientation == HORIZONTAL) * st.x + float(orientation == VERTICAL) * st.y);
	return offset_brightness + magnitude * sin(time * 2.0 * PI + movement + 2.0 * offset_index * PI / 3.0);
}

vec4 color_slide(vec2 st, float time, float offset_brightness, float magnitude, int orientation, float direction)
{
	float r = color_slide_channel(st, time, offset_brightness, magnitude, HORIZONTAL, direction, 0.0);
	float g = color_slide_channel(st, time, offset_brightness, magnitude, HORIZONTAL, direction, 0.0);
	float b = color_slide_channel(st, time, offset_brightness, magnitude, HORIZONTAL, direction, 0.0);
	return vec4(r, g, b, 1.0);
}

void fragment()
{
	vec2 center = vec2(0.5, 0.5);
	COLOR = color_pulse(UV, TIME, u_offset_brightness, u_magnitude, u_direction, center);
	//COLOR = color_slide(UV, TIME, u_offset_brightness, u_magnitude, HORIZONTAL, u_direction);
}