#version 450

layout(push_constant) uniform Push {
    mat4 trans;
    vec3 a;
    vec3 b;
    vec3 color;
} push;

vec3 vertices[2] = vec3[](
	push.a,
	push.b
);

layout(location = 0) out vec3 fragColor;

void main() {
    gl_Position = push.trans * vec4(vertices[gl_VertexIndex], 1.0);
    fragColor   = push.color;
}