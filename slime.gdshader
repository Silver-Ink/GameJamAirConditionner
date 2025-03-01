shader_type canvas_item;

uniform sampler2D slimeTexture1 : repeat_enable, filter_nearest;
uniform sampler2D slimeTexture2 : repeat_enable, filter_nearest;
uniform sampler2D slimeTexture3 : repeat_enable, filter_nearest;
uniform float scale = .1;
uniform float pixelate = 40;
varying vec2 worldPosition;

void vertex() {
	vec2 grid_uv = round(VERTEX * float(pixelate)) / float(pixelate);
	worldPosition = (MODEL_MATRIX * vec4(grid_uv, 0., 1.)).xy;
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 dir = vec2(10., 10.);
	vec4 layer1 = texture(slimeTexture1, (worldPosition + dir * TIME) * scale);
	vec4 layer2 = texture(slimeTexture2, worldPosition * scale);
	vec4 layer3 = texture(slimeTexture3, worldPosition * scale);
	
	vec4 color;
	color = mix(layer1, layer2, layer2.a);
	color = mix(color, layer3, layer3.a);
	COLOR = color;
}
