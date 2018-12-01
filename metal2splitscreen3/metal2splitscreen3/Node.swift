//
//  Node.swift
//  metal2splitscreen3
//
//  Created by svattiku on 12/1/18.
//  Copyright © 2018 svattiku. All rights reserved.
//

import Foundation
import Metal

class Node {
    let device: MTLDevice
    let name: String
    var vertexBuffer: MTLBuffer
    init(name: String, vertices: Array<Vertex>, device: MTLDevice){
        self.name = name
        self.device = device
        // initialize vertex buffer
        var vertexData = Array<Float>()
        for vertex in vertices{
            vertexData += vertex.floatBuffer()
        }
        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0])
        vertexBuffer = device.makeBuffer(bytes: vertexData, length: dataSize, options: [])!
    }
}
