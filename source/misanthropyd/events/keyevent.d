module misanthropyd.events.keyevent;

import misanthropyd.events.event;

import std.conv: to;

/// base class for keyboard events
abstract class KeyEvent : Event
{
	/// key code property
	pure @safe @nogc int keyCode() const nothrow { return keyCode_; }
	pure @safe @nogc int keyMods() const nothrow { return keyMods_; }

	mixin EventClassCategory!(EventCategory, EventCategory.Keyboard | EventCategory.Input);

	protected 
	{
		/// constructor
		pure @safe @nogc this(int keycode, int keymods) nothrow 
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
	pure @safe @nogc this(int keycode, int keymods, int rCount) nothrow
	{
		super(keycode, keymods);
		repeatCount_ = rCount;
	}

	/// repeat count property
	pure @safe @nogc int repeatCount() const nothrow { return repeatCount_; }

	@safe override string toString() const
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
	pure @safe @nogc this(int keycode, int keymods) nothrow { super(keycode, keymods); }

	@safe override string toString() const 
	{
		return "KeyReleasedEvent: " ~ keyCode_.to!string;
	}

	mixin EventClassType!(EventType, EventType.KeyReleased);
}

/// when character is typed such as on international keyboard
class TextInputEvent : Event 
{
	/// ctor
	pure @safe @nogc this(string txt) nothrow 
	{
		text_ = txt;
	}

	/// text property
	pure @safe @nogc string text() const nothrow { return text_; }

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