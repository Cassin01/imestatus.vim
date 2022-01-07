import subprocess
import plistlib
from pathlib import Path

HIRIGANA="com.apple.inputmethod.Japanese"
KATANA="com.apple.inputmethod.Japanese.Katakana"
ROMAN="com.apple.inputmethod.Roman"

def current_ime():
    home = Path.home()
    str_plist_path = ('Library/Preferences/com.apple.HIToolbox.plist')
    path = Path(str_plist_path)
    with open(home / path, 'rb') as fp:
        pl = plistlib.load(fp)

    # print(pl["AppleSelectedInputSources"][1]['Input Mode'])
    try:
        ime = pl["AppleSelectedInputSources"][1]['Input Mode']
        if ime == ROMAN:
            return 1
        else:
            return 0
    except Exception:
        print(pl["AppleSelectedInputSources"])
        return 0
