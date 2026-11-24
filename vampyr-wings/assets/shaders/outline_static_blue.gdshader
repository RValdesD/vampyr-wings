shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(0.3, 0.8, 1.0, 1.0);
uniform float border_thickness : hint_range(0.0, 0.2) = 0.05;
uniform float glow_strength : hint_range(0.0, 1.0) = 0.0;
uniform vec2 player_pos;             // in global coordinates
uniform float reveal_radius = 0.0;   // radius in pixels
uniform vec2 viewport_size;          // pass this from GDScript

void fragment() {
    // 1️⃣ Approximate tile edges
    vec2 edge_dist = min(UV, 1.0 - UV);
    float edge = step(edge_dist.x, border_thickness) + step(edge_dist.y, border_thickness);
    edge = clamp(edge, 0.0, 1.0);

    // 2️⃣ Convert current screen pixel to world space (approx)
    vec2 screen_pos = SCREEN_UV * viewport_size;

    // 3️⃣ Distance fade from player echo
    float dist = distance(screen_pos, player_pos);
    float fade = smoothstep(reveal_radius, reveal_radius * 0.5, dist); 
    float intensity = glow_strength * fade;

    if (edge > 0.0 && intensity > 0.01) {
        COLOR = vec4(outline_color.rgb, intensity);
    } else {
        discard;
    }
}
