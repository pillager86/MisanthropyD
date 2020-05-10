module misanthropyd.renderer.rendercommand;

import gfm.math.vector;

import misanthropyd.platform.opengl.oglrendererapi;
import misanthropyd.renderer.renderer;
import misanthropyd.renderer.rendererapi;
import misanthropyd.renderer.vertexarray;

/// RenderCommand
class RenderCommand
{
	/// initialize
	static void initialize()
	{
		rendererAPI_.initialize();
	}

	/// set viewport
	static void setViewport(const uint x, const uint y, const uint width, const uint height)
	{
		rendererAPI_.setViewport(x, y, width, height);
	}

	/// sets the clear color
	static void setClearColor(const vec4f color)
	{
		rendererAPI_.setClearColor(color);
	}

	/// clears using color set by setClearColor
	static void clear()
	{
		rendererAPI_.clear();
	}

	/// draws a vertex array
	static void drawIndexed(const VertexArray vertexArray, const uint count=0)
	{
		rendererAPI_.drawIndexed(vertexArray, count);
	}

	/// static initializer
	static this()
	{
		rendererAPI_ = RendererAPI.create();
	}

	private static RendererAPI rendererAPI_;
}