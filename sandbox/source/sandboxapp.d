module sandboxapp;

import gfm.math.matrix;
import gfm.math.vector;

import misanthropyd.core.application;
import misanthropyd.core.timestep;
import misanthropyd.events;
import misanthropyd.core.keymousecodes;
import misanthropyd.core.layer;
import misanthropyd.core.logger;
import misanthropyd.renderer.buffers;
import misanthropyd.renderer.cameras;
import misanthropyd.renderer.rendercommand;
import misanthropyd.renderer.renderer;
import misanthropyd.renderer.renderer2d;
import misanthropyd.renderer.shaders;
import misanthropyd.renderer.textures;
import misanthropyd.renderer.vertexarray;

/// implements a basic testing app for the engine
class SandboxApp : Application
{
	/// ctor
	this()
	{
		window.vsync = true;
		layerStack.pushLayer(new TestLayer);
		Renderer.initialize();
	}

	~this()
	{
		Renderer.shutdown();
	}
}

/// implements test layer
class TestLayer : Layer
{
	/// ctor
	this()
	{
		super("Test");
		camera_ = new OrthographicCamera(-16.0f, 16.0f, 9.0f, -9.0f);
		blueTexture_ = Texture2D.create("sandbox/res/textures/test.jpg");
	}

	/// update
	override void onUpdate(const Timestep ts)
	{
		import misanthropyd.core.input : Input;
		static float rotation = 0.0f;
		static immutable ROTATION_SPEED = 20.0f;

		rotation += ROTATION_SPEED * ts.getSeconds;

		// Logger.logf(Logger.Severity.WARNING, "Time step = %s", ts.getSeconds);

		RenderCommand.setClearColor(vec4f(0.1f, 0.1f, 0.1f, 1));
        RenderCommand.clear();
        Renderer2D.beginScene(camera_);
		Renderer2D.drawQuad(vec2f(0.0f, 0.0f), vec2f(1.0f, 1.0f), vec4f(1.0f, 0.0f, 0.0f, 1.0f));
		Renderer2D.drawQuad(vec2f(1.0f, 0.0f), vec2f(1.0f, 1.0f), blueTexture_);
		Renderer2D.drawRotatedQuad(vec2f(-1.0f, -1.0f), vec2f(1.0f, 1.0f), rotation, vec4f(0.0f, 1.0f, 0.0f, 1.0f));
        Renderer2D.endScene();
	}

	private
	{
		Texture2D blueTexture_;
        OrthographicCamera camera_;
	}
}

void main(string[] args)
{
	(new SandboxApp).run();
}
