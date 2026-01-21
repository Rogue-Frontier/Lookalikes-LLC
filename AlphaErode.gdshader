shader_type spatial;

uniform sampler2D tex : source_color;
uniform sampler2D alphaTex : source_color;

uniform float prog;
uniform vec3 modulate : source_color;
uniform float color_mult  = 1.0;
uniform float rightBound;

uniform float emit = 3.0;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;

void vertex() {
	UV = UV * uv1_scale.xy + uv1_offset.xy;
}
void fragment() {
	vec4 t = texture(tex, UV) * texture(alphaTex, UV);
	float a = t.r;
	if(a < prog){
		a =  0.0;
	} else {
		a = 1.0;
	}
	if(UV.x < rightBound)
		a = 0.0;
	ALBEDO = color_mult * a * modulate;
	EMISSION = a * emit * modulate;
	ALPHA = max(0, a - prog / 2.0);
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
