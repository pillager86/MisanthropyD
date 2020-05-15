module sandbox2d;

import gfm.math.vector;

import misanthropyd.core.layer;
import misanthropyd.core.timestep;
import misanthropyd.debugging.instrumentor;
import misanthropyd.events;
import misanthropyd.orthographiccameracontroller;
import misanthropyd.renderer.rendercommand;
import misanthropyd.renderer.renderer2d;
import misanthropyd.renderer.textures;

/// class for testing
class Sandbox2D : Layer
{
	/// ctor
	this()
	{
		super("Sandbox2D");
		cameraController_ = new OrthographicCameraController(1280.0f / 720.0f);
		Instrumentor.get.beginSession("session");
	}

	~this()
	{
		Instrumentor.get.endSession();
	}

	override void onAttach()
	{
		checkerboardTexture_ = Texture2D.create("sandbox/res/textures/checkerboard.png");
		marioTexture_ = Texture2D.create("sandbox/res/textures/mario.png");
	}

	override void onDetach()
	{
		checkerboardTexture_ = null;
	}

	override void onUpdate(const Timestep ts)
	{
		// InstrumentationTimer timer1 = InstrumentationTimer(__FUNCTION__);
		mixin(MdProfileScope!(__FUNCTION__));
		cameraController_.onUpdate(ts);
		static float rotation = 0.0f;
		rotation += ts.getSeconds * 50.0f;

		RenderCommand.setClearColor(vec4f(0.1f, 0.1f, 0.1f, 1.0f));
		RenderCommand.clear();

		Renderer2D.beginScene(cameraController_.camera);
		Renderer2D.drawRotatedQuad(vec2f(1.0f, 0.0f), vec2f(0.8f, 0.8f), -45.0f, vec4f(0.8f, 0.2f, 0.3f, 1.0f));
		Renderer2D.drawQuad(vec2f(0.5f, 0.5f), vec2f(0.5f, 0.75f), vec4f(0.2f, 0.3f, 0.8f, 1.0f));
		Renderer2D.drawQuad(vec3f(0.0f, 0.0f, -0.1f), vec2f(20.0f, 20.0f), checkerboardTexture_, 10.0f);
		Renderer2D.drawRotatedQuad(vec3f(-2.0f, 0.0f, 0.0f), vec2f(1.0f, 1.0f), rotation, checkerboardTexture_, 20.0f);
		Renderer2D.drawQuad(vec3f(-3.0f, 0.0f, 0.1f), vec2f(0.9f, 0.9f), marioTexture_);
		Renderer2D.endScene();

		Renderer2D.beginScene(cameraController_.camera);
		for(float y = -5.0f; y < 5.0f; y += 0.5f)
		{
			for(float x = -5.0f; x < 5.0f; x += 0.5f)
			{
				immutable color = vec4f((x + 5.0f) / 10.0f, 0.4f, (y + 5.0f) / 10.0f, 0.7f);
				Renderer2D.drawQuad(vec2f(x, y), vec2f(0.45f, 0.45f), color);
			}
		}
		Renderer2D.endScene();
	}

	override void onEvent(Event e)
	{
		cameraController_.onEvent(e);
	}

	private
	{
		OrthographicCameraController cameraController_;
		Texture2D checkerboardTexture_, marioTexture_;
	}

}