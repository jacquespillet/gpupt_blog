#pragma once
#include <vector>
#include <GL/glew.h>
namespace gpupt
{

class textureArrayGL {
public:
    textureArrayGL();
    ~textureArrayGL();
    void CreateTextureArray(int width, int height, int layers);
    void LoadTextureLayer(int layerIndex, const std::vector<uint8_t>& imageData, int width, int height);
    void Bind(int textureUnit = 0);
    void Unbind() const;

    GLuint TextureID;
};    
}