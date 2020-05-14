module misanthropyd.events.mouseevent;

import misanthropyd.events.event;

import std.conv: to;

/// when the mouse moves
class MouseMovedEvent : Event 
{
	/// constructor takes new mouse location as args
	this(float mx, float my) nothrow pure @nogc @safe
	{
		mouseX_ = mx;
		mouseY_ = my;
	}

	/// new mouse x location
	float x() const nothrow pure @nogc @safe { return mouseX_; }
	/// new mouse y location
	float y() const nothrow pure @nogc @safe { return mouseY_; }

	override string toString() const @safe
	{
		return "MouseMovedEvent: " ~ mouseX_.to!string ~ ", " ~ mouseY_.to!string;
	}

	mixin EventClassType!(EventType, EventType.MouseMoved);
	mixin EventClassCategory!(EventCategory, EventCategory.Mouse | EventCategory.Input);

	private float mouseX_, mouseY_;
}

/// when the scroll wheel is used. can be vertical or horizontal
class MouseScrolledEvent : Event 
{
	/// constructor takes amount of movement
	this(float xoff, float yoff) nothrow pure @nogc @safe
	{
		xOffset_ = xoff;
		yOffset_ = yoff;
	}

	/// xOffset property
	float xOffset() const nothrow pure @nogc @safe { return xOffset_; }
	/// yOffset property
	float yOffset() const nothrow pure @nogc @safe { return yOffset_; }

	override string toString() const @safe
	{
		return "MouseScrolledEvent: " ~ xOffset_.to!string ~ ", " ~ yOffset_.to!string;
	}

	mixin EventClassType!(EventType, EventType.MouseScrolled);
	mixin EventClassCategory!(EventCategory, EventCategory.Mouse | EventCategory.Input);

	private float xOffset_, yOffset_;
}

/// base class for mouse button press and release
abstract class MouseButtonEvent : Event
{
	/// which button was pressed or released
	int button() const nothrow pure @nogc @safe { return button_; }    

	mixin EventClassCategory!(EventCategory, EventCategory.Mouse | EventCategory.Input);

	protected this(int btn) nothrow pure @nogc @safe
	{
		button_ = btn;
	}
	
	protected int button_;
}

/// when mouse button is pressed
class MouseButtonPressedEvent : MouseButtonEvent
{
	/// constructor
	this(int btn) nothrow pure @nogc @safe
	{
		super(btn);
	}

	override string toString() const @safe
	{
		return "MouseButtonPressedEvent: " ~ button_.to!string;
	}

	mixin EventClassType!(EventType, EventType.MouseButtonPressed);
}

/// when mouse button is released
class MouseButtonReleasedEvent : MouseButtonEvent
{
	/// ctor
	this(int btn) nothrow pure @nogc @safe
	{
		super(btn);
	}

	override string toString() const @safe
	{
		return "MouseButtonReleasedEvent: " ~ button_.to!string;
	}

	mixin EventClassType!(EventType, EventType.MouseButtonReleased);
}

unittest
{
	assert(MouseScrolledEvent.getStaticType == EventType.MouseScrolled);
	assert(MouseButtonPressedEvent.getStaticType == EventType.MouseButtonPressed);
	assert(MouseButtonReleasedEvent.getStaticType == EventType.MouseButtonReleased);
}