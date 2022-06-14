#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(push_constant) uniform Push
{
    mat4 projView;
    mat4 model;
} push;

layout(set = 0, binding = 0) uniform UniformBufferObject
{
	// texture settings
    int diffuse;
    int ao;
    int emissive;

    float aoPower;
    float emissivePower;
	
	// morphs
	// int morphCount;
	float morphWeight;
} ubo;

layout(location = 0) in vec3 inPosition;
layout(location = 1) in vec3 inNormal;
layout(location = 2) in vec2 inTexCoord;
layout(location = 3) in vec3 inMorphPos;

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
	// TODO: for morph targets:
	// https://developer.nvidia.com/gpugems/gpugems/part-i-natural-effects/chapter-4-animation-dawn-demo
	// float4 position = (1.0f - interp) * vertexIn.prevPositionKey + interp * vertexIn.nextPositionKey;
	
	// // vertexIn.positionDiffN = position morph target N - neutralPosition
	// float4 position = neutralPosition;
	// position += weight0 * vertexIn.positionDiff0;
	// position += weight1 * vertexIn.positionDiff1;
	// position += weight2 * vertexIn.positionDiff2;
	// etc.
	
	// or, for each blend shape
	// for ( int i = 0; i < ubo.morphCount; i++ )

	vec3 newPos = vec3(inPosition.xyz);

	newPos += (ubo.morphWeight * inMorphPos);

	gl_Position = push.projView * push.model * vec4(newPos, 1.0);

	// if ( ubo.morphWeight > 0.5 )
	// 	gl_Position = push.projView * push.model * vec4(inMorphPos, 1.0);
	// else
	// 	gl_Position = push.projView * push.model * vec4(inPosition, 1.0);

	vec3 normalWorldSpace = normalize(mat3(push.model) * inNormal);

	lightIntensity = max(dot(normalWorldSpace, DIRECTION_TO_LIGHT), 0.15);

	fragTexCoord = inTexCoord;
}

