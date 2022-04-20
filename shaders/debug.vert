#version 450

layout(push_constant) uniform Push{
    mat4 trans;
} push;

layout(location = 0) in vec3 inPosition;
layout(location = 1) in vec3 inColor;

layout(location = 0) out vec4 fragColor;

void main()
{
	gl_Position = push.trans * vec4(inPosition, 1.0);
    fragColor   = vec4(inColor, 1);
}

