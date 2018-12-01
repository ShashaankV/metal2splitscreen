//
//  Triangle.swift
//  metal2splitscreen2
//
//  Created by svattiku on 12/1/18.
//  Copyright © 2018 svattiku. All rights reserved.
//

import Foundation
import Metal

class Triangle_up: Node {
    
    init(device: MTLDevice){
        
        
        let A = Vertex(x: -1, y:   -1, z:   0.0)
        let B = Vertex(x: 0, y:  1, z:   0.0)
        let C = Vertex(x:  1, y:  -1, z:   0.0)

        
        let verticesArray:Array<Vertex> = [
            A,B,C  // one triangle
        ]
        
        super.init(name: "Triangle_up", vertices: verticesArray, device: device)
    }
    
}

class Triangle_down: Node {
    
    init(device: MTLDevice){
        
        
        let A = Vertex(x: -1, y:   1, z:   0.0)
        let B = Vertex(x: 0, y:  -1, z:   0.0)
        let C = Vertex(x:  1, y:  1, z:   0.0)
        
        
        let verticesArray:Array<Vertex> = [
            A,B,C  // one triangle
        ]
        
        super.init(name: "Triangle_down", vertices: verticesArray, device: device)
    }
    
}

