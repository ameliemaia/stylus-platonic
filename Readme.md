# Stylus Platonic

Experimental pure CSS3D library.


## About

Built on top of Stylus, Platonic is a experimental CSS3D library for creating pure CSS3D content through CSS and HTML. 

It's primary objectives are:

1. To provide an alternative 3D library for platforms that don't support WebGL.
2. To provide a simple API and set of styles for setting up a 3D viewport.
3. To generate the least amount of CSS required to display content.

This library should be used at the users own risk as the current [browser support](#browser-support) is very limited!

[Installation](#installation) - [Features](#features) - [Examples](#examples) - [Getting started](#usage)


## Browser support

Platonic is currently supported in *some* webkit based browsers due to some CSS3 properties it requires for generating the geometry.

* Chrome v27.0
* Safari v6.0
* Safari iOS v6.0

## Installation

```
npm install stylus-platonic
``` 


## Features

* Viewport styles
* Geometry
 * Quad
 * Triangle
 * Plane
 * Cube
 * Pyramid
 * Tetrahedron
 * Octahedron
 * Particle
* Optimised CSS output
* Extras
 * Menger Sponge mixin
* Photon.js for lighting

## Examples

Demo 1 - ...

Demo 2 - 400 cubes (  )


## FAQ

Q: Why should you use Platonic over other 3D libraries?

A: Current existing 3D libraries are built on WebGL. Platonic offers a WebGL-independent solution for generating 3D content.

Q: When will more browsers be supported?

A: As soon as the browser vendors implement the technology required to display the 3D content.


## Contributing

Join the Google Group...


## License

(MIT)

Copyright (c) 2013 David Paul Rosser, https://github.com/davidpaulrosser/stylus-platonic

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.