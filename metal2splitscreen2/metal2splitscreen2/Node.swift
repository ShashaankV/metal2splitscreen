//
//  Node.swift
//  metal2splitscreen2
//
//  Created by svattiku on 11/30/18.
//  Copyright © 2018 svattiku. All rights reserved.
//

import Foundation
import QuartzCore
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
