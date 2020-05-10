module misanthropyd.platform.sdl.sdlinput;

import bindbc.sdl;

import misanthropyd.core.input;

/// SDL implementation of Input
class SdlInput : Input
{
    @nogc override bool isKeyPressedImpl(const int keycode) nothrow
    {
        immutable scancode = SDL_GetScancodeFromKey(cast(SDL_Keycode)keycode);
        auto keystates = SDL_GetKeyboardState(null);
        return keystates[scancode] != 0;
    }

    @nogc override bool isMouseButtonPressedImpl(const int button) nothrow
    {
        return (SDL_GetMouseState(null, null) & button) != 0;
    }

    @nogc override MouseInfo getMousePositionImpl() nothrow
    {
        int x, y;
        SDL_GetMouseState(&x, &y);
        return MouseInfo(cast(float)x, cast(float)y);
    }
}