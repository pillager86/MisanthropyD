module misanthropyd.core.options;

import std.string;

/// implements command line options globally
class Options
{
	static void initialize(const string[] args)
	{
		foreach(arg ; args)
		{
			// does it start with --
			if(arg.startsWith("--"))
			{
				immutable string pair = arg[2 .. $];
				immutable equalSign = pair.indexOf('=');
				string key, value;
				if(equalSign == -1)
				{
					key = pair[2 .. $];
					value = "true";
				}
				else
				{
					key = pair[2..equalSign];
					value = pair[equalSign+1 .. $];
				}
				parameterMap_[key] = value;
			}
		}
	}

	static const(string) get(const string key)
	{
		if(!cast(bool)(key in parameterMap_))
			return "";
		return parameterMap_[key];
	}

	private
	{
		static shared string[string] parameterMap_;
	}
}
