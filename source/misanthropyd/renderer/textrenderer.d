module misanthropyd.renderer.textrenderer;

import bindbc.freetype;

import misanthropyd.renderer.textures;

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

/// renders text as an array of unsigned ints
class TextRenderer
{
	/// initializes freetype
	static bool initialize()
	{
		/// load Freetype library
		immutable ret = loadFreeType();
		if(ret != ftSupport)
		{
			return false;
		}

		if(FT_Init_FreeType(&library_))
		{
			return false;
		}

		return true;
	}

	/// cleanup
	static void shutdown()
	{
		foreach(value ; fonts_)
		{
			destroy(value);
		}
		fonts_ = null;
		FT_Done_FreeType(library_);
	}

	/// load a font
	static void loadFont(const string name, const string path, uint size)
	{
		fonts_[name] = new Font(path, size);
	}

	/// render RGBA texture of text
	static Texture2D renderText(const string fontName, const wstring text, ubyte r=0xff, ubyte g=0xff, ubyte b=0xff)
	{
		import std.stdio: writefln;

		Texture2D texture;
		if(!cast(bool)(fontName in fonts_))
			return null;
		Font font = fonts_[fontName];
		immutable useKerning = FT_HAS_KERNING(font.face_);
		uint prevIndex = 0, glyphIndex = 0;
		uint width, height; // @suppress(dscanner.suspicious.unmodified)

		getSize(font, text, width, height);

		uint[] bitmap = new uint[width * height];
		bitmap[] = r | g<<8 | b<<16;
		texture = Texture2D.create(width, height);

		int x = 0;
		foreach(ch ; text)
		{
			glyphIndex = FT_Get_Char_Index(font.face_, ch);
			if(useKerning && prevIndex && glyphIndex)
			{
				FT_Vector delta;
				FT_Get_Kerning(font.face_, prevIndex, glyphIndex, FT_Kerning_Mode.FT_KERNING_DEFAULT, &delta);
				x += delta.x >> 6;
			}
			if(FT_Load_Char(font.face_, ch, FT_LOAD_RENDER))
				continue; // ignore unfound chars
			immutable glyphData = GlyphData(font.face_, font.face_.glyph);
			// immutable Y_START = (font.face_.bbox.yMax - font.face_.glyph.metrics.horiBearingY) >> 6;
			for(int row=0; row < font.face_.glyph.bitmap.rows; ++row)
			{
				immutable YPOS = height - (row + glyphData.yoffset);
				writefln("row=%s, yoffset=%s", row, glyphData.yoffset);
				for(int col=0; col < font.face_.glyph.bitmap.pitch; ++col)
				{
					immutable XPOS = x + col;
					// assert(glyphData.advance <= font.face_.glyph.bitmap.pitch);
					writefln("`%s`: XPOS,YPOS=%s,%s", ch, XPOS, YPOS);
					bitmap[YPOS * width + XPOS] |=
						font.face_.glyph.bitmap.buffer[row * font.face_.glyph.bitmap.pitch + col] << 24;
				}
			}
			x += glyphData.advance - glyphData.minx;
			prevIndex = glyphIndex;			
		}
		texture.setData(cast(ubyte[])bitmap);
		return texture;
	}

	private static getSize(Font font, const wstring text, ref uint width, ref uint height)
	{
		import std.algorithm: min, max;
		import std.stdio: writefln;

		uint prevIndex = 0;
		immutable useKerning = FT_HAS_KERNING(font.face_);
		int x, minx, maxx, miny, maxy = font.face_.ascender >> 6;

		width = 0;
		height = 0;

		foreach(ch ; text)
		{
			auto glyphIndex = FT_Get_Char_Index(font.face_, ch);
			if(useKerning && prevIndex && glyphIndex)
			{
				FT_Vector delta;
				FT_Get_Kerning(font.face_, prevIndex, glyphIndex, FT_Kerning_Mode.FT_KERNING_DEFAULT, &delta);
				x += delta.x >> 6;
			}
			if(FT_Load_Glyph(font.face_, ch, FT_LOAD_RENDER))
				continue;
			immutable glyphData = GlyphData(font.face_, font.face_.glyph);
			minx = min(minx, x + glyphData.minx);
			maxx = max(maxx, x + glyphData.maxx);
			// for spaces
			maxx = max(maxx, x + glyphData.advance);

			miny = min(miny, glyphData.yoffset);
			maxy = max(maxy, glyphData.yoffset + glyphData.maxy - glyphData.miny);
			x += glyphData.advance;
			prevIndex = glyphIndex;
		}
		width = maxx - minx;
		height = maxy - miny; // - (font.face_.descender >> 6);
		writefln("maxx,minx=%s,%s", maxx, minx);
		writefln("width,height=%s,%s", width, height);
		writefln("font.descender=%s", font.face_.descender >> 6);
	}

	package static FT_Library library_;
	private static Font[string] fonts_;
}

private long FT_FLOOR(long x) { return ((x & -64) >> 6); }
private long FT_CEIL(long x) { return (((x + 63) & -64) >> 6); }

private struct GlyphData
{
	this(const ref FT_Face face, const ref FT_GlyphSlot glyphSlot)
	{
		import std.stdio: writefln;
		minx = cast(int)(FT_FLOOR(glyphSlot.metrics.horiBearingX));
		// writefln("minx=%s", minx);
		maxx = cast(int)(FT_CEIL(glyphSlot.metrics.horiBearingX + glyphSlot.metrics.width));
		// writefln("maxx=%s", maxx);
		maxy = cast(int)(FT_FLOOR(glyphSlot.metrics.horiBearingY));
		// wrtefln("maxy=%s", maxy);
		miny = cast(int)(maxy - FT_CEIL(glyphSlot.metrics.height));
		// writefln("miny=%s", miny);
		yoffset = cast(int)(FT_CEIL(face.ascender) - maxy);
		// writefln("yoffset=%s", yoffset);
		advance = cast(int)(FT_CEIL(glyphSlot.metrics.horiAdvance));
		// writefln("advance=%s", advance);
	}

	int minx;
    int maxx;
    int miny;
    int maxy;
    int yoffset;
    int advance;
}

private class Font 
{
	this(const string path, uint fontSize)
	{
		import std.string: toStringz;
		import misanthropyd.core.logger : Logger;
		Logger.logf(Logger.Severity.WARNING, "Creating font %s %s", path, fontSize);
		immutable error = FT_New_Face(TextRenderer.library_, path.toStringz, 0, &face_);
		if(error != 0)
		{
			throw new FontLoadException("Failed to load font `" ~ path ~ "`");
		}
		FT_Set_Pixel_Sizes(face_, 0, fontSize);
	}

	~this()
	{
		FT_Done_Face(face_);
	}

	package FT_Face face_;
}
