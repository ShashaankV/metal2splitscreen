//
//  Shaders.metal
//  metal2splitscreen3
//
//  Created by svattiku on 12/1/18.
//  Copyright © 2018 svattiku. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

//add structures to partition vertex data so that positional transformations can be made on the gpu

//not sure how it knows order...assume by precedence

struct VertexIn{
    packed_float3 position;
    packed_float4 color;
    packed_float2 texCoord;
};

struct VertexOut{
    //note position out has four elements, one (scale parameter) will be added in the shader in case of 3D transformations
    float4 position [[position]];
    float4 color;
    float2 texCoord;
};


vertex VertexOut advanced_vertex(
                              const device VertexIn* vertex_array [[ buffer(0) ]],
                              unsigned int vid [[ vertex_id ]]) {
    
    
    VertexIn VertexIn = vertex_array[vid];
    
    VertexOut VertexOut;
    VertexOut.position = float4(VertexIn.position,1);
    VertexOut.color = VertexIn.color;
    
    VertexOut.texCoord = VertexIn.texCoord;
    
    return VertexOut;
}

// sets all pixels to max luminance
fragment half4 basic_fragment() { //
    return half4(1.0);
    
}

fragment half4 colored_fragment(VertexOut interpolated [[stage_in]]) {  //1
    return half4(interpolated.color[0], interpolated.color[1], interpolated.color[2], interpolated.color[3]); //2
}

fragment float4 textured_fragment(VertexOut interpolated [[stage_in]],
                               texture2d<float>  tex2D     [[ texture(0) ]],
                               sampler           sampler2D [[ sampler(0) ]]) {
    float4 color = tex2D.sample(sampler2D, interpolated.texCoord);
    return color;
}


