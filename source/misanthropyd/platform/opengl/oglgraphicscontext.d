module misanthropyd.platform.opengl.oglgraphicscontext;

import bindbc.opengl;
version(SDL)
{
	import bindbc.sdl;
}

import misanthropyd.core.logger;
import misanthropyd.renderer.graphicscontext;

class OGLGraphicsContext : GraphicsContext
{
	version(SDL)
	{
		this(SDL_Window* handle)
		{
			window_ = handle;
			version(OSX)
				SDL_GL_SetAttribute(SDL_GL_CONTEXT_FLAGS, SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG);
			else
				SDL_GL_SetAttribute(SDL_GL_CONTEXT_FLAGS, 0);
			SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);
			// TODO: set major and minor version according to e.g. GL_46
			SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 4);
			SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 6);
			SDL_GL_SetAttribute(SDL_GL_STENCIL_SIZE, 8);
			context_ = SDL_GL_CreateContext(window_);
			synchronized { initializeOGL(); }
		}
	}
	else static assert(false, "No Window API"); // TODO: GLFW support

	~this() nothrow @nogc
	{
		version(SDL)
			SDL_GL_DeleteContext(context_);
		// TODO: support GLFW
	}

	override void swapBuffers() nothrow @nogc
	{
		version(SDL)
			SDL_GL_SwapWindow(window_);
		// TODO: GLFW support
	}

	private 
	{
		static void initializeOGL()
		{
			import std.conv: to;

			if(!isOpenGLLoaded)
			{
				immutable loaded = loadOpenGL();
				if(loaded != glSupport)
				{
					Logger.logf(Logger.Severity.FATAL, "OpenGL loading error: %s", loaded.to!string);
				}
				else
				{
					isOpenGLLoaded = true;
				}
			}
		}

		version(SDL)
		{
			SDL_Window* window_;
			SDL_GLContext context_;
		}
		else static assert(false, "No Window API"); // TODO: support GLFW

		static shared bool isOpenGLLoaded = false;
	}
}