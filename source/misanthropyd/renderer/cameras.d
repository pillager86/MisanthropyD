module misanthropyd.renderer.cameras;

import gfm.math.vector;
import gfm.math.matrix;
import std.math: PI;

/// helper function
private pure @safe @nogc float degreesToRadians(float angle) nothrow
{
	return angle * PI / 180.0f;
}

/// implements an orthographic camera
class OrthographicCamera
{
	/// constructor
	pure @safe @nogc this(const float left, const float right, const float bottom, const float top) nothrow
	{
		position_ = vec3f(0,0,0);
		rotation_ = 0.0f;
		projectionMatrix_ = mat4x4f.orthographic(left, right, bottom, top, -1.0f, 1.0f);
		viewMatrix_ = mat4x4f.identity();
		viewProjectionCache_ = projectionMatrix_ * viewMatrix_;
	}

	/// projection matrix get property
	pure @safe @nogc mat4x4f projectionMatrix() const nothrow { return projectionMatrix_; }
	/// view matrix get property
	pure @safe @nogc mat4x4f viewMatrix() const nothrow { return viewMatrix_; }
	/// projection view cache get property
	pure @safe @nogc mat4x4f viewProjectionCache() const nothrow { return viewProjectionCache_; }

	/// position get property
	pure @safe @nogc vec3f position() const nothrow { return position_; }
	/// position set property
	pure @safe @nogc vec3f position(const vec3f pos) nothrow 
	{ 
		position_ = pos; 
		recalculateViewMatrix(); 
		return position_; 
	}
	/// rotation (z-axis) get property
	pure @safe @nogc float rotation() const nothrow { return rotation_; }
	/// rotation (z-axis) set property
	pure @safe @nogc float rotation(const float rot) nothrow 
	{ 
		rotation_ = rot; 
		recalculateViewMatrix();
		return rotation_;
	}

	/// reset the projection
	void setProjection(const float left, const float right, const float bottom, const float top)
	{
		projectionMatrix_ = mat4x4f.orthographic(left, right, bottom, top, -1.0f, 1.0f);
		viewProjectionCache_ = projectionMatrix_ * viewMatrix_;        
	}

	private
	{
		pure @safe @nogc void recalculateViewMatrix() nothrow
		{
			mat4x4f transform = mat4x4f.translation(position_) 
					 * mat4x4f.rotation(degreesToRadians(rotation_), vec3f(0, 0, 1));
			viewMatrix_ = transform.inverse();
			viewProjectionCache_ = projectionMatrix_ * viewMatrix_;
		}

		mat4x4f projectionMatrix_;
		mat4x4f viewMatrix_;
		mat4x4f viewProjectionCache_;

		vec3f position_;
		float rotation_;
	}
}