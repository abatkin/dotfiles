function! FormatTableLine(line)
	let curr_line = a:line

	" Get rid of all leading or trailing spaces
	let curr_line = substitute(curr_line, '^[ ]\{1,\}\|[ ]\{1,\}$', '', 'g')

	" Replace all tabs with " | "
	let curr_line = substitute(curr_line, '\t', ' | ', 'g')

	" Possibly insert a leading | (if there isn't already one)
	let curr_line = substitute(curr_line, '^\(|\)\@!', '| ', '')

	" Possibly insert a trailing | (if there isn't already one)
	let curr_line = substitute(curr_line, '\(|\)\@<!$', ' |', '')
	return curr_line
endfunction

function! FormatPrettyTable() range
	for linenum in range(a:firstline, a:lastline)
		let curr_line = getline(linenum)
		let curr_line = FormatTableLine(curr_line)
		call setline(linenum, curr_line)
	endfor

	call Tabularize("/\|/")
endfunction

AddTabularPipeline! pretty_table /\t\|\(-\)\@<!|\(-\)\@!/ map(a:lines, "FormatTableLine(v:val)") | tabular#TabularizeStrings(a:lines, '|')

nmap <silent> <leader>pt :Tabularize pretty_table<cr>
nmap <silent> <leader>pp "+P:Tabularize pretty_table<cr>
