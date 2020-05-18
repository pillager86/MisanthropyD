module textrenderer;

import bindbc.freetype;

import misanthropyd.renderer.textures;

/// renders text
class TextRenderer
{
	/// initialize the text renderer
	static bool initialize()
	{
		immutable ret = loadFreeType();
		if(ret != ftSupport)
			return false;

		if(FT_Init_FreeType(cast(FT_Library*)&library_))
			return false;

		return true;
	}

	/// clean up all fonts and libraries
	static void shutdown()
	{
		foreach(font ; fonts_)
		{
			destroy(font);
		}
		fonts_ = null;
		FT_Done_Library(cast(FT_Library)library_);
		library_ = null;
	}

	/// load and store a font under name
	static void loadFont(const string name, const string path, const uint size)
	{
		// todo: check for overwriting and warn
		Font font = new Font(path, size);
		fonts_[name] = cast(shared(Font))font;
	}

	/// render colored text on a transparent background
	static Texture2D renderText(const string fontName, const wstring text, ubyte r=0xff, ubyte g=0xff, ubyte b=0xff)
	{
		if(fontName !in fonts_)
			throw new TextRenderException("No such font loaded: `" ~ fontName ~ "`");
		Font font = cast(Font)fonts_[fontName];
		uint width, height; // @suppress(dscanner.suspicious.unmodified)
		sizeTextInternal(font, text, width, height);
		uint[] pixels = new uint[width * height];
		pixels[] = r | g<<8 | b<<16;
		int x = 0;
		foreach(ch ; text)
		{
			if(FT_Load_Char(font.face_, ch, FT_LOAD_RENDER))
				continue; // ignore unrenderable chars
			for(int row=0; row < font.face_.glyph.bitmap.rows; ++row)
			{
				immutable YPOS = height - (font.baseline_ - font.face_.glyph.bitmap_top + row) - 1;
				for(int col=0; col < font.face_.glyph.bitmap.width; ++col)
				{
					immutable XPOS = x + col;
					pixels[XPOS + YPOS * width] |=
						font.face_.glyph.bitmap.buffer[col + row * font.face_.glyph.bitmap.width] << 24;
				}
			}
			x += font.face_.glyph.advance.x / 64;
		}
		Texture2D texture = Texture2D.create(width, height);
		texture.setData(cast(ubyte[])pixels);
		return texture;
	}

	private static void sizeTextInternal(Font font, const wstring text, ref uint width, ref uint height)
	{
		height = font.height_;
		width = 0;
		foreach(ch ; text)
		{
			if(FT_Load_Char(font.face_, ch, FT_LOAD_RENDER))
				continue; // ignore invalid chars
			width += font.face_.glyph.advance.x / 64;
		}
	}

	package static shared(FT_Library) library_;
	private static shared(Font[string]) fonts_;
}

/// thrown when text rendering fails
class TextRenderException : Exception
{
	/// constructor
	this(string msg, string file = __FILE__, size_t line = __LINE__, Throwable nextInChain = null) 
			pure nothrow @nogc @safe
	{
		super(msg, file, line, nextInChain);
	}
}

/// thrown when font loading fails
class FontLoadException : Exception
{
	/// constructor
	this(string msg, string file = __FILE__, size_t line = __LINE__, Throwable nextInChain = null) 
			pure nothrow @nogc @safe
	{
		super(msg, file, line, nextInChain);
	}
}

private class Font 
{
	this(const string path, const uint size)
	{
		import std.conv: to;
		import std.string: toStringz;
		if(FT_New_Face(cast(FT_Library)TextRenderer.library_, path.toStringz, 0, &face_))
			throw new FontLoadException("Unable to load font `" ~ path ~ "`");
		if(FT_Set_Char_Size(face_, 0, size * 64, 0, 0))
			throw new FontLoadException("Unable to set font size " ~ size.to!string);
		// set metrics
		ascent_ = cast(int)(face_.size.metrics.ascender / 64);
		descent_ = cast(int)(face_.size.metrics.descender / 64);
		height_ = cast(int)(face_.size.metrics.height / 64);
		baseline_ = height_ + descent_;
	}

	~this()
	{
		FT_Done_Face(face_);
	}

	package
	{
		FT_Face face_;
		int ascent_, descent_, height_, baseline_;
	}
}