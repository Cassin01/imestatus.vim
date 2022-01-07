scriptencoding utf-8

if !exists('g:loaded_imestatus')
  finish
else
  let g:loaded_imestatus = 1
endif

let s:save_cpo = &cpo
set cpo&vim

function! imestatus#imestatus_init()
let s:script_dir = fnamemodify(resolve(expand('<sfile>', ':p')), ':h')
augroup IMEInsert
    autocmd InsertCharPre * :call s:currentIME()
augroup END
endfunction
    " Show current IME status on cursor color. {{{

function! s:currentIME()
py3 << EOF
import vim
script_dir = vim.eval('s:script_dir')
sys.path.insert(0, script_dir)
import ime
vim.command("let s:ime_result = %d" % int(ime.current_ime()))
EOF
let s:capstatus = system('xset -q | grep "Caps Lock" | awk ''{print $4}''')
if s:capstatus[0:-2] == 'on'
    echom 'called'
    highlight iCursor guibg=#8F1D21
    set guicursor+=i:ver25-iCursor
elseif s:ime_result == 0
    highlight iCursor guibg=#cc6666
    set guicursor+=i:ver25-iCursor
else
    highlight iCursor guibg=#5FAFFF
    set guicursor+=i:ver25-iCursor
endif
endfunction
    "}}}


let &cpo = s:save_cpo
unlet s:save_cpo
