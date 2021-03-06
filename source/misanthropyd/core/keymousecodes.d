module misanthropyd.core.keymousecodes;

version (SDL) {
import bindbc.sdl.config,
	   bindbc.sdl.bind.sdlscancode;

/// scancode mask
enum MD_KEY_SCANCODE_MASK = 1<<30;

enum SDL_SCANCODE_TO_KEYCODE(SDL_Scancode x) = x | MD_KEY_SCANCODE_MASK;

/// MisanthropyD keycodes
enum {
	MD_KEY_UNKNOWN = 0,
	MD_KEY_RETURN = '\r',
	MD_KEY_ESCAPE = '\033',
	MD_KEY_BACKSPACE = '\b',
	MD_KEY_TAB = '\t',
	MD_KEY_SPACE = ' ',
	MD_KEY_EXCLAIM = '!',
	MD_KEY_QUOTEDBL = '"',
	MD_KEY_HASH = '#',
	MD_KEY_PERCENT = '%',
	MD_KEY_DOLLAR = '$',
	MD_KEY_AMPERSAND = '&',
	MD_KEY_QUOTE = '\'',
	MD_KEY_LEFTPAREN = '(',
	MD_KEY_RIGHTPAREN = ')',
	MD_KEY_ASTERISK = '*',
	MD_KEY_PLUS = '+',
	MD_KEY_COMMA = ',',
	MD_KEY_MINUS = '-',
	MD_KEY_PERIOD = '.',
	MD_KEY_SLASH = '/',
	MD_KEY_0 = '0',
	MD_KEY_1 = '1',
	MD_KEY_2 = '2',
	MD_KEY_3 = '3',
	MD_KEY_4 = '4',
	MD_KEY_5 = '5',
	MD_KEY_6 = '6',
	MD_KEY_7 = '7',
	MD_KEY_8 = '8',
	MD_KEY_9 = '9',
	MD_KEY_COLON = ':',
	MD_KEY_SEMICOLON = ';',
	MD_KEY_LESS = '<',
	MD_KEY_EQUALS = '=',
	MD_KEY_GREATER = '>',
	MD_KEY_QUESTION = '?',
	MD_KEY_AT = '@',

	MD_KEY_LEFTBRACKET = '[',
	MD_KEY_BACKSLASH = '\\',
	MD_KEY_RIGHTBRACKET = ']',
	MD_KEY_CARET = '^',
	MD_KEY_UNDERSCORE = '_',
	MD_KEY_BACKQUOTE = '`',
	MD_KEY_a = 'a',
	MD_KEY_b = 'b',
	MD_KEY_c = 'c',
	MD_KEY_d = 'd',
	MD_KEY_e = 'e',
	MD_KEY_f = 'f',
	MD_KEY_g = 'g',
	MD_KEY_h = 'h',
	MD_KEY_i = 'i',
	MD_KEY_j = 'j',
	MD_KEY_k = 'k',
	MD_KEY_l = 'l',
	MD_KEY_m = 'm',
	MD_KEY_n = 'n',
	MD_KEY_o = 'o',
	MD_KEY_p = 'p',
	MD_KEY_q = 'q',
	MD_KEY_r = 'r',
	MD_KEY_s = 's',
	MD_KEY_t = 't',
	MD_KEY_u = 'u',
	MD_KEY_v = 'v',
	MD_KEY_w = 'w',
	MD_KEY_x = 'x',
	MD_KEY_y = 'y',
	MD_KEY_z = 'z',

	MD_KEY_CAPSLOCK = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_CAPSLOCK),

	MD_KEY_F1 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_F1),
	MD_KEY_F2 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_F2),
	MD_KEY_F3 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_F3),
	MD_KEY_F4 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_F4),
	MD_KEY_F5 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_F5),
	MD_KEY_F6 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_F6),
	MD_KEY_F7 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_F7),
	MD_KEY_F8 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_F8),
	MD_KEY_F9 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_F9),
	MD_KEY_F10 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_F10),
	MD_KEY_F11 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_F11),
	MD_KEY_F12 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_F12),

	MD_KEY_PRINTSCREEN = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_PRINTSCREEN),
	MD_KEY_SCROLLLOCK = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_SCROLLLOCK),
	MD_KEY_PAUSE = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_PAUSE),
	MD_KEY_INSERT = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_INSERT),
	MD_KEY_HOME = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_HOME),
	MD_KEY_PAGEUP = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_PAGEUP),
	MD_KEY_DELETE = '\177',
	MD_KEY_END = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_END),
	MD_KEY_PAGEDOWN = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_PAGEDOWN),
	MD_KEY_RIGHT = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_RIGHT),
	MD_KEY_LEFT = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_LEFT),
	MD_KEY_DOWN = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_DOWN),
	MD_KEY_UP = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_UP),

	MD_KEY_NUMLOCKCLEAR = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_NUMLOCKCLEAR),
	MD_KEY_KP_DIVIDE = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_DIVIDE),
	MD_KEY_KP_MULTIPLY = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_MULTIPLY),
	MD_KEY_KP_MINUS = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_MINUS),
	MD_KEY_KP_PLUS = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_PLUS),
	MD_KEY_KP_ENTER = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_ENTER),
	MD_KEY_KP_1 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_1),
	MD_KEY_KP_2 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_2),
	MD_KEY_KP_3 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_3),
	MD_KEY_KP_4 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_4),
	MD_KEY_KP_5 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_5),
	MD_KEY_KP_6 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_6),
	MD_KEY_KP_7 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_7),
	MD_KEY_KP_8 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_8),
	MD_KEY_KP_9 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_9),
	MD_KEY_KP_0 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_0),
	MD_KEY_KP_PERIOD = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_PERIOD),

	MD_KEY_APPLICATION = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_APPLICATION),
	MD_KEY_POWER = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_POWER),
	MD_KEY_KP_EQUALS = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_EQUALS),
	MD_KEY_F13 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_F13),
	MD_KEY_F14 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_F14),
	MD_KEY_F15 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_F15),
	MD_KEY_F16 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_F16),
	MD_KEY_F17 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_F17),
	MD_KEY_F18 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_F18),
	MD_KEY_F19 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_F19),
	MD_KEY_F20 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_F20),
	MD_KEY_F21 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_F21),
	MD_KEY_F22 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_F22),
	MD_KEY_F23 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_F23),
	MD_KEY_F24 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_F24),
	MD_KEY_EXECUTE = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_EXECUTE),
	MD_KEY_HELP = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_HELP),
	MD_KEY_MENU = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_MENU),
	MD_KEY_SELECT = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_SELECT),
	MD_KEY_STOP = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_STOP),
	MD_KEY_AGAIN = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_AGAIN),
	MD_KEY_UNDO = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_UNDO),
	MD_KEY_CUT = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_CUT),
	MD_KEY_COPY = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_COPY),
	MD_KEY_PASTE = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_PASTE),
	MD_KEY_FIND = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_FIND),
	MD_KEY_MUTE = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_MUTE),
	MD_KEY_VOLUMEUP = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_VOLUMEUP),
	MD_KEY_VOLUMEDOWN = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_VOLUMEDOWN),
	MD_KEY_KP_COMMA = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_COMMA),
	MD_KEY_KP_EQUALSAS400 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_EQUALSAS400),

	MD_KEY_ALTERASE = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_ALTERASE),
	MD_KEY_SYSREQ = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_SYSREQ),
	MD_KEY_CANCEL = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_CANCEL),
	MD_KEY_CLEAR = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_CLEAR),
	MD_KEY_PRIOR = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_PRIOR),
	MD_KEY_RETURN2 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_RETURN2),
	MD_KEY_SEPARATOR = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_SEPARATOR),
	MD_KEY_OUT = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_OUT),
	MD_KEY_OPER = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_OPER),
	MD_KEY_CLEARAGAIN = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_CLEARAGAIN),
	MD_KEY_CRSEL = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_CRSEL),
	MD_KEY_EXSEL = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_EXSEL),

	MD_KEY_KP_00 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_00),
	MD_KEY_KP_000 = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_000),
	MD_KEY_THOUSANDSSEPARATOR = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_THOUSANDSSEPARATOR),
	MD_KEY_DECIMALSEPARATOR = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_DECIMALSEPARATOR),
	MD_KEY_CURRENCYUNIT = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_CURRENCYUNIT),
	MD_KEY_CURRENCYSUBUNIT = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_CURRENCYSUBUNIT),
	MD_KEY_KP_LEFTPAREN = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_LEFTPAREN),
	MD_KEY_KP_RIGHTPAREN = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_RIGHTPAREN),
	MD_KEY_KP_LEFTBRACE = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_LEFTBRACE),
	MD_KEY_KP_RIGHTBRACE = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_RIGHTBRACE),
	MD_KEY_KP_TAB = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_TAB),
	MD_KEY_KP_BACKSPACE = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_BACKSPACE),
	MD_KEY_KP_A = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_A),
	MD_KEY_KP_B = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_B),
	MD_KEY_KP_C = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_C),
	MD_KEY_KP_D = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_D),
	MD_KEY_KP_E = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_E),
	MD_KEY_KP_F = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_F),
	MD_KEY_KP_XOR = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_XOR),
	MD_KEY_KP_POWER = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_POWER),
	MD_KEY_KP_PERCENT = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_PERCENT),
	MD_KEY_KP_LESS = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_LESS),
	MD_KEY_KP_GREATER = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_GREATER),
	MD_KEY_KP_AMPERSAND = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_AMPERSAND),
	MD_KEY_KP_DBLAMPERSAND = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_DBLAMPERSAND),
	MD_KEY_KP_VERTICALBAR = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_VERTICALBAR),
	MD_KEY_KP_DBLVERTICALBAR = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_DBLVERTICALBAR),
	MD_KEY_KP_COLON = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_COLON),
	MD_KEY_KP_HASH = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_HASH),
	MD_KEY_KP_SPACE = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_SPACE),
	MD_KEY_KP_AT = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_AT),
	MD_KEY_KP_EXCLAM = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_EXCLAM),
	MD_KEY_KP_MEMSTORE = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_MEMSTORE),
	MD_KEY_KP_MEMRECALL = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_MEMRECALL),
	MD_KEY_KP_MEMCLEAR = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_MEMCLEAR),
	MD_KEY_KP_MEMADD = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_MEMADD),
	MD_KEY_KP_MEMSUBTRACT = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_MEMSUBTRACT),
	MD_KEY_KP_MEMMULTIPLY = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_MEMMULTIPLY),
	MD_KEY_KP_MEMDIVIDE = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_MEMDIVIDE),
	MD_KEY_KP_PLUSMINUS = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_PLUSMINUS),
	MD_KEY_KP_CLEAR = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_CLEAR),
	MD_KEY_KP_CLEARENTRY = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_CLEARENTRY),
	MD_KEY_KP_BINARY = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_BINARY),
	MD_KEY_KP_OCTAL = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_OCTAL),
	MD_KEY_KP_DECIMAL = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_DECIMAL),
	MD_KEY_KP_HEXADECIMAL = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KP_HEXADECIMAL),

	MD_KEY_LCTRL = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_LCTRL),
	MD_KEY_LSHIFT = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_LSHIFT),
	MD_KEY_LALT = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_LALT),
	MD_KEY_LGUI = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_LGUI),
	MD_KEY_RCTRL = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_RCTRL),
	MD_KEY_RSHIFT = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_RSHIFT),
	MD_KEY_RALT = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_RALT),
	MD_KEY_RGUI = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_RGUI),

	MD_KEY_MODE = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_MODE),

	MD_KEY_AUDIONEXT = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_AUDIONEXT),
	MD_KEY_AUDIOPREV = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_AUDIOPREV),
	MD_KEY_AUDIOSTOP = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_AUDIOSTOP),
	MD_KEY_AUDIOPLAY = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_AUDIOPLAY),
	MD_KEY_AUDIOMUTE = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_AUDIOMUTE),
	MD_KEY_MEDIASELECT = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_MEDIASELECT),
	MD_KEY_WWW = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_WWW),
	MD_KEY_MAIL = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_MAIL),
	MD_KEY_CALCULATOR = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_CALCULATOR),
	MD_KEY_COMPUTER = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_COMPUTER),
	MD_KEY_AC_SEARCH = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_AC_SEARCH),
	MD_KEY_AC_HOME = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_AC_HOME),
	MD_KEY_AC_BACK = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_AC_BACK),
	MD_KEY_AC_FORWARD = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_AC_FORWARD),
	MD_KEY_AC_STOP = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_AC_STOP),
	MD_KEY_AC_REFRESH = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_AC_REFRESH),
	MD_KEY_AC_BOOKMARKS = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_AC_BOOKMARKS),

	MD_KEY_BRIGHTNESSDOWN = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_BRIGHTNESSDOWN),
	MD_KEY_BRIGHTNESSUP = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_BRIGHTNESSUP),
	MD_KEY_DISPLAYSWITCH = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_DISPLAYSWITCH),
	MD_KEY_KBDILLUMTOGGLE = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KBDILLUMTOGGLE),
	MD_KEY_KBDILLUMDOWN = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KBDILLUMDOWN),
	MD_KEY_KBDILLUMUP = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_KBDILLUMUP),
	MD_KEY_EJECT = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_EJECT),
	MD_KEY_SLEEP = SDL_SCANCODE_TO_KEYCODE!(SDL_Scancode.SDL_SCANCODE_SLEEP),
}

