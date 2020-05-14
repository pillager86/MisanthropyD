module misanthropyd.platform.opengl.oglvertexarray;

import bindbc.opengl;

import misanthropyd.renderer.vertexarray;
import misanthropyd.renderer.buffers;

/// implements OpenGL vertex arrays
class OGLVertexArray : VertexArray
{
	/// ctor
	this()
	{
		glCreateVertexArrays(1, &id_);
		glBindVertexArray(id_);
	}

	~this()
	{
		glDeleteVertexArrays(1, &id_);
	}

	/// binds
	override void bind() const
	{
		glBindVertexArray(id_);
	}

	/// unbinds
	override void unbind() const
	{
		glBindVertexArray(0);
	}

	/// add a vertex buffer
	override void addVertexBuffer(VertexBuffer vb)
	{
		glBindVertexArray(id_);
		vb.bind();
		vertexBuffers_ ~= vb;
	}

	/// set the index buffer
	override void setIndexBuffer(IndexBuffer ib)
	{
		glBindVertexArray(id_);
		ib.bind();
		indexBuffer_ = ib;
	}

	/// get vertex buffer(s)
	override const(VertexBuffer[]) vertexBuffers() const
	{
		return vertexBuffers_;
	}

	/// get index buffer
	override const(IndexBuffer) indexBuffer() const nothrow pure @nogc @safe
	{
		return indexBuffer_;
	}

	private
	{
		uint id_;
		VertexBuffer[] vertexBuffers_;
		IndexBuffer indexBuffer_;
	}
}