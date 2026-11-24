shader_type canvas_item;

uniform vec4 outline_color = vec4(0.6, 0.0, 0.0, 1.0); // default green
uniform float outline_thickness = 1.5;
uniform float glow_strength = 1.0; // make sure alpha > 0

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    float outline = 0.0;

    // sample neighbors
    for (int x = -1; x <= 1; x++) {
        for (int y = -1; y <= 1; y++) {
            if (x == 0 && y == 0) continue;
            vec2 offset = vec2(float(x), float(y)) * outline_thickness * TEXTURE_PIXEL_SIZE;
            outline += texture(TEXTURE, UV + offset).a;
        }
    }

    if (outline > 0.0 && tex.a < 0.1) {
        COLOR = vec4(outline_color.rgb, outline_color.a * glow_strength);
    } else if (tex.a > 0.1) {
        COLOR = vec4(tex.rgb, 0.0); // keep main sprite invisible under darkness
    } else {
        discard;
    }
}
