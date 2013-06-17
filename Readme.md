# Stylus Platonic

Experimental *pure* CSS3D library.


## About

Built on top of Stylus, Platonic is a experimental CSS3D library for creating pure CSS3D content with CSS and HTML. 

It's primary objectives are:

1. To provide an 3D library for platforms that don't support WebGL.
2. To provide a simple API and workflow for generating content.
3. To generate the least amount of CSS required to display content.

[Installation](#installation) - [Features](#features) - [Examples](#examples) - [Core concepts](https://github.com/davidpaulrosser/stylus-platonic/wiki/Core-concepts) - [API](https://github.com/davidpaulrosser/stylus-platonic/wiki/API)

## Examples

Demo 1 - ...

Demo 2 - 400 cubes (  )

## Browser support

Platonic is only currently supported in *some* webkit based browsers due to various CSS3 properties it requires to display the content.

* Chrome v27.0
* Safari v6.0
* Safari iOS v6.0

## Features

* Configurable options for the viewport, ui-components and geometry
* Optimised CSS output
* Geometry
 * Quad
 * Triangle
 * Plane
 * Cube
 * Pyramid
 * Tetrahedron
 * Octahedron
 * Particle
 * Menger Sponge
* Uses [Photon](http://photon.attasi.com/) for lighting

## Installation

You can either install Platonic as a node module or download the [source](http://zip). 

See [usage](#usage) on how to link it to your stylus middleware compiler.

```
$ npm install stylus-platonic
``` 

## Usage

Below is an example of linking platonic up to the connect (or express) framework using stylus middleware.

```
var connect = require('connect')
  , stylus = require('stylus')
  , nib = require('nib');
  , platonic = require('stylus-platonic');

var server = connect();

function compile(str, path) {
  return stylus(str)
    .set('filename', path)
    .set('compress', true)
    .use(nib())
    .use(platonic());
}

server.use(stylus.middleware({
    src: __dirname
  , compile: compile
}));
```

## Platonic API

To use Platonic's mixins and styles you first need to import it into your stylus file.

```
@import 'stylus-platonic'
```

Since the majority of Platonic's API are mixins, it will only generate the required css.

Click [here](https://github.com/davidpaulrosser/stylus-platonic/wiki/API) for the list of API mixins and examples on how to use them.

## Testing

You will first need to install the dependencies.

```
$ npm install -d
```

Then run ```grunt``` from the lib directory and open ```http://localhost:9055```

This will create a local test server with watch / compile action.


## FAQ

Q: Why should you use Platonic over other 3D libraries?

A: Platonic offers a WebGL-independent solution for generating 3D content.

Q: When will more browsers be supported?

A: As soon as the browser vendors implement the technology required to display the 3D content.

Q: This is cool and all, but what about realtime?

A: I'm working on a node.js-based solution for that : )


## Contributing

For any issues and bugs please submit an issue.

If you would like to contribute to the library and / or have some good ideas on how things could be improved let's discuss it in the [Google group]().


## License

(MIT)

Copyright (c) 2013 David Paul Rosser, [https://github.com/davidpaulrosser/stylus-platonic](https://github.com/davidpaulrosser/stylus-platonic)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.