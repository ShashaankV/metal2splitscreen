//
//  Quad.swift
//  metal2splitscreen2
//
//  Created by svattiku on 11/30/18.
//  Copyright © 2018 svattiku. All rights reserved.
//

import Foundation
import Metal

class Quad: Node {
    
    init(device: MTLDevice){
        let Lhalf:Float = 1.0/2
        let A = Vertex(x: -Lhalf, y:   Lhalf, z:   0.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0)
        let B = Vertex(x: -Lhalf, y:  -Lhalf, z:   0.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0)
        let C = Vertex(x:  Lhalf, y:  -Lhalf, z:   0.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0)
        let D = Vertex(x:  Lhalf, y:   Lhalf, z:   0.0, r:  0.1, g:  0.6, b:  0.4, a:  1.0)
        
        
        let verticesArray:Array<Vertex> = [
            A,B,C ,A,C,D,   //Front
        ]
        
        super.init(name: "Quad", vertices: verticesArray, device: device)
    }
    
}

