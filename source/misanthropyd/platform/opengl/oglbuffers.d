module misanthropyd.platform.opengl.oglbuffers;

import bindbc.opengl;

import misanthropyd.renderer.buffers;

/// implements VertexBuffer with OpenGL
class OGLVertexBuffer : VertexBuffer
{
    /// constructor
    this(const float[] vertices)
    {
        glCreateBuffers(1, &id_);
        glBindBuffer(GL_ARRAY_BUFFER, id_);
        glBufferData(GL_ARRAY_BUFFER, vertices.length * float.sizeof, vertices.ptr, GL_STATIC_DRAW);
    }

    this(size_t size)
    {
        glCreateBuffers(1, &id_);
        glBindBuffer(GL_ARRAY_BUFFER, id_);
        glBufferData(GL_ARRAY_BUFFER, size, null, GL_DYNAMIC_DRAW);
    }

    /// destructor
    ~this()
    {
        glDeleteBuffers(1, &id_);
    }

    /// binds
    override void bind() const
    {
        glBindBuffer(GL_ARRAY_BUFFER, id_);
    }

    /// unbinds
    override void unbind() const
    {
        glBindBuffer(GL_ARRAY_BUFFER, 0);
    }

    /// sets the data in the buffer
    override void setData(const ubyte[] data)
    {
        glBindBuffer(GL_ARRAY_BUFFER, id_);
        glBufferSubData(GL_ARRAY_BUFFER, 0, data.length, data.ptr);
    }

    /// describes a layout
    override VertexBuffer describeLayout(const TypeInfo t, const size_t num, const bool normalized, 
                                const string name, const size_t size)
    {
        glBindBuffer(GL_ARRAY_BUFFER, id_);
        GLenum type;
        if(t.toString == "float")
        {
            type = GL_FLOAT;
        }
        else if(t.toString == "int")
        {
            type = GL_INT;
        }
        else
        {
            assert(false, "Type not supported yet");
        }
        glEnableVertexAttribArray(cast(ulong)(attrCounter_));
        glVertexAttribPointer(attrCounter_, cast(int)num, type, 
                            normalized ? GL_TRUE : GL_FALSE,
                            cast(int)size, cast(void*)offsetCounter_);
        ++attrCounter_;
        offsetCounter_ += t.tsize * num;

        return this;
    }

    private 
    {
        uint id_;
        uint attrCounter_;
        size_t offsetCounter_;
    }
}

/// opengl implementation of index buffer
class OGLIndexBuffer : IndexBuffer
{
    /// ctor
    this(const uint []indices)
    {
        count_ = cast(uint)indices.length;
        glCreateBuffers(1, &id_);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, id_);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices.length * uint.sizeof, indices.ptr, GL_STATIC_DRAW);
    }

    ~this()
    {
        glDeleteBuffers(1, &id_);
    }

    /// binds
    override void bind() const
    {
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, id_);
    }

    /// unbinds
    override void unbind() const
    {
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    }

    /// count property
    override uint count() const { return count_; }

    private 
    {
        uint count_;
        uint id_;
    }
}