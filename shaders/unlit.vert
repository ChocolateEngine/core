#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(push_constant) uniform Push{
    mat4 trans;
    int  index;
} push;

layout(location = 0) in vec3 inPosition;
layout(location = 1) in vec2 inTexCoord;

layout(location = 1) out vec2 fragTexCoord;
layout(location = 2) out int  index;

void main() {
	gl_Position = push.trans * vec4(inPosition, 1.0);

	index = push.index;
	fragTexCoord = inTexCoord;
}

