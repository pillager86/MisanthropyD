module misanthropyd.platform.opengl.ogltextures;

import std.conv: to;
import std.string: toStringz;

import bindbc.opengl;
import stb.image;
import stb.image.binding;

import misanthropyd.renderer.textures;
import misanthropyd.core.logger;

/// implements OGL 2D textures
class OGLTexture2D : Texture2D
{
    /// loads from file using SDL_image
    this(const string path)
    {
        int w, h, channels;
        ubyte* data = stbi_load(path.toStringz, &w, &h, &channels, 0);
        width_ = w;
        height_ = h;
        GLenum ifmt, dataFmt;
        if(channels == 4)
        {
            ifmt = GL_RGBA8;
            dataFmt = GL_RGBA;
        }
        else if(channels == 3)
        {
            ifmt = GL_RGB8;
            dataFmt = GL_RGB;
        }
        internalFormat_ = ifmt;
        dataFormat_ = dataFmt;
        if((internalFormat_ & dataFormat_) == 0)
        {
            Logger.logf(Logger.Severity.ERROR, "Image format not yet supported!");
        }
        glCreateTextures(GL_TEXTURE_2D, 1, &id_);
        glTextureStorage2D(id_, 1, internalFormat_, width_, height_);
        glTextureParameteri(id_, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTextureParameteri(id_, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
        glTextureParameteri(id_, GL_TEXTURE_WRAP_S, GL_REPEAT);
        glTextureParameteri(id_, GL_TEXTURE_WRAP_T, GL_REPEAT);
        glTextureSubImage2D(id_, 0, 0, 0, width_, height_, dataFormat_, GL_UNSIGNED_BYTE, data);
        stbi_image_free(data);
    }

    this(const uint w, const uint h)
    {
        width_ = w;
        height_ = h;
        internalFormat_ = GL_RGBA8;
        dataFormat_ = GL_RGBA;
        glCreateTextures(GL_TEXTURE_2D, 1, &id_);
        glTextureStorage2D(id_, 1, internalFormat_, width_, height_);
        glTextureParameteri(id_, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTextureParameteri(id_, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
        glTextureParameteri(id_, GL_TEXTURE_WRAP_S, GL_REPEAT);
        glTextureParameteri(id_, GL_TEXTURE_WRAP_T, GL_REPEAT);
        // set data with setData
    }

    ~this() @nogc nothrow
    {
        glDeleteTextures(1, &id_);
    }

    /// sets the pixel data
    override void setData(const ubyte[] data)
    {
        immutable bpp = dataFormat_ == GL_RGBA ? 4 : 3; // only support these two for now
        if(data.length != width_ * height_ * bpp)
        {
            Logger.logf(Logger.Severity.ERROR, "Texture data must be width and height");
            return;
        }
        glTextureSubImage2D(id_, 0, 0, 0, width_, height_, dataFormat_, GL_UNSIGNED_BYTE, data.ptr);
    }

    /// width accessor
    override uint width() @nogc @safe const nothrow pure
    {
        return width_;
    }

    /// height accessor
    override uint height() @nogc @safe const nothrow pure
    {
        return height_;
    }

    /// bind
    override void bind(uint slot=0) @nogc const nothrow
    {
        glBindTextureUnit(slot, id_);
    }

    private uint width_, height_, id_;
    private GLenum internalFormat_, dataFormat_;
}