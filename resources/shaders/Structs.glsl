
struct ray
{
    vec3 Origin;
    vec3 Direction;
    vec3 InverseDirection;
};

struct triangle
{
    vec3 v0;
    float padding0;
    vec3 v1;
    float padding1;
    vec3 v2;
    float padding2; 
    vec3 Centroid;
    float padding3;     
};

struct triangleExtraData
{
    vec3 Normal0; 
    float padding0;
    vec3 Normal1; 
    float padding1;
    vec3 Normal2; 
    float padding2;
    
    vec2 UV0, UV1, UV2; 
    vec2 padding3;

    vec4 Colour0;
    vec4 Colour1;
    vec4 Colour2;

    vec4 Tangent0;
    vec4 Tangent1;
    vec4 Tangent2;
};
struct bvhNode
{
    vec3 AABBMin;
    float padding0;
    vec3 AABBMax;
    float padding1;
    uint LeftChildOrFirst;
    uint TriangleCount;
    uvec2 padding2;    
};

struct indexData
{
    uint triangleDataStartInx;
    uint IndicesDataStartInx;
    uint BVHNodeDataStartInx;
    uint TriangleCount;
};

struct aabb
{
    vec3 Min;
    float pad0;
    vec3 Max;
    float pad1;
};

struct bvhInstance
{
    mat4 InverseTransform;
    mat4 Transform;
    mat4 NormalTransform;
    aabb Bounds;

    uint MeshIndex;
    uint Index;
    uvec2 Pad;
};

struct tlasNode
{
    vec3 AABBMin;
    uint LeftRight;
    vec3 AABBMax;
    uint BLAS;
};

struct camera
{
    mat4 Frame;
    
    float Lens;
    float Film;
    float Aspect;
    float Focus;
    
    vec3 Padding0;
    float Aperture;
    
    int Orthographic;
    ivec3 Padding;
};

struct tracingParameters
{
    int CurrentSample;
    int TotalSamples;
    int Batch;
    int Pad;
};