//
//  ViewController.swift
//  metal2splitscreen2
//
//  Created by svattiku on 11/30/18.
//  Copyright © 2018 svattiku. All rights reserved.
//


import UIKit
import Metal

class ViewController: UIViewController {

    //Declare necessary variables
    var device: MTLDevice!
    var metalLayer: CAMetalLayer!
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var q1 : Quad!
    var tri_up : Triangle_up!
    var tri_down : Triangle_down!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //boiler plate code for rendering in Metal
        device = MTLCreateSystemDefaultDevice()
        
        metalLayer = CAMetalLayer()          // 1
        metalLayer.device = device           // 2
        metalLayer.pixelFormat = .bgra8Unorm // 3
        metalLayer.framebufferOnly = true    // 4
        metalLayer.frame = view.layer.frame  // 5
        view.layer.addSublayer(metalLayer)   // 6
        
        tri_up = Triangle_up(device: device)
        tri_down = Triangle_down(device: device)
        q1 = Quad(device: device)

        // 1, setup shaders (defined in Shaders.metal, Swift does not need a path for functions in other files)
        let defaultLibrary = device.makeDefaultLibrary()!
        let fragmentProgram = defaultLibrary.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary.makeFunction(name: "basic_vertex")
        
        // 2, setup pipeline
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        // 3, render
        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        
        
        
        commandQueue = device.makeCommandQueue()
        self.render()
    }
    
    func render() {
        guard let drawable = metalLayer?.nextDrawable() else { return }
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 104.0/255.0, blue: 5.0/255.0, alpha: 1.0)
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        let screenSize: CGRect = UIScreen.main.bounds
        let w:Float = Float(screenSize.width)
        let h:Float = Float(screenSize.height)
        
        let viewL = MTLViewport(originX: Double(0*w/2), originY: 0, width: Double(w/2), height: Double(h), znear: 0.1, zfar:100)
        let viewR = MTLViewport(originX: Double(w/2), originY: 0, width: Double(w/2), height: Double(h), znear: 0.1, zfar:100)
        
        //    let t0 = NSDate()
        renderEncoder?.setViewport(viewL)
        renderEncoder?.setRenderPipelineState(pipelineState)
        renderEncoder?.setVertexBuffer(q1.vertexBuffer, offset: 0, index: 0)
        renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6, instanceCount: 1)
        //    let t1 = t0.timeIntervalSinceNow
        
        
        
        renderEncoder?.setViewport(viewR)
        renderEncoder?.setRenderPipelineState(pipelineState)
        renderEncoder?.setVertexBuffer(tri_down.vertexBuffer, offset: 0, index: 0)
        renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
        
        
        renderEncoder?.endEncoding()
        //    let t2 = t0.timeIntervalSinceNow
        //    print(t1)
        //    print(2*t1)
        //    print(t2)
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
        
    }
    
    
    
}

