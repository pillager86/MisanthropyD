module misanthropyd.events.applicationevent;

import std.conv: to;

import misanthropyd.events.event;

/// event triggered by window resizing
class WindowResizeEvent : Event 
{
	/// constructor, takes new width and height of window
	this(const uint w, const uint h) pure nothrow @nogc @safe
	{
		width_ = w;
		height_ = h;
	}

	/// returns width data of resize event
	uint width() const pure nothrow @nogc @safe { return width_; }
	/// returns height data of resize event
	uint height() const pure nothrow @nogc @safe { return height_; }
	/// creates a string containing window resize data
	override string toString() const pure @safe 
	{
		return "WindowResizeEvent: " ~ width_.to!string ~ ", " ~ height_.to!string;
	}

	mixin EventClassType!(EventType, EventType.WindowResize);
	mixin EventClassCategory!(EventCategory, EventCategory.Application);

	private uint width_, height_;
}

/// event when window is closed
class WindowCloseEvent : Event 
{
	mixin EventClassType!(EventType, EventType.WindowClose);
	mixin EventClassCategory!(EventCategory, EventCategory.Application);
}

unittest
{
	assert(WindowResizeEvent.getStaticType == EventType.WindowResize);
	assert(WindowCloseEvent.getStaticType == EventType.WindowClose);
}