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
            onUpdate();
            foreach(layer ; layerStack_.layers)
                layer.onUpdate(timestep);
            window_.onUpdate();
        }
    }

    /// event handler
    void onEvent(Event e)
    {
        auto dispatcher = EventDispatcher(e);
        dispatcher.dispatch!WindowCloseEvent(&onWindowClose);
        // Logger.logf(Logger.Severity.INFO, "%s", e);
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

    /// accessor for window
    pure @safe @nogc Window window() { return window_; }

    /// accessor for layerStack
    pure @safe @nogc LayerStack layerStack() nothrow { return layerStack_; }

    /// access singleton
    @safe @nogc static Application get() nothrow { return application_; }

    private 
    {
        pure @safe @nogc bool onWindowClose(WindowCloseEvent e) nothrow
        {
            running_ = false;
            return true;
        }

        Window window_;
        bool running_ = true;
        LayerStack layerStack_;
        SysTime lastFrameTime_;

        static Application application_;
    }
}


