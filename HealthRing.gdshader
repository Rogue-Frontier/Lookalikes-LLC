shader_type spatial;

uniform sampler2D albedo_texture : source_color;
uniform sampler2D fill_texture : source_color;
uniform float hp;
void fragment() {
	float a = texture(albedo_texture, UV).r;
	a = sqrt(a);
	ALBEDO = texture(fill_texture, UV).rgb;
	
	if(a < hp / 100.0)
	ALPHA = texture(albedo_texture, UV).a;
	else
	ALPHA = 0.0;
}


void vertex() {
    //MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
}