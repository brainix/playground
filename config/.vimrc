"----------------------------------------------------------------------------"
"   .vimrc                                                                   "
"                                                                            "
"   Copyright (c) 2012, Rajiv Bakulesh Shah, original author.                "
"                                                                            "
"       This file is free software; you can redistribute it and/or modify    "
"       it under the terms of the GNU General Public License as published    "
"       by the Free Software Foundation, either version 3 of the License,    "
"       or (at your option) any later version.                               "
"                                                                            "
"       This file is distributed in the hope that it will be useful, but     "
"       WITHOUT ANY WARRANTY; without even the implied warranty of           "
"       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU    "
"       General Public License for more details.                             "
"                                                                            "
"       You should have received a copy of the GNU General Public License    "
"       along with this file.  If not, see:                                  "
"           <http://www.gnu.org/licenses/>.                                  "
"----------------------------------------------------------------------------"


" Save our left pinky!  Map the semicolon to the colon in Normal mode (to
" switch to Command-line mode).  This prevents us from having to press the
" left shift key to type a colon.
nmap ; :


" Keep the backup files and the swap files in one place, so that we don't
" clutter our filesystem.  These directories must exist - Vim will not create
" them for us.
set backupdir=~/.vim/backup
set directory=~/.vim/tmp


" When a file has been detected to have been changed outside of Vim and it has
" not been changed inside of Vim, automatically read it again.
set autoread


" Enable file type detection, load the plugins for specific file types, and
" load the indent files for specific file types.
filetype on
filetype plugin on
filetype indent on


" Configure sane tab behavior...
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set smarttab
set autoindent


" ...except when editing Ruby files.  ;-)  When editing Ruby files, use two
" spaces for tabs.
autocmd FileType ruby setlocal shiftwidth=2
autocmd FileType ruby setlocal softtabstop=2
autocmd FileType ruby setlocal tabstop=2


" Allow backspacing over autoindents, line breaks, and the starts of inserts.
set backspace=indent,eol,start


" Automatically reload .vimrc whenever it's saved.
autocmd BufWritePost ~/.vimrc source ~/.vimrc


" We're on a fast terminal connection, so send more characters for smoother
" redrawing.
set ttyfast


set background=dark
set ruler
syntax on
set nowrap
