#version 330 core

layout(location = 0) out vec4 color;

in vec4 v_color;
in vec2 v_texCoord;
in float v_texIndex;
in float v_tilingFactor;

uniform sampler2D u_textures[32];

void main()
{
	color = texture(u_textures[int(v_texIndex)], v_texCoord * v_tilingFactor) * v_color;
}