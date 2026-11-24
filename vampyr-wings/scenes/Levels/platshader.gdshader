shader_type canvas_item;
render_mode unshaded, blend_mix;

// Read darkness + scene below
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// Parameters
uniform bool show_glow = false;
uniform float glow_strength : hint_range(0.0, 1.0) = 0.0;
uniform vec4 glow_color : source_color = vec4(0.2, 0.5, 1.0, 1.0);
uniform float darkness_threshold : hint_range(0.0, 1.0) = 0.4;

void fragment() {
    // Tile default: invisible
    vec4 final_color = vec4(0.0);

    if (show_glow) {
        // How bright the scene is underneath (includes CanvasModulate darkness)
        float brightness = texture(SCREEN_TEXTURE, SCREEN_UV).r;

        // Only glow in darker areas
        float mask = smoothstep(darkness_threshold, 0.0, brightness);

        float alpha = glow_strength * mask;

        // Glow color
        final_color = vec4(glow_color.rgb, glow_color.a * alpha);
    }

    COLOR = final_color;
}
