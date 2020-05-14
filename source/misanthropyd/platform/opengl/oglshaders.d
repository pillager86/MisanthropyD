module misanthropyd.platform.opengl.oglshaders;

import std.conv: to;
import std.string: toStringz;

import bindbc.opengl;
import gfm.math.matrix;
import gfm.math.vector;

import misanthropyd.core.logger;
import misanthropyd.renderer.shaders;

/// implements opengl shader that makes up program
class OGLShader : Shader
{
	/// constructor takes source code as arg
	this(const string src, ShaderType type)
	{
		id_ = glCreateShader(type==ShaderType.VERTEX ? GL_VERTEX_SHADER : GL_FRAGMENT_SHADER);
		immutable GLchar* source = src.toStringz;
		glShaderSource(id_, 1, &source, null);
		glCompileShader(id_);
		GLint isCompiled;
		glGetShaderiv(id_, GL_COMPILE_STATUS, &isCompiled);
		if(isCompiled == GL_FALSE)
		{
			GLint maxLength;
			glGetShaderiv(id_, GL_INFO_LOG_LENGTH, &maxLength);
			GLchar[] infoLog = new GLchar[maxLength];
			glGetShaderInfoLog(id_, maxLength, &maxLength, &infoLog[0]);
			throw new ShaderCompilationException(infoLog.to!string);
		}
	}

	~this() @nogc nothrow
	{
		glDeleteShader(id_);
	}

	package uint id_;
}

/// a full shader program
class OGLProgram : Program
{
	/// constructor
	this(Shader[] shaders)
	{
		id_ = glCreateProgram();
		foreach(shader ; shaders)
		{
			/// only OGLShaders are accepted
			auto oglshader = cast(OGLShader)shader;
			if(oglshader is null)
				throw new ProgramLinkException("Invalid shader type");
			glAttachShader(id_, oglshader.id_);
		}
		glLinkProgram(id_);
		GLint isLinked;
		glGetProgramiv(id_, GL_LINK_STATUS, &isLinked);
		if(isLinked == GL_FALSE)
		{
			GLint maxLength;
			glGetProgramiv(id_, GL_INFO_LOG_LENGTH, &maxLength);
			GLchar[] infoLog = new GLchar[maxLength];
			glGetProgramInfoLog(id_, maxLength, &maxLength, &infoLog[0]);
			throw new ProgramLinkException(infoLog.to!string);
		}
		// detach shaders after successful link
		foreach(shader ; shaders)
		{
			auto oglshader = cast(OGLShader)shader;
			glDetachShader(id_, oglshader.id_);
		}
	}

	~this() nothrow @nogc
	{
		glDeleteProgram(id_);
	}

	/// use the shader program
	override void use() const nothrow @nogc
	{
		glUseProgram(id_);
	}

	/// disable the shader program
	override void unuse() const nothrow @nogc
	{
		glUseProgram(0);
	}

	/// upload int uniform
	override void setInt(const string name, const int value) const
	{
		uploadUniformInt(name, value);
	}

	/// set int array uniform
	override void setIntArray(const string name, const int[] values) const
	{
		uploadUniformIntArray(name, values);
	}

	/// set float uniform
	override void setFloat(const string name, const float value) const
	{
		uploadUniformFloat(name, value);
	}

	/// set vec3 uniform
	override void setVec3(const string name, const vec3f value) const
	{
		uploadUniformVec3(name, value);
	}

	/// set vec4 uniform
	override void setVec4(const string name, const vec4f value) const
	{
		uploadUniformVec4(name, value);
	}  

	/// upload mat4x4f uniform
	override void setMat4(const string name, const mat4x4f matrix) const
	{
		uploadUniformMat4(name, matrix);
	}

	/// upload int uniform
	void uploadUniformInt(const string name, const int value) const
	{
		immutable uloc = getUniformLocation(name);
		glUniform1i(uloc, value);
	}

	/// upload int array
	void uploadUniformIntArray(const string name, const int[] values) const
	{
		immutable uloc = getUniformLocation(name);
		glUniform1iv(uloc, cast(int)values.length, values.ptr);
	}

	/// upload uniform float
	void uploadUniformFloat(const string name, const float value) const
	{
		immutable uloc = getUniformLocation(name);
		glUniform1f(uloc, value);
	}

	/// upload vec2
	void uploadUniformVec2(const string name, const vec2f value) const
	{
		immutable uloc = getUniformLocation(name);
		glUniform2f(uloc, value[0], value[1]);
	}

	/// upload vec3
	void uploadUniformVec3(const string name, const vec3f value) const
	{
		immutable uloc = getUniformLocation(name);
		glUniform3f(uloc, value[0], value[1], value[2]);
	}

	/// upload vec4
	void uploadUniformVec4(const string name, const vec4f value) const
	{
		immutable uloc = getUniformLocation(name);
		glUniform4f(uloc, value[0], value[1], value[2], value[3]);
	}

	/// upload mat3
	void uploadUniformMat3(const string name, const mat3x3f matrix) const
	{
		immutable uloc = getUniformLocation(name);
		glUniformMatrix3fv(uloc, 1, GL_TRUE, &matrix.c[0][0]);
	}

	/// upload uniform mat4
	void uploadUniformMat4(const string name, const mat4x4f matrix) const
	{
		immutable uloc = getUniformLocation(name);
		glUniformMatrix4fv(uloc, 1, GL_TRUE, &matrix.c[0][0]);
	}

	private GLint getUniformLocation(const string name) const
	{
		immutable uloc = glGetUniformLocation(id_, name.toStringz);
		if(uloc == -1)
		{
			Logger.logf(Logger.Severity.ERROR, "Unknown uniform %s", name);
		}
		return uloc;
	}

	private uint id_;
}