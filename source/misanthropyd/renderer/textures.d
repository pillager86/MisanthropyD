module misanthropyd.renderer.textures;

import misanthropyd.renderer.renderer;
import misanthropyd.renderer.rendererapi;
import misanthropyd.platform.opengl.ogltextures;

/// generic texture of all types
interface Texture
{
	/// width accessor
	uint width() const;
	/// height accessor
	uint height() const;
	/// bind
	void bind(uint slot=0) const;
}

/// 2D texture interface
interface Texture2D : Texture 
{
	/// sets the pixel data
	void setData(const ubyte[] data);

	/// creates 2D texture according to API
	static Texture2D create(const string path)
	{
		final switch(Renderer.getAPI)
		{
			case RendererAPI.API.None:
				assert(false, "Headless not supported yet");
			case RendererAPI.API.OpenGL:
				return new OGLTexture2D(path);
		}
	}
	
	/// create texture of specified width and height to fill data later
	static Texture2D create(const uint width, const uint height)
	{
		final switch(Renderer.getAPI)
		{
			case RendererAPI.API.None:
				assert(false, "Headless not supported yet");
			case RendererAPI.API.OpenGL:
				return new OGLTexture2D(width, height);
		}
	}
}