uniform vec2 uResolution;
uniform float uTime;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec2 uv = screen_coords / uResolution;
    float time = uTime * 0.5;
    
    // Grass colors
    vec3 grassBase = vec3(0.15, 0.4, 0.15);
    vec3 grassMid = vec3(0.25, 0.55, 0.2);
    vec3 grassTip = vec3(0.35, 0.7, 0.25);
    
    // Create gentle wave motion (stronger at top)
    float heightFactor = pow(uv.y, 0.8);
    float sway = sin(uv.x * 8.0 + time) * 0.03 * heightFactor;
    sway += sin(uv.x * 12.0 - time * 0.7) * 0.02 * heightFactor;
    
    // Apply sway to x coordinate
    float swayedX = uv.x + sway;
    
    // Create vertical grass blade stripes
    float bladePattern = fract(swayedX * 60.0);
    float blade = smoothstep(0.4, 0.5, bladePattern) - smoothstep(0.5, 0.6, bladePattern);
    
    // Vertical color gradient (dark at bottom, light at top)
    vec3 grassColor = mix(grassBase, grassMid, uv.y);
    grassColor = mix(grassColor, grassTip, pow(uv.y, 2.0));
    
    // Add blade highlights
    grassColor += blade * 0.15;
    
    // Add subtle variation
    float variation = sin(swayedX * 30.0) * 0.5 + 0.5;
    grassColor *= 0.9 + variation * 0.2;
    
    return vec4(grassColor, 1.0);
}
