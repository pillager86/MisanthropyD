module misanthropyd.renderer.rendererapi;

import gfm.math.vector;

import misanthropyd.renderer.vertexarray;

/// RendererAPI
abstract class RendererAPI
{
	/// available APIs to use
	enum API { None=0, OpenGL }

	/// initialize
	void initialize();
	/// set viewport
	void setViewport(const uint x, const uint y, const uint width, const uint height);
	/// set the color for when clear is called
	void setClearColor(const vec4f color);
	/// clear the screen with set color
	void clear();
	/// draw a vertex array
	void drawIndexed(const VertexArray vertexArray, const uint count=0);
	/// which API is to be used
	static API api() { return api_; }
	/// create a new instance according to api
	static RendererAPI create()
	{
		import misanthropyd.platform.opengl.oglrendererapi : OGLRendererAPI;
		final switch(api_)
		{
			case RendererAPI.API.None: 
				assert(false, "Headless not supported yet");
			case RendererAPI.API.OpenGL: 
				return new OGLRendererAPI;
		}
	}

	private static API api_ = API.OpenGL;
}