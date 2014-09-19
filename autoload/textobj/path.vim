" textobj-path - Text objects for file paths
" Version: 0.0.1
" Copyright (C) 2014 Yu Huang
" License: So-called MIT/X license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}

let s:textobj_path_regex_i = '\(\/\([0-9a-zA-Z_\-\.]\+\)\)\+'
let s:textobj_path_regex_a = '\(\/\([0-9a-zA-Z_\-\.]\+\)\)\+\s*'

" Interface  "{{{1
function! textobj#path#select_ap()  "{{{2
  let l:ret = s:MatchNextPath(s:textobj_path_regex_a)
  if len(l:ret) == 0
    return 0
  else
    return l:ret
  endif
endfunction

function! textobj#path#select_ip()  "{{{2
  let l:ret = s:MatchNextPath(s:textobj_path_regex_i)
  if len(l:ret) == 0
    return 0
  else
    return l:ret
  endif
endfunction

function! s:MatchNextPath(regex)  "{{{2
  if empty(getline('.'))
    return []
  endif

  let l:orig_pos = getpos(".")

  " Search backward for the first whitespace character in current line and use
  " that as the starting point for search. Stay where the cursor is if not found
  let l:head = search('[^0-9a-zA-Z_\-\.\/]\/[^\/]\|^\/[^\/]', 'bcW', line("."), 100)
  let l:start = getpos(".")
  call setpos('.', l:start)

  let l:ret = s:SearchPattern(a:regex)
  if len(l:ret) == 0
    return []
  endif

  if l:ret[1][2] < l:orig_pos[2]
    let l:ret = s:SearchPattern(a:regex)
    if len(l:ret) == 0
      return []
    endif
  endif

  return ['v', l:ret[0], l:ret[1]]
endfunction

function! textobj#path#select_aP()  "{{{2
  let l:ret = s:MatchPrevPath(s:textobj_path_regex_a)
  if len(l:ret) == 0
    return 0
  else
    return l:ret
  endif
endfunction

function! textobj#path#select_iP()  "{{{2
  let l:ret = s:MatchPrevPath(s:textobj_path_regex_i)
  if len(l:ret) == 0
    return 0
  else
    return l:ret
  endif
endfunction

function! s:MatchPrevPath(regex)  "{{{2
  " Search backward for the first whitespace character in current line and use
  " that as the starting point for search. Stay where the cursor is if not found
  let l:head = search('[^0-9a-zA-Z_\-\.\/]\/[^\/]\|^\/[^\/]', 'bcW', line("."), 100)
  if l:head == 0
    return []
  endif

  let l:ret = s:SearchPattern(a:regex)
  if len(l:ret) == 0
    return []
  endif

  return ['v', l:ret[0], l:ret[1]]
endfunction

function! s:SearchPattern(regex)  "{{{2
  let [l:line, l:head] = searchpos(a:regex, 'cW', line("."), 100)
  if l:head == 0
    return []
  endif
  call cursor(l:line, l:head)
  let l:begin = getpos(".")

  let [l:line, l:tail] = searchpos(a:regex, 'ceW', line("."), 100)
  call cursor(l:line, l:tail)
  let l:end = getpos(".")
  return [l:begin, l:end]
endfunction

" __END__  "{{{1
" vim: foldmethod=marker
