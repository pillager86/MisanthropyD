module misanthropyd.renderer.shaders;

import gfm.math.matrix;
import gfm.math.vector;

import misanthropyd.platform.opengl.oglshaders;
import misanthropyd.renderer.renderer;
import misanthropyd.renderer.rendererapi;

/// what type of shader
enum ShaderType { VERTEX, FRAGMENT }

/// shaders make up programs
interface Shader
{
    /// create a shader from source
    static Shader create(const string src, const ShaderType type)
    {
        final switch(Renderer.getAPI)
        {
            case RendererAPI.API.None:
                assert(false, "Headless not supported yet");
            case RendererAPI.API.OpenGL:
                return new OGLShader(src, type);
        }
    }
}

/// thrown when shader compilation fails
class ShaderCompilationException : Exception
{
    /// constructor
    this(string msg, string file = __FILE__, size_t line = __LINE__, Throwable nextInChain = null) 
            pure nothrow @nogc @safe
    {
        super(msg, file, line, nextInChain);
    }
}

/// program is the compiled and linked shader
interface Program 
{
    /// use the shader program
    void use() const;
    /// disable the shader program
    void unuse() const;
    /// set int uniform
    void setInt(const string name, const int value) const;
    /// set int array uniform
    void setIntArray(const string name, const int[] values) const;
    /// set float uniform
    void setFloat(const string name, const float value) const;
    /// set vec3 uniform
    void setVec3(const string name, const vec3f value) const;
    /// set vec4 uniform
    void setVec4(const string name, const vec4f value) const;
    /// set mat4x4f uniform
    void setMat4(const string name, const mat4x4f matrix) const;
    
    /// links compiled shaders together to create program
    static Program create(Shader[] shaders...)
    {
        final switch(Renderer.getAPI)
        {
            case RendererAPI.API.None:
                assert(false, "Headless not supported yet");
            case RendererAPI.API.OpenGL:
                return new OGLProgram(shaders);
        }
    }
}

/// thrown when shader linking fails
class ProgramLinkException : Exception
{
    /// constructor
    this(string msg, string file = __FILE__, size_t line = __LINE__, Throwable nextInChain = null) 
            pure nothrow @nogc @safe
    {
        super(msg, file, line, nextInChain);
    }
}

/// to keep up with loaded shader programs
class ProgramLibrary
{
    import misanthropyd.core.logger : Logger;

    /// adds an existing shader program to library
    void add(const string name, Program program)
    {
        if(name in programs_)
            Logger.logf(Logger.Severity.WARNING, "Shader program `%s` already exists. Overwriting", name);
        programs_[name] = program;
    }

    /** Loads a shader program into library according to path
      * Params:
      *  name = If a shader is located at res/shaders/glsl/myshader.vs and myshader.frag this parameter should be
      *         myshader.
      *  path = If a shader is located at res/shaders/glsl/myshader.vs and myshader.frag this parameter should be
      *         res/shaders/glsl. Be sure not to use a trailing '/'
      * Returns: the program that was successfully loaded or null.
      */
    Program load(const string name, const string path)
    {
        import std.file : readText, FileException;
        import std.utf: UTFException;

        if(name in programs_)
            Logger.logf(Logger.Severity.WARNING, "Shader program `%s` already exists. Overwriting", name);
        
        try
        {
            // get vertex src
            immutable vertexSrc = readText(path ~ "/" ~ name ~ ".vs");
            // get fragment src
            immutable fragSrc = readText(path ~ "/" ~ name ~ ".frag");

            // TODO: handle compilation and link errors
            auto vertexShader = Shader.create(vertexSrc, ShaderType.VERTEX);
            auto fragmentShader = Shader.create(fragSrc, ShaderType.FRAGMENT);
            auto loadedProgram = Program.create(vertexShader, fragmentShader); // @suppress(dscanner.suspicious.unmodified)
            programs_[name] = loadedProgram;
            return loadedProgram;
        }
        catch(FileException fex)
        {
            Logger.logf(Logger.Severity.ERROR, "Unable to read shader file: %s", fex.msg);
        }
        catch(UTFException uex)
        {
            Logger.logf(Logger.Severity.ERROR, "UTF decoding error: %s", uex.msg);
        }
        return null;
    }

    // todo: unload, unloadAll

    /// retrieves a shader program by name or null if it doesn't exist.
    Program get(const string name)
    {
        if(name in programs_)
            return programs_[name];
        else
            return null;
    }

    /// returns true if shader program exists in library otherwise false
    bool exists(const string name) const
    {
        return cast(bool)(name in programs_);
    }

    private Program[string] programs_;
}

// TODO: Unittests but this requires opengl to be loaded