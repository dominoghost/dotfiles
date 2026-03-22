#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float time;
};

layout(binding = 1) uniform sampler2D source;

void main() {
	float t = time /1000;
    vec2 st = qt_TexCoord0;

    float pct = 0.0;

    // a. The DISTANCE from the pixel to the center
    pct = distance(st,vec2(1*sin(t))+1);

    // b. The LENGTH of the vector
    //    from the pixel to the center
    // vec2 toCenter = vec2(0.5)-st;
    // pct = length(toCenter);

    // c. The SQUARE ROOT of the vector
    //    from the pixel to the center
    // vec2 tC = vec2(0.5)-st;
    // pct = sqrt(tC.x*tC.x+tC.y*tC.y);

  //  pct = distance(st,vec2(0.4)) * distance(st,vec2(0.6));
    vec3 color = vec3(pct);
        fragColor = vec4(color, 1.0) * qt_Opacity;
}

