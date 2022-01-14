scriptencoding utf-8

if !exists('g:loaded_imestatus')
  finish
else
  let g:loaded_imestatus = 1
endif

let s:save_cpo = &cpo
set cpo&vim

" Show current IME status on cursor color. {{{
function! s:currentIME(timer)
py3 << EOF
import vim
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

    if len(pl["AppleSelectedInputSources"]) == 2:
        ime = pl["AppleSelectedInputSources"][1]['Input Mode']
        if ime == ROMAN:
            return 1
        else:
            return 0
    else: # have not been reflected on the file. I treat as NOT ROMAN
        print(pl["AppleSelectedInputSources"])
        return 0

vim.command("let s:ime_result = %d" % int(current_ime()))
EOF
let s:capstatus = system('xset -q | grep "Caps Lock" | awk ''{print $4}''')
if s:capstatus[0:-2] == 'on'            " caps red
    echom 'called'
    " highlight iCursor guibg=#8F1D21
    highlight iCursor guibg=#c94449
    set guicursor=i:ver25-iCursor
elseif s:ime_result == 0                " kana orange
    highlight iCursor guibg=#cc6666
    set guicursor=i:ver25-iCursor
else                                    " roman steelblue
    highlight iCursor guibg=#5FAFFF
    set guicursor=i:ver25-iCursor
endif
echo "hogehogehoge"
endfunction
    "}}}

    call timer_start(1000, function("s:currentIME"))

function! imestatus#imestatus_init()
" augroup IMEInsert
"     autocmd CursorHoldI,InsertCharPre * :call s:currentIME()
"     " set updatetime=10
" augroup END

" TODO:
" Vim の +timer を使ってみる
" https://secret-garden.hatenablog.com/entry/2016/07/11/222728
" 3000ミリ秒後に Disp() を呼び出す
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
