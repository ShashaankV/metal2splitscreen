//
//  ViewController.swift
//  metal2splitscreen1
//
//  Created by svattiku on 11/30/18.
//  Copyright © 2018 svattiku. All rights reserved.
//  formatted for landscape L only

import UIKit
import Metal

class ViewController: UIViewController {
    //Define some test data, two different images for each view
    //up triangle
    let vertexData1:[Float] = [
        0.0, 1.0, 0.0,
        -1.0, -1.0, 0.0,
        1.0, -1.0, 0.0]
    //down triangle
    let vertexData2:[Float] = [
        0.0, -1.0, 0.0,
        -1.0, 1.0, 0.0,
        1.0, 1.0, 0.0]
    //Declare necessary variables
    var device: MTLDevice!
    var metalLayer: CAMetalLayer!
    //two data buffers for two viewports, otherwise overwrite during rendering
    var vertexBuffer1: MTLBuffer!
    var vertexBuffer2: MTLBuffer!
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!


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
        
        //make Metal format data (buffers)
        let dataSize1 = vertexData1.count * MemoryLayout.size(ofValue: vertexData1[0]) // 1
        vertexBuffer1 = device.makeBuffer(bytes: vertexData1, length: dataSize1, options: []) // 2
        
        let dataSize2 = vertexData2.count * MemoryLayout.size(ofValue: vertexData2[0]) // 1
        vertexBuffer2 = device.makeBuffer(bytes: vertexData2, length: dataSize2, options: []) // 2
        
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
        renderEncoder?.setVertexBuffer(vertexBuffer1, offset: 0, index: 0)
        renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
        //    let t1 = t0.timeIntervalSinceNow
        
        
        
        renderEncoder?.setViewport(viewR)
        renderEncoder?.setRenderPipelineState(pipelineState)
        renderEncoder?.setVertexBuffer(vertexBuffer2, offset: 0, index: 0)
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

