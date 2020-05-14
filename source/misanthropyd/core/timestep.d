module misanthropyd.core.timestep;

/// implements time step
struct Timestep
{
	float getSeconds() const nothrow pure @nogc @safe { return time; }
	float getMilliseconds() const nothrow pure @nogc @safe { return time * 1000.0f; }
	/// time stored in seconds
	float time;
}