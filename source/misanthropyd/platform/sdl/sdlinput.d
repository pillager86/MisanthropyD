module misanthropyd.platform.sdl.sdlinput;

import bindbc.sdl;

import misanthropyd.core.input;

/// SDL implementation of Input
class SdlInput : Input
{
	override bool isKeyPressedImpl(const int keycode) nothrow @nogc
	{
		immutable scancode = SDL_GetScancodeFromKey(cast(SDL_Keycode)keycode);
		auto keystates = SDL_GetKeyboardState(null);
		return keystates[scancode] != 0;
	}

	override bool isMouseButtonPressedImpl(const int button) nothrow @nogc
	{
		return (SDL_GetMouseState(null, null) & button) != 0;
	}

	override MouseInfo getMousePositionImpl() nothrow @nogc
	{
		int x, y;
		SDL_GetMouseState(&x, &y);
		return MouseInfo(cast(float)x, cast(float)y);
	}
}