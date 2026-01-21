shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;
uniform sampler2D gradient : source_color;
uniform float alpha_mod = 1.0;
uniform float glow = 0.0;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;

uniform float emit = 5;

void vertex() {
	UV = UV * uv1_scale.xy + uv1_offset.xy;
}
void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo, base_uv);
	float l = albedo_tex.r;
	vec4 gr = texture(gradient, vec2(l, 0));
	ALBEDO = gr.rgb * clamp(1.0 - glow, 0, 1.0) + glow * ((gr.r + gr.g + gr.b) / 3.0) * vec3(1, 1, 1);
	float br = gr.r;
	EMISSION = gr.rgb;
	EMISSION *= emit;
	ALPHA = gr.a * alpha_mod;
}
