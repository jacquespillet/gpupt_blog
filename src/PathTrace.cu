#pragma once
#include "BVH.h"
#include <glm/glm.hpp>
using namespace glm;
using namespace gpupt;

#define PI_F 3.141592653589


#define MATERIAL_TYPE_MATTE 0
#define MATERIAL_TYPE_PBR   1

__device__ u32 Width;
__device__ u32 Height;
__device__ triangle *TriangleBuffer;
__device__ triangleExtraData *TriangleExBuffer;
__device__ bvhNode *BVHBuffer;
__device__ u32 *IndicesBuffer;
__device__ indexData *IndexDataBuffer;
__device__ bvhInstance *TLASInstancesBuffer;
__device__ tlasNode *TLASNodes;
__device__ camera *Cameras;
__device__ tracingParameters *Parameters;
__device__ material *Materials;

#define MAIN() \
__global__ void TraceKernel(glm::vec4 *RenderImage, int _Width, int _Height, \
                            triangle *_AllTriangles, triangleExtraData *_AllTrianglesEx, bvhNode *_AllBVHNodes, u32 *_AllTriangleIndices, indexData *_IndexData, bvhInstance *_Instances, tlasNode *_TLASNodes,\
                            camera *_Cameras, tracingParameters* _TracingParams, material *_Materials)

#define INIT() \
    Width = _Width; \
    Height = _Height; \
    TriangleBuffer = _AllTriangles; \
    TriangleExBuffer = _AllTrianglesEx; \
    BVHBuffer = _AllBVHNodes; \
    IndicesBuffer = _AllTriangleIndices; \
    IndexDataBuffer = _IndexData; \
    TLASInstancesBuffer = _Instances; \
    TLASNodes = _TLASNodes; \
    Cameras = _Cameras; \
    Parameters = _TracingParams; \
    Materials = _Materials; \


#define IMAGE_SIZE(Img) \
    ivec2(Width, Height)

#define GLOBAL_ID() \
    uvec2(blockIdx.x * blockDim.x + threadIdx.x, blockIdx.y * blockDim.y + threadIdx.y)

#define FN_DECL __device__

#define INOUT(Type) Type &

#define GET_ATTR(Obj, Attr) \
    Obj->Attr


__device__ void imageStore(vec4 *Image, ivec2 p, vec4 Colour)
{
    Image[p.y * Width + p.x] = Colour;
}

__device__ vec4 imageLoad(vec4 *Image, ivec2 p)
{
    return Image[p.y * Width + p.x];
}

 
#include "../../resources/PathTraceCode.cpp"


__device__ float ToSRGB(float Col) {
  return (Col <= 0.0031308f) ? 12.92f * Col
                             : (1 + 0.055f) * pow(Col, 1 / 2.4f) - 0.055f;
}

__device__ glm::vec3 ToSRGB(glm::vec3 Col)
{
    return glm::vec3(
        ToSRGB(Col.x),
        ToSRGB(Col.y),
        ToSRGB(Col.z)
    );
}

__global__ void TonemapKernel(glm::vec4 *Input,glm::vec4 *Output, int Width, int Height)
{
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;
    if (x < Width && y < Height) {    
        int index = y * Width + x;

        glm::vec3 Col = ToSRGB(Input[y * Width + x]);
        Output[y * Width + x] = vec4(Col, 1);    
    }
}