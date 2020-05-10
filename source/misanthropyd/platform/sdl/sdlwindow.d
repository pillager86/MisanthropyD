module misanthropyd.platform.sdl.sdlwindow;

import std.conv: to;
import std.string: toStringz;

import bindbc.sdl;

import misanthropyd.events;
import misanthropyd.core.logger;
import misanthropyd.renderer.graphicscontext;
import misanthropyd.core.window;

class SdlWindow : Window
{
    this(const WindowProps props)
    {
        version(OpenGL)
            import misanthropyd.platform.opengl.oglgraphicscontext : OGLGraphicsContext;
        else 
            static assert(false, "No graphics API for context!"); // TODO: support SDL rendering

        synchronized { initializeSDL(); }

        window_ = SDL_CreateWindow(props.title.toStringz, SDL_WINDOWPOS_CENTERED, 
                SDL_WINDOWPOS_CENTERED, props.width, props.height, 
                SDL_WINDOW_OPENGL | SDL_WINDOW_RESIZABLE);
        if(window_ == null)
            Logger.logf(Logger.Severity.FATAL, "Failed to create SDL Window: %s", 
                        SDL_GetError.to!string);

        // default value for event callback
        eventCallback_ = (e) {};

        version(OpenGL)
            context_ = new OGLGraphicsContext(window_);
        // TODO: support other rendering APIs
    }

    ~this() @nogc nothrow
    {
        SDL_DestroyWindow(window_);
    }

    override void onUpdate()
    {
        SDL_Event event;
        while(SDL_PollEvent(&event) > 0)
        {
            switch(event.type)
            {
            case SDL_WINDOWEVENT:
                switch(event.window.event)
                {
                case SDL_WINDOWEVENT_RESIZED:
                    auto e = new WindowResizeEvent(event.window.data1, event.window.data2);
                    eventCallback_(e);
                    break;
                default:
                    break;
                }
                break;
            case SDL_KEYDOWN:
            {
                auto e = new KeyPressedEvent(event.key.keysym.sym, event.key.keysym.mod, event.key.repeat);
                eventCallback_(e);
                break;
            }
            case SDL_KEYUP:
            {
                auto e = new KeyReleasedEvent(event.key.keysym.sym, event.key.keysym.mod);
                eventCallback_(e);
                break;
            }
            case SDL_TEXTINPUT:
            {
                auto text = event.text.text.toStringz;
                auto e = new TextInputEvent(text.to!string);
                eventCallback_(e);
                break;
            }
            case SDL_MOUSEBUTTONDOWN:
            {
                auto e = new MouseButtonPressedEvent(event.button.button);
                eventCallback_(e);
                break;
            }
            case SDL_MOUSEBUTTONUP:
            {
                auto e = new MouseButtonReleasedEvent(event.button.button);
                eventCallback_(e);
                break;
            }
            case SDL_MOUSEWHEEL:
            {
                auto e = new MouseScrolledEvent(cast(float)event.wheel.x, 
                                                cast(float)event.wheel.y);
                eventCallback_(e);
                break;
            }
            case SDL_MOUSEMOTION:
            {
                auto e = new MouseMovedEvent(cast(float)event.motion.x, 
                                            cast(float)event.motion.y);
                eventCallback_(e);
                break;
            }
            case SDL_QUIT:
            {
                auto e = new WindowCloseEvent();
                eventCallback_(e);
                break;    
            }
            default:
                break;
            }
        }
        context_.swapBuffers();
    }

    override uint width() @nogc nothrow
    {
        int w;
        SDL_GetWindowSize(window_, &w, null);
        return w;
    }

    override uint height() @nogc nothrow
    {
        int h;
        SDL_GetWindowSize(window_, null, &h);
        return h;
    }

    override bool vsync() @nogc @safe pure const nothrow
    {
        return vsync_;
    }

    override bool vsync(bool vs) @nogc nothrow
    {
        vsync_ = vs;
        version(OpenGL)
            SDL_GL_SetSwapInterval(vs?1:0);
        // TODO: support other renderers
        return vsync_;
    }

    override void setEventCallback(const EventCallbackFn fn) @nogc @safe pure nothrow
    {
        eventCallback_ = fn;
    }

    // window property
    // @nogc SDL_Window* window() { return window_; }

    private
    {
        static void initializeSDL()
        {
            if(!isSDLLoaded)
            {
                if(loadSDL() != sdlSupport)
                {
                    Logger.logf(Logger.Severity.FATAL, "Error loading SDL library");
                    return;
                }

                if(SDL_Init(SDL_INIT_EVERYTHING) < 0)
                {
                    Logger.logf(Logger.Severity.FATAL, "SDL Error: %s", SDL_GetError().to!string);
                    return;
                }

                if(loadSDLImage() != sdlImageSupport)
                {
                    Logger.logf(Logger.Severity.FATAL, "SDL Image not supported!");
                    return;
                }

                immutable flags = IMG_INIT_JPG | IMG_INIT_PNG | IMG_INIT_TIF | IMG_INIT_WEBP;
                if((IMG_Init(flags) & flags) != flags)
                {
                    Logger.logf(Logger.Severity.ERROR, "IMG_Init: %s", IMG_GetError().to!string);
                }

                isSDLLoaded = true;
            }
        }

        SDL_Window* window_;
        GraphicsContext context_;
        bool vsync_;
        EventCallbackFn eventCallback_;

        static shared bool isSDLLoaded = false;
    }
}