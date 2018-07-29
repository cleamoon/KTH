#version 330 core

layout(triangles) in;
layout(triangle_strip, max_vertices = 3) out;

in vec4 vPosition[3];
in vec3 vWorldPosition[3];
in vec3 vNormal[3];

noperspective out vec3 gBary;
out vec3 gWorldPosition;
out vec3 gNormal;

void main()
{
  //emit a single triangle
 
  gl_Position = vPosition[0]; 
  gBary = vec3(1,0,0);
  gWorldPosition = vWorldPosition[0];
  gNormal     = vNormal[0];
  EmitVertex();

  gl_Position = vPosition[1];
  gBary = vec3(0,1,0);
  gWorldPosition = vWorldPosition[1];
  gNormal     = vNormal[1];
  EmitVertex();

  gl_Position = vPosition[2];
  gBary = vec3(0,0,1);
  gWorldPosition = vWorldPosition[2];
  gNormal     = vNormal[2];
  EmitVertex();
  EndPrimitive();
}
 