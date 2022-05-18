#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(push_constant) uniform Push
{
    mat4 projView;
    mat4 model;
} push;

layout(location = 0) in vec3 inPosition;
layout(location = 1) in vec3 inNormal;
layout(location = 2) in vec2 inTexCoord;

// does this work?
/*in Vertex
{
    vec3 inPosition;
    vec3 inColor;
    vec2 inTexCoord;
    vec2 inNormal;
} vertIn;
*/

layout(location = 0) out vec2 fragTexCoord;
layout(location = 1) out float lightIntensity;

// const vec3 DIRECTION_TO_LIGHT = normalize(vec3(1.0, 1.0, 1.0));
const vec3 DIRECTION_TO_LIGHT = normalize(vec3(1.0, 0.5, 1.5));

void main()
{
	gl_Position = push.projView * push.model * vec4(inPosition, 1.0);

	vec3 normalWorldSpace = normalize(mat3(push.model) * inNormal);

	lightIntensity = max(dot(normalWorldSpace, DIRECTION_TO_LIGHT), 0.15);

	fragTexCoord = inTexCoord;
}

