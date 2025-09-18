function FormatArgs()
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local tree = vim.treesitter.get_parser():parse()[1]
  local query = vim.treesitter.query.parse(
    vim.bo.filetype,
    [[
      (argument_list (_) @arg)
    ]]
  )
  local newline_indexes = {}
  local first = true
  local parent_id = nil
  for _, node, _ in query:iter_captures(tree:root(), 0) do
    local row = node:start()
    if row == (current_line - 1) then
      local _, scol, _, ecol = node:range()
      if first then
        table.insert(newline_indexes, scol)
        parent_id = node:parent():id()
        first = false
      end
      if node:parent():id() == parent_id then
        table.insert(newline_indexes, { scol, ecol })
      end
    end
  end
  if #newline_indexes == 0 then
    return
  end
  first = true
  local line = vim.api.nvim_get_current_line()
  local _, tabcount = line:gsub('\t', '')
  local lines = {}
  for i, val in pairs(newline_indexes) do
    if i == 1 then
      table.insert(lines, string.sub(line, 0, val))
    else
      local s = val[1]
      local e = val[2]
      table.insert(lines, string.rep('\t', tabcount + 1) .. string.sub(line, s + 1, e) .. ',')
    end
  end
  table.insert(lines, string.rep('\t', tabcount) .. ')')
  vim.api.nvim_buf_set_lines(0, current_line - 1, current_line, true, lines)
end
