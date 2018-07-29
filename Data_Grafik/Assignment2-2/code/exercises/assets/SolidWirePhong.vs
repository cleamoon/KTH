#version 330 core

layout(std140) uniform ub_Camera
{
  mat4 P;
  mat4 V;
  vec3 worldEye;
} Camera;

layout(std140) uniform ub_Geometry
{
  mat4 M;
  mat4 NM;
  float shininess;
  float lineWidth;
  vec4 color;
  vec4 lineColor;
  vec4 lightPositions[3];
} Geometry;

layout(location = 0) in vec3 position;
layout(location = 1) in vec3 normal;

out vec4 vPosition;
out vec3 vWorldPosition;
out vec3 vNormal;

void main(void)
{
  // transform the object coordinates to projected space
  // by multiplying with model-view-projection matrix
  vPosition = Camera.P*Camera.V *Geometry.M * vec4(position,1);
  
  // keep the world position of a vertex for fragment-wise lighting computation
  vWorldPosition = (Geometry.M*vec4(position,1)).xyz;
  
  // compute world-space normal matrix by transforming with normal matrix
  // where NM= Transpose(Inverse(ModelMatrix))
  vNormal   = (Geometry.NM*vec4(normal,1)).xyz;
}