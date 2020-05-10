module misanthropyd.core.window;

import misanthropyd.events.event;

/// properties of all windows
struct WindowProps
{
    /// title shown in title bar
    string title;
    /// width in pixels
    uint width;
    /// height in pixels
    uint height;
}

/// generic interface for a Window
interface Window 
{
    alias EventCallbackFn = void delegate(Event);

    /// update
    void onUpdate();
    /// width property
    uint width();
    /// height property
    uint height();
    /// set a callback for events
    void setEventCallback(const EventCallbackFn callback);
    /// vsync get property
    bool vsync() const;
    /// vsync set property
    bool vsync(bool enabled);
    /// create a window with properties
    static Window create(const WindowProps props)
    {
        version(SDL)
        {
            import misanthropyd.platform.sdl.sdlwindow : SdlWindow;
            return new SdlWindow(props);
        }
        else 
        {
            static assert(false, "Only SDLGL Window is available!");
        }
    }
}