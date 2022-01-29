#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(push_constant) uniform Push{
    mat4 projview;
    mat4 model;
} push;

layout(location = 0) in vec3 inPosition;
layout(location = 1) in vec3 inColor;
layout(location = 2) in vec2 inTexCoord;
layout(location = 3) in vec3 inNormal;

layout(location = 0) out vec3 fragColor;
layout(location = 1) out vec2 fragTexCoord;

void main() {
	// gl_Position = ubo.proj * ubo.view * ubo.model * vec4(inPosition, 1.0);
	gl_Position = push.projview * push.model * vec4(inPosition, 1.0);
	
	vec3 normalWorldSpace = normalize(mat3(push.model) * inNormal);

	fragColor = inColor;
	fragTexCoord = inTexCoord;
}

