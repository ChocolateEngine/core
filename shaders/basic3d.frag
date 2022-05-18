#version 450
#extension GL_ARB_separate_shader_objects : enable
#extension GL_EXT_nonuniform_qualifier : enable

layout(set = 0, binding = 0) uniform UniformBufferObject
{
    int diffuse;
    int ao;
    int emissive;

    float aoPower;
    float emissivePower;
} ubo;

layout(set = 1, binding = 0) uniform sampler2D[] texSamplers;

layout(location = 0) in vec2 fragTexCoord;
layout(location = 1) in float lightIntensity;

layout(location = 0) out vec4 outColor;

#define texDiffuse  texSamplers[ubo.diffuse]
#define texAO       texSamplers[ubo.ao]
#define texEmissive texSamplers[ubo.emissive]

void main()
{
    outColor = vec4(lightIntensity * vec3(texture(texDiffuse, fragTexCoord)), 1);
	
	// add ambient occlusion (only one channel is needed here, so just use red)
	outColor.rgb *= mix(1, texture(texAO, fragTexCoord).r, ubo.aoPower);

	// add emission
	outColor.rgb += mix(vec3(1, 1, 1), texture(texEmissive, fragTexCoord).rgb, ubo.emissivePower);
}

// look at this later for cubemaps:
// https://forum.processing.org/two/discussion/27871/use-samplercube-and-sampler2d-in-a-single-glsl-shader.html

