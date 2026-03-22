#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float fizzleAmount;
    float time;
};

layout(binding = 1) uniform sampler2D source;

float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

// 1. Create a jittering horizontal offset
void main() {
	highp vec2 uv = qt_TexCoord0;
    // This creates the "torn" look seen in the anime's transitions
    highp float jitter = (random(vec2(floor(uv.y * 100.0), time)) - 0.5) * fizzleAmount;

    // 2. Sample the texture with the jitter
    highp vec4 tex = texture(source, uv + vec2(jitter, 0.0));

    // 3. Add the "Lain" Static (from our previous step)
    highp float n = random(uv + floor(time * 12.0));

    // 4. Create the CRT Scanlines
    // This creates a dark line every few pixels vertically
    highp float scanline = sin(uv.y * 100.0 + time * 5.5) * 0.05;

    // Combine everything
    highp vec3 finalColor = tex.rgb + (n * 0.15); // Add a little static
    finalColor -= scanline; // Subtract the scanline darkness

    // Make the colors slightly "blown out" like a bright CRT
    fragColor = vec4(finalColor, tex.a) * qt_Opacity;
}

// void main() {
//  	float t2 = time / 1000;
// 	vec2 uv = qt_TexCoord0;
//
//     // 1. Timing Parameters
//     float duration = 1.5; // Total length of the animation
//     float t = clamp(t2 / duration, 0.0, 1.0);
//
//     // 2. The "Opening" Logic
//     // We use a smoothstep to define the vertical bounds of the "streak"
//     // As t increases, the bounds move from the center (0.5) to the edges (0.0 and 1.0)
//     float streakWidth = 0.02; // How thick the initial line is
//     float expansion = smoothstep(0.1, 1.0, t); // Delay expansion slightly
//
//     float top = 0.5 + (0.5 * expansion) + (streakWidth * (1.0 - expansion));
//     float bottom = 0.5 - (0.5 * expansion) - (streakWidth * (1.0 - expansion));
//
//     // 3. Vignette / Masking
//     // Check if the current pixel is within the vertical bounds of the opening streak
//     float mask = step(bottom, uv.y) * step(uv.y, top);
//
//     // 4. The "Bright Edge" (The Streak)
//     // Add a glowing white line at the top and bottom edges of the expansion
//     float edgeGlow = 0.0;
//     edgeGlow += pow(1.0 - abs(uv.y - top), 50.0);
//     edgeGlow += pow(1.0 - abs(uv.y - bottom), 50.0);
//
//     // 5. Sampling and Final Color
//     vec4 color = texture(source, uv);
//
//     // Apply the mask to the image
//     vec3 finalRGB = color.rgb * mask;
//
//     // Add the white streak glow (boosted by the mask)
//     finalRGB += vec3(edgeGlow) * step(0.01, t) * (1.0 - expansion * 0.9);
//
//     // Optional: Add a quick flash at the very start
//     float flash = exp(-t * 10.0) * step(0.01, t);
//     finalRGB += vec3(flash);
//
//     fragColor = vec4(finalRGB, 1.0) * qt_Opacity;
// }
