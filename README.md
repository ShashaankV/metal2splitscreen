# Split screen for iOS using Metal 2 (and Swift)

Basic Swift app using Metal 2 for producing an iOS split screen by using <b>two viewports</b>. Metal is Apple's replacement for OpenGL. This code produces two viewports for rendering two halves of the screen.

## Why post the repo?
For my purposes this will be used as the base code for an iphone VR app. I made the repo since I don't think there are examples for doing this in Swift. Also, the last Apple conference focused only on the case where the final display is a specialized VR device such as Vive, etc. Cardboard SDK does not seem to have kept up with Metal or Swift, iOS. HelloMetal tutorials were useful for basic coding in Metal but do not focus on multiple viewports.<br>

Why two viewports rather than split the screen into two rects, etc.? Viewport makes it easy to use Metal/OpenGL (graphics card) built-in 3D transformation such as different camera positions.

## iOS projects
**metal2swift1
** metal2swift1 - basic code, example image flipped triangles (fill the half-screens)
** metal2swift2 -
