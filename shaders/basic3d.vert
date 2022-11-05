#version 450
#extension GL_ARB_separate_shader_objects : enable
#extension GL_EXT_nonuniform_qualifier : enable

layout(push_constant) uniform Push
{
	mat4 model;
    int material;
	int aViewInfo;

	bool dbgShowDiffuse;
} push;

// view info
layout(set = 1, binding = 0) uniform UBO_ViewInfo
{
	mat4 aProjView;
	mat4 aProjection;
	mat4 aView;
	vec3 aViewPos;
} gViewInfo[];

// Material Info
layout(set = 7, binding = 0) uniform UBO_Material
{
    int diffuse;
    int ao;
    int emissive;

    float aoPower;
    float emissivePower;
} materials[];

layout(location = 0) in vec3 inPosition;
layout(location = 1) in vec3 inNormal;
layout(location = 2) in vec2 inTexCoord;
// layout(location = 3) in vec3 inMorphPos;

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
layout(location = 1) out vec3 outPosition;
layout(location = 2) out vec3 outNormal;
layout(location = 3) out vec3 outNormalWorld;
layout(location = 4) out vec3 outTangent;
// layout(location = 3) out float lightIntensity;

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

	// newPos += (ubo.morphWeight * inMorphPos);

	gl_Position = gViewInfo[push.aViewInfo].aProjView * push.model * vec4(newPos, 1.0);
	// gl_Position = projView[push.projView].projView * vec4(newPos, 1.0);

	outPosition = (push.model * vec4(newPos, 1.0)).rgb;

	vec3 normalWorldSpace = normalize(mat3(push.model) * inNormal);
	outNormal = inNormal;
	outNormalWorld = normalWorldSpace;

	// lightIntensity = max(dot(normalWorldSpace, DIRECTION_TO_LIGHT), 0.15);

	fragTexCoord = inTexCoord;

    vec3 c1 = cross( inNormal, vec3(0.0, 0.0, 1.0) );
    vec3 c2 = cross( inNormal, vec3(0.0, 1.0, 0.0) );

    if (length(c1) > length(c2))
    {
        outTangent = c1;
    }
    else
    {
        outTangent = c2;
    }

    outTangent = normalize(outTangent);
}

