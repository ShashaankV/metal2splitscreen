# Split screen for iOS using Metal 2 (and Swift)

Basic Swift app using Metal 2 for producing an iOS split screen by using <b>two viewports</b>. Metal is Apple's replacement for OpenGL. This code produces two viewports for rendering two halves of the screen.

## Why post the repo?
Base code for an iphone VR (stereopsis) app. Not enough examples for splitscreen, dual viewports using Metal and Swift. Code is derived from <url>https://www.raywenderlich.com/u/haawa</url> (HelloMetal examples) and <url>http://metalbyexample.com</url> (Metal by example). My code is focused on dual viewports and cameras.
<br>

Why two viewports rather than split the screen into two rects, etc.? Viewport makes it easy to use Metal/OpenGL (graphics card) built-in 3D transformation such as different camera positions (needed for stereopsis).

## iOS projects
<i>Metal 2 does not work on simulator. To test results, you need to test on a phone (known universal xcode-metal issue).</i>
* metal2swift1 - basic code, example image (simple geometric shapes): flipped triangles (fill respective half-screens)
* metal2swift2 [in process] - 1+ generic image on quad
