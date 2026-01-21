shader_type spatial;

uniform sampler2D tex : source_color;

uniform float prog;
uniform vec3 modulate : source_color;
uniform sampler2D albedo_tex : source_color;
uniform float color_mult  = 1.0;
uniform float fadeBound;
uniform float decay = 10.0;
uniform float decay2 = 10.0;
uniform float fadeBound2;
uniform float decay3 = 10.0;
uniform float emit = 3.0;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 alpha_scale;
void vertex() {
	UV = UV * uv1_scale.xy + uv1_offset.xy;
}
void fragment() {
	vec4 t = texture(tex, UV * alpha_scale.xy);
	float a = t.r;
	if(UV.x > fadeBound){
		float disc = (UV.x - fadeBound);
		
		
		//a = clamp(mix(1.0, a, min(1.0, disc * decay)) -  disc * decay2, 0.0, 1.0);
		//a = 1.0;
		if(t.r > prog){
			a = 1.0;
		} else {
			a = 0.0;
		}
		
		if(UV.x > fadeBound2){
			float disc2 = UV.x - fadeBound2;
			//a = clamp(a - disc2 * decay3, 0.0, 1.0);
			if(t.r < disc2 * decay3){
				a = 0.0;
			}
		} else {
			//a = 1.0;
		}
	} else {
		a = 1.0;
	}
	vec4 tt = texture(albedo_tex, UV);
	ALBEDO = tt.rgb * color_mult * a * modulate;
	EMISSION = tt.rgb * a * emit * modulate;
	ALPHA = max(0, a - prog / 2.0) * tt.a;
}