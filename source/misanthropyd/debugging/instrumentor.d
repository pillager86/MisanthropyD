module misanthropyd.debugging.instrumentor;

import std.format;
import std.stdio;
import std.string;
import core.thread.osthread;
import core.time;

import misanthropyd.core.logger;

private struct ProfileResult
{
	string name;
	MonoTime start;
	Duration elapsedTime;
	ThreadID threadID;
}

private struct InstrumentationSession
{
	string name;
}

/// drop the resulting json file into chrome://tracing/
class Instrumentor
{
	private
	{
		InstrumentationSession* currentSession_ = null;
		File outputFile_;
	}

	/**
	 * This should be called before declaring any InstrumentationTimer variables.
	 * Params:
	 *	name = the name of the section of the program being profiled.
	 *  filepath = where the results of this profile section should be stored
	 */
	void beginSession(const string name, const string filepath = "results.json")
	{
		version(profiling)
		{
			synchronized
			{
				if(currentSession_ != null)
				{
					Logger.logf(Logger.Severity.ERROR, "Begin %s when session %s already open.", 
								name, currentSession_.name);
				}
				outputFile_.open(filepath, "w"); // this is supposed to delete the old file each time?
				if(outputFile_.isOpen)
				{
					currentSession_ = new InstrumentationSession(name);
					writeHeader();
				}
				else
				{
					Logger.logf(Logger.Severity.ERROR, "Instrumentor could not open file %s", filepath);
				}
			}
		}
	}

	/**
	 * This should be called to close any session started by beginSession. beginSession...endSession calls
	 * cannot be nested.
	 */
	void endSession()
	{
		version(profiling)
		{
			synchronized
			{
				internalEndSession();
			}
		}
	}

	package void writeProfile(const ProfileResult result)
	{
		version(profiling)
		{
			import std.conv: to;
			string json;
			string name = result.name.replace('"', '\'');
			json ~= ",{";
			json ~= "\"cat\":\"function\",";
			json ~= "\"dur\":" ~ result.elapsedTime.total!"usecs".to!string ~ ",";
			json ~= "\"name\":\"" ~ name ~ "\",";
			json ~= "\"ph\":\"X\",";
			json ~= "\"pid\":0,";
			json ~= "\"tid\":" ~ result.threadID.to!string ~ ",";
			// immutable TPS = result.start.ticksPerSecond;
			// Logger.logf(Logger.Severity.WARNING, "TicksPerSecond: %s", TPS);
			// TODO: We need to calculate the '1000' here due to platform variance
			json ~= "\"ts\":" ~ (result.start.ticks / 1000).to!string;
			json ~= "}";

			synchronized
			{
				if(currentSession_ != null)
				{
					outputFile_.write(json);
					outputFile_.flush();
				}
			}
		}
	}

	/// Returns the singleton instance of the class.
	static Instrumentor get()
	{
		synchronized
		{
			if(instance_ is null)
				instance_ = new shared(Instrumentor)();
			return cast(Instrumentor)instance_;
		}
	}

	private
	{
		void writeHeader()
		{
			version(profiling)
			{
				outputFile_.write("{\"otherData\": {},\"traceEvents\":[{}");
				outputFile_.flush();
			}
		}

		void writeFooter()
		{
			version(profiling)
			{
				outputFile_.write("]}");
				outputFile_.flush();
			}
		}

		void internalEndSession()
		{
			version(profiling)
			{
				if(currentSession_ != null)
				{
					writeFooter();
					outputFile_.close();
					destroy(currentSession_);
					currentSession_ = null;
				}
			}
		}

		// this is a singleton
		shared this() {}
		this() {}

		static shared Instrumentor instance_;
	}
}

/** Scope lifetime variable to be declared at top of function to profile. There is no need to use this
 *  directly. See the template MdProfileScope below.
 */
struct InstrumentationTimer
{
	this(const string name)
	{
		name_ = name;
		stopped_ = false;
		startTimepoint_ = MonoTime.currTime();
	}

	~this()
	{
		if(!stopped_) stop();
	}

	void stop()
	{
		import std.process: thisThreadID;
		immutable endTimepoint = MonoTime.currTime();
		auto elapsedTime = endTimepoint - startTimepoint_;
		auto result = ProfileResult(name_, startTimepoint_, elapsedTime, thisThreadID);
		Instrumentor.get.writeProfile(result);
		stopped_ = true;
	}

	private
	{
		string name_;
		MonoTime startTimepoint_;
		bool stopped_;
	}
}

version(profiling)
{
	/** use mixin(MdProfileScope!(\_\_PRETTY_FUNCTION\_\_)); at the top of functions to profile. This can only
	 * be done between Instrumentor.get.beginSession and Instrumentor.get.endSession calls.
	 */
	template MdProfileScope(const string name, int line=__LINE__)
	{
		import std.conv: to;
		const char[] MdProfileScope = "auto timer" ~ line.to!string ~ " = InstrumentationTimer(\"" ~ name ~ "\");"; // @suppress(dscanner.style.phobos_naming_convention)
	}
}
else 
{
	// this has no effect if profiling is not enabled
	template MdProfileScope(const string name, int line=__LINE__)
	{
		const char[] MdProfileScope = ""; // @suppress(dscanner.style.phobos_naming_convention)
	}
}