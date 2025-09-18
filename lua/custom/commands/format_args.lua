function GetPrefix(s)
  local prefix_char = string.sub(s, 1, 1) == ' ' and ' ' or '\t'
  local match = string.match(s, prefix_char .. '+')
  return prefix_char, match and #match or 0
end

function FormatArgs()
  local quotes = { ['"'] = '"', ["'"] = "'", ['['] = ']', ['{'] = '}', ['('] = ')' }
  local line_number = vim.api.nvim_win_get_cursor(0)[1]
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local current_line = vim.api.nvim_get_current_line()
  local prefix_char, prefixlen = GetPrefix(current_line)
  local lines, arg_start, ignore, ignore_till, block_end = {}, nil, false, nil, nil

  for i = col, #current_line do
    local c = current_line:sub(i, i)

    if not arg_start then
      if quotes[c] then
        table.insert(lines, current_line:sub(1, i))
        block_end = quotes[c]
        arg_start = i + 1
      end
    elseif quotes[c] and ignore == false then
      ignore, ignore_till = true, quotes[c]
    elseif ignore then
      if c == ignore_till then
        ignore = false
      end
    elseif c == ',' or c == block_end then
      table.insert(lines, string.rep(prefix_char, prefixlen + 1) .. current_line:sub(arg_start, i - 1) .. ',')
      arg_start = i + (c == block_end and 1 or 2)
      if c == block_end then
        break
      end
    end
  end

  if arg_start then
    local suffix = current_line:sub(arg_start or #current_line + 1)
    table.insert(lines, string.rep(prefix_char, prefixlen) .. block_end .. suffix)
    vim.api.nvim_buf_set_lines(0, line_number - 1, line_number, true, lines)
  end
end
