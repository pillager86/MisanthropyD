module misanthropyd.renderer.vertexarray;

import misanthropyd.platform.opengl.oglvertexarray;
import misanthropyd.renderer.buffers;
import misanthropyd.renderer.renderer;
import misanthropyd.renderer.rendererapi;

/// interface for Vertex arrays
interface VertexArray 
{
	/// binds
	void bind() const;
	/// unbinds
	void unbind() const;
	/// add a vertex buffer
	void addVertexBuffer(VertexBuffer);
	/// set the index buffer
	void setIndexBuffer(IndexBuffer);
	/// get vertex buffer(s)
	const(VertexBuffer[]) vertexBuffers() const;
	/// get index buffer
	const(IndexBuffer) indexBuffer() const;
	/// create based on API
	static VertexArray create()
	{
		final switch(Renderer.getAPI)
		{
			case RendererAPI.API.None:
				assert(false, "Headless not supported yet");
			case RendererAPI.API.OpenGL:
				return new OGLVertexArray;
		}
	}
}