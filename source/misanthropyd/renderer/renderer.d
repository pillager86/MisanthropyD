module misanthropyd.renderer.renderer;

import gfm.math.matrix;

import misanthropyd.renderer.cameras;
import misanthropyd.renderer.rendercommand;
import misanthropyd.renderer.renderer2d;
import misanthropyd.renderer.rendererapi;
import misanthropyd.renderer.shaders;
import misanthropyd.renderer.vertexarray;

/// Renderer
class Renderer 
{
	/// initialize
	static void initialize()
	{
		RenderCommand.initialize();
		Renderer2D.initialize();
	}

	/// shutdown
	static void shutdown()
	{
		Renderer2D.shutdown();
	}

	/// handles window resize
	static void onWindowResize(const uint width, const uint height)
	{
		RenderCommand.setViewport(0, 0, width, height);
	}

	/// begin scene
	static void beginScene(const OrthographicCamera camera)
	{
		sceneData_.viewProjection = camera.viewProjectionCache;
	}

	/// end scene
	static void endScene()
	{

	}

	/// submit
	static void submit(const Program program, const VertexArray vertexArray, 
						const mat4x4f transform = mat4x4f.identity)
	{
		program.use();
		program.setMat4("u_ViewProjection", sceneData_.viewProjection);
		program.setMat4("u_Transform", transform);
		vertexArray.bind();
		RenderCommand.drawIndexed(vertexArray);
	}

	static RendererAPI.API getAPI() { return RendererAPI.api; }

	private
	{
		struct SceneData
		{
			mat4x4f viewProjection;
		}

		static SceneData sceneData_;
	}

}