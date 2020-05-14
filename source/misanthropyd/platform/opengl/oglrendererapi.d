module misanthropyd.platform.opengl.oglrendererapi;

import bindbc.opengl;
import gfm.math.vector;

import misanthropyd.renderer.rendererapi;
import misanthropyd.renderer.vertexarray;

// TODO: OpenGL error callbacks for debug{}

/// implements OpenGL
class OGLRendererAPI : RendererAPI
{
	override void initialize() nothrow @nogc
	{
		glEnable(GL_BLEND);
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

		glEnable(GL_DEPTH_TEST);
	}

	/// set viewport
	override void setViewport(const uint x, const uint y, const uint width, const uint height) nothrow @nogc
	{
		glViewport(x, y, width, height);
	}

	/// set the color for when clear is called
	override void setClearColor(const vec4f color) nothrow @nogc
	{
		glClearColor(color.r, color.g, color.b, color.a);
	}

	/// clear the screen with set color
	override void clear() nothrow @nogc
	{
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	}

	/// draw a vertex array
	override void drawIndexed(const VertexArray vertexArray, const uint indexCount = 0)
	{
		immutable count = indexCount > 0 ? indexCount : vertexArray.indexBuffer.count;
		glDrawElements(GL_TRIANGLES, count, GL_UNSIGNED_INT, null);
		glBindTexture(GL_TEXTURE_2D, 0);
	}
}