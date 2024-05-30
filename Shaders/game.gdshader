shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
//uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;
// https://www.youtube.com/watch?v=Dn8joy4tP2Q
uniform float scan_line_count : hint_range(0, 1080) = 50.0;

vec2 uv_curve(vec2 uv) {
	uv = (uv - 0.5) * 2.0;	
	uv.x *= 1.0 + pow(abs(uv.y) / 20.0, 2.0);
	uv.y *= 1.0 + pow(abs(uv.x) / 20.0, 2.0);
	uv /= 1.1;
	uv = (uv / 2.0) + 0.5;
	return uv;
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 screen_uv = SCREEN_UV;
	float r = texture(SCREEN_TEXTURE, uv_curve(SCREEN_UV) + vec2(SCREEN_PIXEL_SIZE.x*0.0), 0.0).r;
	float g = texture(SCREEN_TEXTURE, uv_curve(SCREEN_UV) + vec2(SCREEN_PIXEL_SIZE.x*1.0), 0.0).g;
	float b = texture(SCREEN_TEXTURE, uv_curve(SCREEN_UV) + vec2(SCREEN_PIXEL_SIZE.x*-1.0), 0.0).b;
	
	float s = sin(uv_curve(SCREEN_UV).y * scan_line_count * PI * 2.0);
	s = (s * 0.5 + 0.5) * 0.9 + 0.85;
	vec4 scan_line = vec4(vec3(pow(s,0.25)), 1.0);
	COLOR = vec4(r,g,b, 1.0) * scan_line;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
