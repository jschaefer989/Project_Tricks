// LÖVE 2D shadow shader
// Darkens sprites based on their alpha channel to create a shadow effect

uniform float shadow_strength = 0.5;  // How dark the shadow is (0.0 to 1.0)
uniform vec3 shadow_color = vec3(0.0, 0.0, 0.0);  // Shadow color (default black)

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 screen_coords) {
    vec4 texel = Texel(tex, tc);
    
    // If the sprite is fully transparent, just return transparent
    if (texel.a == 0.0) {
        return vec4(0.0);
    }
    
    // Create shadow: darken the sprite based on alpha
    // The darker the shadow_strength, the more the shadow darkens
    vec3 darkened = texel.rgb * (1.0 - shadow_strength * texel.a);
    
    // Blend the darkened color with the shadow color
    vec3 shadowed = mix(darkened, shadow_color, shadow_strength * 0.5);
    
    return vec4(shadowed, texel.a) * color;
}

