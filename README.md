# Split screen for iOS using Metal 2 (and Swift)

Basic Swift app using Metal 2 for producing an iOS split screen by using <b>two viewports</b>. Metal is Apple's replacement for OpenGL. This code produces two viewports for rendering two halves of the screen.

## Why post the repo?
Base code for an iphone VR (stereopsis) app. Not enough examples for splitscreen, dual viewports using Metal and Swift. Code is derived from <url>https://www.raywenderlich.com/u/haawa</url> (HelloMetal examples) and <url>http://metalbyexample.com</url> (Metal by example). My code is focused on dual viewports and cameras.
<br>

Why two viewports rather than split the screen into two rects, etc.? Viewport makes it easy to use Metal/OpenGL (graphics card) built-in 3D transformation such as different camera positions (needed for stereopsis).

## iOS projects (Xcode 9.4)
<i>Metal does not work on simulator (by design). To test results, you need to test on a phone. Projects listed in order of development stage.</i>
* metal2swift1 - basic code (single main script), example image (simple geometric shapes): flipped triangles (fill respective half-screens)
* metal2swift2 - refactor:
  * geometric object class (file), quad, triangles (up and down)
  * Node class (name from metalbyexample <url>http://metalbyexample.com/modern-metal-2/#more-669</url>) - formats object for Metal; deviates from HelloMetal in that my Node class does not include rendering functions
* metal2swift3 - example of different textures for different viewports
  * add color and texture coordinates to object class
  * refactor:
    * shader - parses object position, color, and texture coordinates
  * add color and texture fragment shaders
