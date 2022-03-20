#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(push_constant) uniform Push{
    mat4 trans;
    int  sky;
} push;

layout(location = 0) in vec3 inPosition;
layout(location = 0) out vec3 fragTexCoord;

void main()
{
    fragTexCoord = inPosition;
    gl_Position = push.trans * vec4(inPosition, 1.0);
}

