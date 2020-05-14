module misanthropyd.orthographiccameracontroller;

import std.math;

import gfm.math.funcs;
import gfm.math.vector;

import misanthropyd.core.input;
import misanthropyd.core.keymousecodes;
import misanthropyd.core.timestep;
import misanthropyd.events;
import misanthropyd.renderer.cameras;

/// implements orthographic camera controller
class OrthographicCameraController
{
	/// constructor
	this(float ar, bool rot=false) nothrow pure @safe
	{
		aspectRatio_ = ar;
		camera_ = new OrthographicCamera(-aspectRatio_ * zoomLevel_, aspectRatio_ * zoomLevel_, 
										 -zoomLevel_, zoomLevel_);
		rotation_ = rot;
	}

	/// on update
	void onUpdate(const Timestep ts)
	{
		if(Input.isKeyPressed(MD_KEY_a))
		{
			cameraPosition_.x -= cos(radians(cameraRotation_)) * cameraTranslationSpeed_ * ts.getSeconds;
			cameraPosition_.y -= sin(radians(cameraRotation_)) * cameraTranslationSpeed_ * ts.getSeconds;
		}
		else if(Input.isKeyPressed(MD_KEY_d))
		{
			cameraPosition_.x += cos(radians(cameraRotation_)) * cameraTranslationSpeed_ * ts.getSeconds;
			cameraPosition_.y += sin(radians(cameraRotation_)) * cameraTranslationSpeed_ * ts.getSeconds;
		}
		
		if(Input.isKeyPressed(MD_KEY_w))
		{
			cameraPosition_.x += -sin(radians(cameraRotation_)) * cameraTranslationSpeed_ * ts.getSeconds;
			cameraPosition_.y += cos(radians(cameraRotation_)) * cameraTranslationSpeed_ * ts.getSeconds;
		}
		else if(Input.isKeyPressed(MD_KEY_s))
		{
			cameraPosition_.x -= -sin(radians(cameraRotation_)) * cameraTranslationSpeed_ * ts.getSeconds;
			cameraPosition_.y -= cos(radians(cameraRotation_)) * cameraTranslationSpeed_ * ts.getSeconds;
		}

		if(rotation_)
		{
			if(Input.isKeyPressed(MD_KEY_q))
				cameraRotation_ += cameraRotationSpeed_ * ts.getSeconds;
			if(Input.isKeyPressed(MD_KEY_e))
				cameraRotation_ -= cameraRotationSpeed_ * ts.getSeconds;
			
			if(cameraRotation_ > 180.0f)
				cameraRotation_ -= 360.0f;
			else if(cameraRotation_ <= -180.0f)
				cameraRotation_ += 360.0f;

			camera_.rotation = cameraRotation_;
		}

		camera_.position = cameraPosition_;

		cameraTranslationSpeed_ = zoomLevel_;
	}

	/// event handler
	void onEvent(Event e)
	{
		EventDispatcher dispatcher = EventDispatcher(e);
		dispatcher.dispatch!MouseScrolledEvent(&onMouseScrolled);
		dispatcher.dispatch!WindowResizeEvent(&onWindowResized);
	}

	/// camera get property
	OrthographicCamera camera() nothrow pure @nogc @safe
	{
		return camera_;
	}

	/// zoom level get property
	float zoomLevel() const nothrow pure @nogc @safe
	{
		return zoomLevel_;
	}

	/// zoom level set property
	float zoomLevel(float zl) nothrow pure @nogc @safe
	{
		return zoomLevel_ = zl;
	}

	private
	{
		bool onMouseScrolled(MouseScrolledEvent e) nothrow pure @nogc @safe
		{
			import std.algorithm: max;

			zoomLevel_ -= e.yOffset * 0.25f;
			zoomLevel_ = max(zoomLevel_, 0.25f);
			camera_.setProjection(-aspectRatio_ * zoomLevel_, aspectRatio_ * zoomLevel_, -zoomLevel_, zoomLevel_);
			return false;
		}

		bool onWindowResized(WindowResizeEvent e) nothrow pure @nogc @safe
		{
			aspectRatio_ = cast(float)e.width / cast(float)e.height;
			camera_.setProjection(-aspectRatio_ * zoomLevel_, aspectRatio_ * zoomLevel_, -zoomLevel_, zoomLevel_);
			return false;
		}
	}

	private
	{
		float aspectRatio_;
		float zoomLevel_ = 1.0f;
		OrthographicCamera camera_;
		bool rotation_;
		vec3f cameraPosition_ = vec3f(0.0f, 0.0f, 0.0f);
		float cameraRotation_ = 0.0f; // in degrees
		float cameraTranslationSpeed_ = 5.0f, cameraRotationSpeed_ = 180.0f;
	}
}