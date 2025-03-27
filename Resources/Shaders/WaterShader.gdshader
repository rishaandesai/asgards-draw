shader_type canvas_item;
/*
uniform vec2 speed = vec2(0.05, 0.05);
uniform vec2 speedSecondNoise = vec2(-0.05, -0.05);
uniform float distortionStrength: hint_range(-1, 1) = 0.2;

uniform vec4 toneColor : source_color;
uniform vec4 topColor : source_color;

uniform float lightStart : hint_range(0.0, 1.0) = 0.275;
uniform float lightEnd : hint_range(0.0, 1.0) = 0.4;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform float pixelSize = 2.0;

uniform vec2 deep_water_tile;
uniform vec2 shallow_water_tile;
uniform vec2 tile_size;
uniform vec2 atlas_texture_size;

float rand(vec2 co) {
	return fract(sin(dot(co.xy, vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	return mix(
		mix(rand(i), rand(i + vec2(1.0, 0.0)), f.x),
		mix(rand(i + vec2(0.0, 1.0)), rand(i + vec2(1.0, 1.0)), f.x),
		f.y
	);
}

void fragment() {
	vec2 tile_pos = floor(FRAGCOORD.xy / tile_size);
	vec2 atlas_tile_count = atlas_texture_size / tile_size;
	vec2 tile_index = mod(tile_pos, atlas_tile_count);

	bool is_deep = all(equal(tile_index, deep_water_tile));
	bool is_shallow = all(equal(tile_index, shallow_water_tile));

	vec4 base_color = texture(TEXTURE, UV);

	if (!(is_deep || is_shallow)) {
		COLOR = base_color;
	} else {
		vec2 uv = UV;
		uv *= pixelSize;
		vec2 base_uv = floor(uv) / pixelSize;

		float depth1 = noise(base_uv + speed * TIME);
		float depth2 = noise(base_uv + speedSecondNoise * TIME);
		float depth = depth1 * depth2;

		vec4 distortion_color = texture(SCREEN_TEXTURE, SCREEN_UV + distortionStrength * vec2(depth));
		vec4 topLight = smoothstep(lightStart, lightEnd, depth) * topColor;
		COLOR = mix(base_color, distortion_color * toneColor + topLight, 0.65);
		COLOR.a = 1.0;
	}
}
*/