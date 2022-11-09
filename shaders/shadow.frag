#version 450
#extension GL_ARB_separate_shader_objects : enable
#extension GL_EXT_nonuniform_qualifier : enable

layout(push_constant) uniform Push
{
	mat4 aModel;
	int  aViewInfo;
	int  aAlbedo;
} push;

layout(set = 0, binding = 0) uniform sampler2D[] texSamplers;

// view info
layout(set = 1, binding = 0) uniform UBO_ViewInfo
{
	mat4 aProjView;
	mat4 aProjection;
	mat4 aView;
	vec3 aViewPos;
	float aNearZ;
	float aFarZ;
} gViewInfo[];

layout(location = 0) in vec2 inTexCoord;

void main()
{
	gl_FragDepth = gl_FragCoord.z;

	if ( push.aAlbedo >= 0 )
	{
		gl_FragDepth /= textureLod( texSamplers[ push.aAlbedo ], inTexCoord, 0 ).a;
	}
}
