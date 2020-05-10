module misanthropyd.events.event;

/// Type of event
enum EventType
{
	None = 0,
	WindowClose, WindowResize, WindowFocus, WindowLostFocus, WindowMoved,
	AppTick, AppUpdate, AppRender, KeyPressed, KeyReleased, TextInput,
	MouseButtonPressed, MouseButtonReleased, MouseMoved, MouseScrolled
}

/// Category of event (can be multiple categories)
enum EventCategory
{
	None = 0,
	Application     = 1<<0,
	Input           = 1<<1,
	Keyboard        = 1<<2,
	Mouse           = 1<<3,
	MouseButton     = 1<<4
}

/// helpful mixin for defining properties of Event subclasses
mixin template EventClassType(T : EventType, EventType et)
{
	import std.conv: to;
	pure @safe @nogc static T getStaticType() nothrow { return et; }
	pure @safe @nogc override EventType eventType() const nothrow { return getStaticType; }
	pure @safe override string name() const { return et.to!string; }
}

/// helpful mixin for defining categories of Event subclass
mixin template EventClassCategory(T : EventCategory, EventCategory category) 
{
	pure @safe @nogc override int categoryFlags() const nothrow { return category; }
}

/// base class for all events
abstract class Event 
{
	/// each subclass must define this
	EventType eventType();
	/// name of event
	string name() const;
	/// what categories the event is in
	int categoryFlags() const;
	/// subclasses should override to contain more useful info
	override string toString() const { return name; } 
	/// tests if event is in categories
	bool isInCategory(const EventCategory cat) { return (categoryFlags & cat) != 0; }

	/// handled property
	pure @safe @nogc bool handled() nothrow { return handled_; }

	package
	{
		/// handled property
		pure @safe @nogc bool handled(bool h) nothrow { return handled_ = h; }
	}
	protected bool handled_ = false;
}

/// dispatches events
struct EventDispatcher 
{
	/// callback for event handler
	template EventFn(T : Event)
	{
		alias EventFn = bool delegate(T);
	}

	/// ctor
	pure @safe @nogc this(Event event) nothrow
	{
		event_ = event;
	}

	/// dispatches event to callback
	bool dispatch(T : Event)(EventFn!T func)
	{
		if(event_.eventType == T.getStaticType)
		{
			event_.handled = func(cast(T)event_);
			return true;
		}
		return false;
	}

	private Event event_;
}
