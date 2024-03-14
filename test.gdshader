shader_type canvas_item;

uniform float scale = 1.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D distortionTexture;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 distortionUV = SCREEN_UV + texture(TEXTURE, UV).a * 0.1;
	vec4 screen_color = texture(distortionTexture, distortionUV);
	COLOR = screen_color;
	//vec2 distortionUV = UV;
	//distortionUV.x += distortionUV.y * 0.0;
	//vec4 pixel_color = texture(TEXTURE, distortionUV * scale);
	//COLOR = pixel_color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
