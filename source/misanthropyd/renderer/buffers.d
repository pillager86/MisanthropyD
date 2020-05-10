module misanthropyd.renderer.buffers;

import misanthropyd.platform.opengl.oglbuffers;
import misanthropyd.renderer.renderer;
import misanthropyd.renderer.rendererapi;

// TODO: Vertex struct that can be passed to VertexBuffer ctor

/// interface for vertex buffers
interface VertexBuffer
{
    /// binds
    void bind() const;
    /// unbinds
    void unbind() const;
    /// sets the data in the buffer
    void setData(const ubyte[] data);
    /// describes a layout using typeinfo. TODO: better documentation
    VertexBuffer describeLayout(const TypeInfo t, const size_t num, const bool normalized, 
                                const string name, const size_t size);
    /// creates a VertexBuffer according to specified API
    static VertexBuffer create(const float[] vertices)
    {
        final switch(Renderer.getAPI)
        {
            case RendererAPI.API.None:
                assert(false, "Headless not supported yet");
            case RendererAPI.API.OpenGL:
                return new OGLVertexBuffer(vertices);
        }
    }
    /// creates a VertexBuffer with room for modified data
    static VertexBuffer create(size_t size)
    {
        final switch(Renderer.getAPI)
        {
            case RendererAPI.API.None:
                assert(false, "Headless not supported yet");
            case RendererAPI.API.OpenGL:
                return new OGLVertexBuffer(size);
        }        
    }
}

/// interface for index buffers
interface IndexBuffer
{
    /// binds
    void bind() const;
    /// unbinds
    void unbind() const;
    /// count property
    uint count() const;
    /// creates indexbuffer according to selected API
    static IndexBuffer create(const uint[] indices)
    {
        final switch(Renderer.getAPI)
        {
            case RendererAPI.API.None:
                assert(false, "Headless not supported yet");
            case RendererAPI.API.OpenGL:
                return new OGLIndexBuffer(indices);
        }        
    }
}