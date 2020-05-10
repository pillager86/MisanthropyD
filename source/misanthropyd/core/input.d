module misanthropyd.core.input;

import std.typecons;

/// tests input state
abstract class Input
{
	alias MouseInfo = Tuple!(float, "x", float, "y");

	/// tests if a key is pressed
	static bool isKeyPressed(const int keycode) 
	{ 
		return input_.isKeyPressedImpl(keycode); 
	}

	/// tests if a certain mouse button is pressed
	static bool isMouseButtonPressed(const int button)
	{
		return input_.isMouseButtonPressedImpl(button);
	}

	/// get mouse position
	static MouseInfo getMousePosition()
	{
		return input_.getMousePositionImpl();
	}

	protected
	{
		static this()
		{
			version(SDL)
			{
				import misanthropyd.platform.sdl.sdlinput : SdlInput;
				input_ = new SdlInput;
			}
			else
			{
				static assert(false, "Only SDL is available for input!");
			}
		}

		bool isKeyPressedImpl(const int keycode);
		bool isMouseButtonPressedImpl(const int button);
		MouseInfo getMousePositionImpl();
		static Input input_;
	}
}