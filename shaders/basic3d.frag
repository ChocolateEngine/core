#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 1, binding = 0) uniform sampler2D texSampler;
layout(set = 2, binding = 0) uniform sampler2D texEmissive;
layout(set = 3, binding = 0) uniform sampler2D texAO;

layout(location = 0) in vec3 fragColor;
layout(location = 1) in vec2 fragTexCoord;
layout(location = 2) in float lightIntensity;

layout(location = 0) out vec4 outColor;

void main() {
    outColor = vec4(lightIntensity * vec3(texture(texSampler, fragTexCoord)), 1);
	
	// add ambient occlusion (only one channel is needed here, so just use red)
	// TEMP HACK: half the strength of the ao for now
	outColor *= texture(texAO, fragTexCoord).r;
	
	// add emission
	outColor += texture(texEmissive, fragTexCoord);
}

