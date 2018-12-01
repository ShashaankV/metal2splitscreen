//
//  Vertex.swift
//  metal2splitscreen2
//
//  Created by svattiku on 11/30/18.
//  Copyright © 2018 svattiku. All rights reserved.
//

struct Vertex{
    
    var x,y,z: Float     // position data
    var r,g,b,a: Float   // color data
    var s,t: Float       // texture coordinates
    
    func floatBuffer() -> [Float] {
        return [x,y,z,r,g,b,a,s,t]
    }
    
}
