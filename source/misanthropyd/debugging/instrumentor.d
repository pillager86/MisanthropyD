module misanthropyd.debugging.instrumentor;

import std.format;
import std.stdio;
import std.string;
import core.thread.osthread;
import core.time;

import misanthropyd.core.logger;

struct ProfileResult
{
	string name;
	MonoTime start;
	Duration elapsedTime;
	ThreadID threadID;
}

struct InstrumentationSession
{
	string name;
}

/// drop the file in chrome://tracing/
class Instrumentor
{
	private
	{
		InstrumentationSession* currentSession_ = null;
		File outputFile_;
	}

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
				outputFile_.open(filepath, "w");
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

	void writeProfile(const ProfileResult result)
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

	static Instrumentor get()
	{
		if(instance_ is null)
			instance_ = new shared(Instrumentor)();
		return cast(Instrumentor)instance_;
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

		static shared Instrumentor instance_;
	}
}

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
		Duration elapsedTime = endTimepoint - startTimepoint_;
		ProfileResult result = ProfileResult(name_, startTimepoint_, elapsedTime, thisThreadID);
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
	template MdProfileScope(const string name, int line=__LINE__)
	{
		import std.conv: to;
		const char[] MdProfileScope = "auto timer" ~ line.to!string ~ " = InstrumentationTimer(\"" ~ name ~ "\");"; // @suppress(dscanner.style.phobos_naming_convention)
	}
}
else 
{
	template MdProfileScope(const string name, int line=__LINE__)
	{
		import std.conv: to;
		const char[] mdProfileScope = "";
	}
}