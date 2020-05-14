module misanthropyd.events.keyevent;

import misanthropyd.events.event;

import std.conv: to;

/// base class for keyboard events
abstract class KeyEvent : Event
{
	/// key code property
	int keyCode() const nothrow pure @nogc @safe { return keyCode_; }
	int keyMods() const nothrow pure @nogc @safe { return keyMods_; }

	mixin EventClassCategory!(EventCategory, EventCategory.Keyboard | EventCategory.Input);

	protected 
	{
		/// constructor
		this(int keycode, int keymods) nothrow pure @nogc @safe
		{ 
			keyCode_ = keycode; 
			keyMods_ = keymods;
		}

		/// keycodes
		int keyCode_;
		int keyMods_;
	}
}

/// for when a key is pressed
class KeyPressedEvent : KeyEvent
{
	/// constructor
	this(int keycode, int keymods, int rCount) nothrow pure @nogc @safe
	{
		super(keycode, keymods);
		repeatCount_ = rCount;
	}

	/// repeat count property
	int repeatCount() const nothrow pure @nogc @safe { return repeatCount_; }

	override string toString() const @safe
	{
		return "KeyPressedEvent: " ~ keyCode_.to!string ~ " (" ~ repeatCount_.to!string ~ " repeats)";
	}

	mixin EventClassType!(EventType, EventType.KeyPressed);

	private int repeatCount_;
}

/// when keyboard button is released
class KeyReleasedEvent : KeyEvent
{
	/// ctor
	this(int keycode, int keymods) nothrow pure @nogc @safe { super(keycode, keymods); }

	override string toString() const @safe
	{
		return "KeyReleasedEvent: " ~ keyCode_.to!string;
	}

	mixin EventClassType!(EventType, EventType.KeyReleased);
}

/// when character is typed such as on international keyboard
class TextInputEvent : Event 
{
	/// ctor
	this(string txt) nothrow pure @nogc @safe
	{
		text_ = txt;
	}

	/// text property
	string text() const nothrow pure @nogc @safe { return text_; }

	mixin EventClassCategory!(EventCategory, EventCategory.Keyboard | EventCategory.Input);
	mixin EventClassType!(EventType, EventType.TextInput);

	private 
	{
		string text_;
	}
}

unittest
{
	assert(KeyPressedEvent.getStaticType == EventType.KeyPressed);
	assert(KeyReleasedEvent.getStaticType == EventType.KeyReleased);
	assert(TextInputEvent.getStaticType == EventType.TextInput);
}