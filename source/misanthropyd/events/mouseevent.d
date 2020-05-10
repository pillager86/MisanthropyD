module misanthropyd.events.mouseevent;

import misanthropyd.events.event;

import std.conv: to;

/// when the mouse moves
class MouseMovedEvent : Event 
{
	/// constructor takes new mouse location as args
	pure @safe @nogc this(float mx, float my) nothrow
	{
		mouseX_ = mx;
		mouseY_ = my;
	}

	/// new mouse x location
	pure @safe @nogc float x() const nothrow { return mouseX_; }
	/// new mouse y location
	pure @safe @nogc float y() const nothrow { return mouseY_; }

	@safe override string toString() const
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
	pure @safe @nogc this(float xoff, float yoff) nothrow
	{
		xOffset_ = xoff;
		yOffset_ = yoff;
	}

	/// xOffset property
	pure @safe @nogc float xOffset() const nothrow { return xOffset_; }
	/// yOffset property
	pure @safe @nogc float yOffset() const nothrow { return yOffset_; }

	@safe override string toString() const
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
	pure @safe @nogc int button() const nothrow { return button_; }    

	mixin EventClassCategory!(EventCategory, EventCategory.Mouse | EventCategory.Input);

	pure @safe @nogc protected this(int btn) nothrow
	{
		button_ = btn;
	}
	
	protected int button_;
}

/// when mouse button is pressed
class MouseButtonPressedEvent : MouseButtonEvent
{
	/// constructor
	pure @safe @nogc this(int btn) nothrow
	{
		super(btn);
	}

	@safe override string toString() const 
	{
		return "MouseButtonPressedEvent: " ~ button_.to!string;
	}

	mixin EventClassType!(EventType, EventType.MouseButtonPressed);
}

/// when mouse button is released
class MouseButtonReleasedEvent : MouseButtonEvent
{
	/// ctor
	pure @safe @nogc this(int btn) nothrow
	{
		super(btn);
	}

	@safe override string toString() const 
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