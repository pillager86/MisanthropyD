module misanthropyd.core.application;

import std.datetime.systime : Clock, SysTime;
import core.time;

import gfm.math.vector;

import misanthropyd.core.timestep;
import misanthropyd.events;
import misanthropyd.core.input;
import misanthropyd.core.layerstack;
import misanthropyd.core.logger;
import misanthropyd.core.window;

/// Subclassed by host app
abstract class Application
{
	/// ctor
	this()
	{
		assert(application_ is null);
		application_ = this;
		layerStack_ = new LayerStack;
		window_ = Window.create(WindowProps("Sandbox", 1280, 720));
		window_.setEventCallback(&onEvent);
		lastFrameTime_ = Clock.currTime;
	}

	/// run the application.
	void run()
	{
		while(running_)
		{
			immutable newTime = Clock.currTime;
			immutable duration = newTime - lastFrameTime_;
			Timestep timestep =  Timestep(cast(float)(duration.total!"msecs") / 1000.0f);
			lastFrameTime_ = newTime;
			if(!minimized_)
			{
				onUpdate();
				foreach(layer ; layerStack_.layers)
					layer.onUpdate(timestep);
			}
			window_.onUpdate();
		}
	}

	/// event handler
	void onEvent(Event e)
	{
		auto dispatcher = EventDispatcher(e);
		dispatcher.dispatch!WindowCloseEvent(&onWindowClose);
		dispatcher.dispatch!WindowResizeEvent(&onWindowResize);
		// tell each layer about event if unhandled
		foreach_reverse(layer ; layerStack_.layers)
		{
			layer.onEvent(e);
			if(e.handled)
				break;
		}
	}

	/// each time update is called
	void onUpdate()
	{

	}

	/// handles window resize
	bool onWindowResize(WindowResizeEvent e)
	{
		import misanthropyd.renderer.renderer : Renderer;
		if(e.width == 0 || e.height == 0)
		{
			minimized_ = true;
			return false;
		}
		minimized_ = false;
		Renderer.onWindowResize(e.width, e.height);
		return false;
	}

	/// handles window closing
	bool onWindowClose(WindowCloseEvent e) nothrow pure @safe @nogc 
	{
		running_ = false;
		return true;
	}

	/// accessor for window
	pure @safe @nogc Window window() { return window_; }

	/// accessor for layerStack
	pure @safe @nogc LayerStack layerStack() nothrow { return layerStack_; }

	/// access singleton
	@safe @nogc static Application get() nothrow { return application_; }

	private 
	{

		Window window_;
		bool running_ = true;
		bool minimized_ = false;
		LayerStack layerStack_;
		SysTime lastFrameTime_;

		static Application application_;
	}
}


