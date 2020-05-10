module misanthropyd.core.logger;

import std.conv: to;
import std.datetime;
import std.format;
import std.stdio;

/// implements logging with colored text
class Logger
{
	/// Severity of message
	enum Severity { TRACE, INFO, WARNING, ERROR, FATAL }

	/// logs formatted colored text to stderr or stdout
	static void logf(int line=__LINE__, string file=__FILE__, T...)(const Severity sev, T args)
	{
		DateTime dt = cast(DateTime)Clock.currTime();
		string text = dt.toString ~ "@" ~ file ~ ":" ~ line.to!string ~ " " ~ format(args);
		final switch(sev)
		{
		case Severity.TRACE:
			stdout.writeln("[TRACE]", text);
			break;
		case Severity.INFO:
			stdout.writeln("\u001b[32m[INFO]", text, "\u001b[0m");
			break;
		case Severity.WARNING:
			stderr.writeln("\u001b[36m[WARNING]", text, "\u001b[0m");
			break;
		case Severity.ERROR:
			stderr.writeln("\u001b[33m[ERROR]", text, "\u001b[0m");
			break;
		case Severity.FATAL:
			stderr.writeln("\u001b[31m[FATAL]", text, "\u001b[0m");
			assert(0);
		}
	}
}

unittest 
{
	Logger.logf(Logger.Severity.TRACE, "Trace test");
	Logger.logf(Logger.Severity.INFO, "Info test");
	Logger.logf(Logger.Severity.WARNING, "Warn test");
	Logger.logf(Logger.Severity.ERROR, "Error test");
	// Logger.logf(Logger.Severity.FATAL, "Fatal test");
}