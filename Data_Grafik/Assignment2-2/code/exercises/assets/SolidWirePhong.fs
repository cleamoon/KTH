#version 330 core
noperspective in vec3 gBary;

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

out vec4 fColor;

in vec3 gWorldPosition;
in vec3 gNormal;

#define M_PI 3.14159265358979323846

float getLineWeight(vec3 barycentric,float lineWidth)
{
	vec3 ddHeights2 = fwidth(barycentric)*fwidth(barycentric);
  vec3 pixHeights2 = barycentric *  barycentric / ddHeights2;
  float dist = sqrt( min ( min (pixHeights2.x, pixHeights2.y), pixHeights2.z) );
  return smoothstep(0,lineWidth,dist); 
}

vec3 brdf_phong(const vec3 V, const vec3 L, const vec3 N)
{
  float r_f0=0.04;
  /************************************************************************/
  /*steel ~0.55                                                           */
  /*aluminum ~0.95                                                        */
  /*water glass and plastic ~0.04                                         */
  /*diamond ~0.15                                                         */
  /*gold ~0.6 blue-channel and ~0.9 red-channel                           */
  /*copper ~0.4 blue-channel and ~0.85 red-channel                        */
  /************************************************************************/

  // reflect incident view vector at normal
  vec3 R = reflect(V,N);

  // get cosine of angle between light direction and reflected vector
  float cosLR = dot(L,R);
  // compute specular power
  float specPower = pow(max(cosLR, 0.f), Geometry.shininess);

  // assemble the normalized phong-brdf
  return Geometry.color.xyz / M_PI + (Geometry.shininess + 2.0f) / (2.0f * M_PI) * r_f0 * specPower;
}

void main()
{
  //initialize the output with zero
  fColor=vec4(0,0,0,1);
  
  //set a fixed light color
  vec3 lightSpectralIntensity=70*vec3(1,1,1);
  
  // get normal and incident view vector
  vec3 V = normalize(gWorldPosition-Camera.worldEye);
  vec3 N = normalize(gNormal);
  N = dot(N,-V) < 0 ? -N : N; //normal might now be back-facing
  
  for(int i=0;i<3;++i)
  {
    //get light direction
    vec3 L = (Geometry.lightPositions[i].xyz-gWorldPosition);
    
    // get squared light distance
    float distance2 = length(L);
    distance2*=distance2;
    
    //normalize light direction
    L = normalize(L);
    
    // get cosine of angle between light direction and normal
    float cosNL = dot(N,L);
    
    // clamp the cosine (positive when facing the light, otherwise 0)
    float cosNL_clamped = max(cosNL, 0);
    
    // compute radiance incoming from the light
    //(quadratic fall-off since receiver area decreases quadratically)
    vec3 incident_radiance = lightSpectralIntensity / distance2;   

    // reflective surfaces are only partially receiving flux
    //(i.e., the reflected flux is reflected away from the surface)
  
    // the flux arriving at the surface (called irradiance)
    // depends on its incoming angle
    vec3 irradiance = incident_radiance * cosNL_clamped;
  
    // compute, how much of the arriving irradiance is reflected 
    // toward the viewer (multiply by BRDF)
    vec3 outgoing_radiance = irradiance * brdf_phong(V, L, N);
  
    fColor.xyz +=outgoing_radiance; 
  }
  //clamp output to (0,1) interval
  fColor.xyz = clamp(fColor.xyz,0.f,1.f);
  
  // now mix the shaded result with constant wireframe color 
  float lineWeight = getLineWeight(gBary,Geometry.lineWidth);
  fColor.xyz = mix(Geometry.lineColor.xyz,fColor.xyz,lineWeight);
}