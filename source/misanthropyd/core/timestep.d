module misanthropyd.core.timestep;

/// implements time step
struct Timestep
{
	float getSeconds() const { return time; }
	float getMilliseconds() const { return time * 1000.0f; }
	/// time stored in seconds
	float time;
}