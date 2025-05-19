shader_type canvas_item;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    COLOR = vec4(tex.r * 1.4, tex.g * 1.4, tex.b * 0.6, tex.a); // Full white while keeping alpha
}