//
//  ViewController.swift
//  metal2splitscreen3
//
//  Created by svattiku on 12/1/18.
//  Copyright © 2018 svattiku. All rights reserved.
//

import UIKit
import Metal
import MetalKit

func buildSamplerState(device: MTLDevice) -> MTLSamplerState {
    let samplerDescriptor = MTLSamplerDescriptor()
    samplerDescriptor.normalizedCoordinates = true
    samplerDescriptor.minFilter = .linear
    samplerDescriptor.magFilter = .linear
    samplerDescriptor.mipFilter = .linear
    return device.makeSamplerState(descriptor: samplerDescriptor)!
}

class ViewController: UIViewController {
    
    //Declare necessary variables
    var device: MTLDevice!
    var metalLayer: CAMetalLayer!
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var q1 : Quad!
    var texture1: MTLTexture!
    var texture2: MTLTexture!
    var samplerState: MTLSamplerState?
    
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
        
        q1 = Quad(device: device)
        
        // 1, setup shaders (defined in Shaders.metal, Swift does not need a path for functions in other files)
        let defaultLibrary = device.makeDefaultLibrary()!
        let vertexProgram = defaultLibrary.makeFunction(name: "advanced_vertex")
        let fragmentProgram = defaultLibrary.makeFunction(name: "textured_fragment")

        
        // 2, setup pipeline
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        // 3, render
        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        
       
        commandQueue = device.makeCommandQueue()
        
        // //initialize texture and sampler
//        let texture = MetalTexture(resourceName: "cube", ext: "png", mipmaped: true)
//        texture.loadTexture(device: device, commandQ: commandQueue, flip: true)
        
        
        
//        samplerState = defaultSampler(device: device)
        
        samplerState = buildSamplerState(device: device)
        
        let textureLoader = MTKTextureLoader(device: device)
        let options: [MTKTextureLoader.Option : Any] = [.generateMipmaps : true, .SRGB : true]
        texture1 = try? textureLoader.newTexture(name: "g45", scaleFactor: 1.0, bundle: nil, options: options)
        texture2 = try? textureLoader.newTexture(name: "g135", scaleFactor: 1.0, bundle: nil, options: options)
        self.render()
    }
    
    func render() {
        guard let drawable = metalLayer?.nextDrawable() else { return }
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        renderEncoder?.setFragmentSamplerState(samplerState, index: 0)
        
        
        let screenSize: CGRect = UIScreen.main.bounds
        let w:Float = Float(screenSize.width)
        let h:Float = Float(screenSize.height)
        
//        print(w)
//        print(h)
        let w2=w/2
        let hw=w2/h
        let viewL = MTLViewport(originX: Double(0*w/2), originY: 0, width: Double(w/2), height: Double(hw*h), znear: 0.1, zfar:100)
        let viewR = MTLViewport(originX: Double(w/2), originY: 0, width: Double(w/2), height: Double(hw*h), znear: 0.1, zfar:100)
        
        // draw left image
        
        renderEncoder?.setFragmentTexture(texture1, index: 0)
        renderEncoder?.setViewport(viewL)
        renderEncoder?.setRenderPipelineState(pipelineState)
        renderEncoder?.setVertexBuffer(q1.vertexBuffer, offset: 0, index: 0)
        renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6, instanceCount: 1)
        
        
        // draw right image
        
        renderEncoder?.setFragmentTexture(texture2, index: 0)
        renderEncoder?.setViewport(viewR)
        renderEncoder?.setRenderPipelineState(pipelineState)
        renderEncoder?.setVertexBuffer(q1.vertexBuffer, offset: 0, index: 0)
        renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6, instanceCount: 1)
        
        renderEncoder?.endEncoding()
        
        //display
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
        
    }
    
    
    
}