enum {
	MD_KMOD_NONE = 0x0000,
	MD_KMOD_LSHIFT = 0x0001,
	MD_KMOD_RSHIFT = 0x0002,
	MD_KMOD_LCTRL = 0x0040,
	MD_KMOD_RCTRL = 0x0080,
	MD_KMOD_LALT = 0x0100,
	MD_KMOD_RALT = 0x0200,
	MD_KMOD_LGUI = 0x0400,
	MD_KMOD_RGUI = 0x0800,
	MD_KMOD_NUM = 0x1000,
	MD_KMOD_CAPS = 0x2000,
	MD_KMOD_MODE = 0x4000,
	MD_KMOD_RESERVED = 0x8000,

	MD_KMOD_CTRL = (MD_KMOD_LCTRL|MD_KMOD_RCTRL),
	MD_KMOD_SHIFT = (MD_KMOD_LSHIFT|MD_KMOD_RSHIFT),
	MD_KMOD_ALT = (MD_KMOD_LALT|MD_KMOD_RALT),
	MD_KMOD_GUI = (MD_KMOD_LGUI|MD_KMOD_RGUI),
}

enum SDL_BUTTON(ubyte x) = 1 << (x-1);

enum : ubyte {
	/// left mouse button
	MD_MB_LEFT = 1,
	/// middle mouse button
	MD_MB_MIDDLE = 2,
	/// right mouse button
	MD_MB_RIGHT = 3,
	/// unknown
	MD_MB_X1 = 4,
	/// unknown
	MD_MB_X2 = 5,
	/// unknown
	MD_MB_LMASK = SDL_BUTTON!(MD_MB_LEFT),
	/// unknown
	MD_MB_MMASK = SDL_BUTTON!(MD_MB_MIDDLE),
	/// unknown
	MD_MB_RMASK = SDL_BUTTON!(MD_MB_RIGHT),
	/// unknown
	MD_MB_X1MASK = SDL_BUTTON!(MD_MB_X1),
	/// unknown
	MD_MB_X2MASK = SDL_BUTTON!(MD_MB_X2),
}


}