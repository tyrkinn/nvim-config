(local quotes { "\"" "\"" "'" "'" "[" "]" "{" "}" "(" ")" })

(fn inc [n]
	(+ 1 n))

(fn matching-quote [c]
	(. quotes c))

(fn insert [t v]
	(table.insert t v)
	t)

(fn empty? [t]
	(= (length t) 0))


(fn getPrefix [s]
	(let [prefix-char (if (= (string.sub s 1 1) " ") " " "\t")]
		(values prefix-char
			(case (string.match s (.. prefix-char "+"))
				prefix (length prefix)
				?_ 0))))

(fn find-first-surrounding [chars acc]
	(case chars
		(where s (empty? s)) (values chars nil acc)
		[x & xs] (let [matching (?. quotes x)]
							 (if matching
									 (values xs matching (table.concat (insert acc x)))
									 (find-first-surrounding xs (insert acc x))))))

(fn format-args-recursive [s ignore closing line acc prefix prefix-len]
	(case [s ignore]
		(where [b ?_] (empty? b)) (if (empty? line) acc (insert acc (.. (string.rep prefix prefix-len) (table.concat line))))

		[[x & xs] end_ch] (format-args-recursive xs (if (= end_ch x) nil end_ch) closing (insert line x) acc prefix prefix-len)

		(where [[x & xs] nil] (?. quotes x)) (format-args-recursive xs (. quotes x) closing (insert line x) acc prefix prefix-len)
		(where [[x & xs] nil] (= x " ")) (format-args-recursive xs ignore closing line acc prefix prefix-len)
		(where [[x & xs] nil] (= x ",")) 
			(format-args-recursive xs ignore closing []
				(insert acc (.. (string.rep prefix (inc prefix-len)) (table.concat (insert line x))))
				prefix prefix-len)
		(where [[x & xs] nil] (= x closing))
			(-> acc
					(insert (.. (string.rep prefix (inc prefix-len)) (table.concat line)))
					(insert (.. (string.rep prefix prefix-len) closing (table.concat xs))))
		[[x & xs] nil]
			(format-args-recursive xs ignore closing (insert line x) acc prefix prefix-len)))

(fn FormatArgsF []
	(let [[line col] (vim.api.nvim_win_get_cursor 0)
			  current-line (vim.api.nvim_get_current_line)
				char-list (icollect [v (string.gmatch current-line ".")] v)
				(prefix prefix-len) (getPrefix current-line)
				(rest-line surrounding first-line) (find-first-surrounding [(unpack char-list (+ 2 col))] [(unpack char-list 1 (inc col))])]
		(if (= surrounding nil) nil
			(->>  (format-args-recursive rest-line nil surrounding [] [first-line] prefix prefix-len)
						(vim.api.nvim_buf_set_lines 0 (- line 1) line true)))))

(FormatArgsF)
{: FormatArgsF}

