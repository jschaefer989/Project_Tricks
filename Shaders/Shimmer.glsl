uniform float shimmerPhase;
        
vec4 effect(vec4 color, Image tex, vec2 tc, vec2 pc) {
    vec4 pixel = Texel(tex, tc);
    
    // Skip shimmer effect if phase is negative (hidden state)
    if (shimmerPhase < 0.0) {
        return pixel * color;
    }
    
    // Create a diagonal streak based on shimmerPhase
    float streak = (tc.x + tc.y * 0.5 - shimmerPhase);
    streak = mod(streak + 1.0, 1.0);
    
    // Make a sharp line with smooth edges
    float lineWidth = 0.15;
    float brightness = smoothstep(0.0, lineWidth * 0.3, streak) * 
                    (1.0 - smoothstep(lineWidth * 0.7, lineWidth, streak));
    
    // Add brightness to the streak
    pixel.rgb += vec3(brightness * 0.6);
    
    return pixel * color;
}