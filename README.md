# MisanthropyD
A port of the TheCherno's Hazel game engine to the D programming language.

To use, cd to the directory above misanthropyd and `dub add-local misanthropyd` then cd back into misanthropyd and `dub run :sandbox`

This software has only been tested on Ubuntu Linux 64-bit so far but it should work on Windows if one has all the necessary libraries (OpenGL, SDL).

## TODO
- Implement game using engine
- Implement OpenGL debugging
- Implement GLFW (currently uses SDL only) to use the D port of imgui (dimgui).
