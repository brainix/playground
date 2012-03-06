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


" Save our left pinkies!  In Normal mode, map the semicolon to the colon (to
" switch to Command-line mode).  This prevents us from having to press the
" left shift key to type a colon.
nmap ; :


" Don't clutter our filesystems!  Keep all backup and swap files in one place.
" These directories must exist - Vim does not create them for us.
set backupdir=~/.vim/backup
set directory=~/.vim/tmp


" When a file is changed outside of Vim but hasn't been changed inside of Vim,
" automatically read the file again.
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


" Whenever we save our ~/.vimrc files, automatically reload our configuration
" changes.
autocmd BufWritePost ~/.vimrc source ~/.vimrc


" We're on a fast terminal connection, so send more characters for smoother
" redrawing.
set ttyfast


set background=dark
set ruler
syntax on
set nowrap
