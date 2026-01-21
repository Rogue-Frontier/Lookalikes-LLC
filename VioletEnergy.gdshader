shader_type spatial;

uniform sampler2D tex : source_color;
uniform float prog;
uniform vec3 modulate : source_color;

uniform float speed;

uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
void vertex() {
	UV = UV * uv1_scale.xy + uv1_offset.xy;
}

void fragment() {
	vec4 te = texture(tex, UV);
	float v = te.r;
	float diff = clamp(abs(v - prog) * speed, 0, 1.0);
	float a = 1.0 - diff;
	ALBEDO = vec3(a, a, a) * modulate;
	EMISSION = vec3(a, a, a) * modulate;
	ALPHA = a * te.a;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
