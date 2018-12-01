//
//  Quad.swift
//  metal2splitscreen3
//
//  Created by svattiku on 12/1/18.
//  Copyright © 2018 svattiku. All rights reserved.
//


import Foundation
import Metal

class Quad: Node {
    
    init(device: MTLDevice){
        
        let Lhalf:Float = 1.0/10
        let A = Vertex(x: -Lhalf, y:   Lhalf, z:   0.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0, s: 0.0, t: 0)
        let B = Vertex(x: -Lhalf, y:  -Lhalf, z:   0.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0, s: 0.0, t: 1.0)
        let C = Vertex(x:  Lhalf, y:  -Lhalf, z:   0.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0, s: 1.0, t: 1.0)
        let D = Vertex(x:  Lhalf, y:   Lhalf, z:   0.0, r:  0.1, g:  0.6, b:  0.4, a:  1.0, s: 1.0, t: 0.0)
        
        
        let verticesArray:Array<Vertex> = [
            A,B,C ,A,C,D,   //quad := two triangles
        ]
        
        super.init(name: "Quad", vertices: verticesArray, device: device)
    }
    
}

