-- [nfnl] fnl/custom/commands/format_args_fnl.fnl
local quotes = {["\""] = "\"", ["'"] = "'", ["["] = "]", ["{"] = "}", ["("] = ")"}
local function inc(n)
  return (1 + n)
end
local function matching_quote(c)
  return quotes[c]
end
local function insert(t, v)
  table.insert(t, v)
  return t
end
local function empty_3f(t)
  return (#t == 0)
end
local function getPrefix(s)
  local prefix_char
  if (string.sub(s, 1, 1) == " ") then
    prefix_char = " "
  else
    prefix_char = "\9"
  end
  local function _3_()
    local _2_ = string.match(s, (prefix_char .. "+"))
    if (nil ~= _2_) then
      local prefix = _2_
      return #prefix
    else
      local _3f_ = _2_
      return 0
    end
  end
  return prefix_char, _3_()
end
local function find_first_surrounding(chars, acc)
  local and_5_ = (nil ~= chars)
  if and_5_ then
    local s = chars
    and_5_ = empty_3f(s)
  end
  if and_5_ then
    local s = chars
    return chars, nil, acc
  elseif ((_G.type(chars) == "table") and (nil ~= chars[1])) then
    local x = chars[1]
    local xs = {select(2, (table.unpack or _G.unpack)(chars))}
    local matching
    do
      local t_7_ = quotes
      if (nil ~= t_7_) then
        t_7_ = t_7_[x]
      else
      end
      matching = t_7_
    end
    if matching then
      return xs, matching, table.concat(insert(acc, x))
    else
      return find_first_surrounding(xs, insert(acc, x))
    end
  else
    return nil
  end
end
local function format_args_recursive(s, ignore, closing, line, acc, prefix, prefix_len)
  local _11_ = {s, ignore}
  local and_12_ = ((_G.type(_11_) == "table") and (nil ~= _11_[1]) and true)
  if and_12_ then
    local b = _11_[1]
    local _3f_ = _11_[2]
    and_12_ = empty_3f(b)
  end
  if and_12_ then
    local b = _11_[1]
    local _3f_ = _11_[2]
    if empty_3f(line) then
      return acc
    else
      return insert(acc, (string.rep(prefix, prefix_len) .. table.concat(line)))
    end
  elseif (((_G.type(_11_[1]) == "table") and (nil ~= _11_[1][1])) and (nil ~= _11_[2])) then
    local x = _11_[1][1]
    local xs = {select(2, (table.unpack or _G.unpack)(_11_[1]))}
    local end_ch = _11_[2]
    local _15_
    if (end_ch == x) then
      _15_ = nil
    else
      _15_ = end_ch
    end
    return format_args_recursive(xs, _15_, closing, insert(line, x), acc, prefix, prefix_len)
  else
    local and_17_ = ((_G.type(_11_) == "table") and ((_G.type(_11_[1]) == "table") and (nil ~= _11_[1][1])) and (_11_[2] == nil))
    if and_17_ then
      local x = _11_[1][1]
      local xs = {select(2, (table.unpack or _G.unpack)(_11_[1]))}
      local _20_
      do
        local t_19_ = quotes
        if (nil ~= t_19_) then
          t_19_ = t_19_[x]
        else
        end
        _20_ = t_19_
      end
      and_17_ = _20_
    end
    if and_17_ then
      local x = _11_[1][1]
      local xs = {select(2, (table.unpack or _G.unpack)(_11_[1]))}
      return format_args_recursive(xs, quotes[x], closing, insert(line, x), acc, prefix, prefix_len)
    else
      local and_22_ = ((_G.type(_11_) == "table") and ((_G.type(_11_[1]) == "table") and (nil ~= _11_[1][1])) and (_11_[2] == nil))
      if and_22_ then
        local x = _11_[1][1]
        local xs = {select(2, (table.unpack or _G.unpack)(_11_[1]))}
        and_22_ = (x == " ")
      end
      if and_22_ then
        local x = _11_[1][1]
        local xs = {select(2, (table.unpack or _G.unpack)(_11_[1]))}
        return format_args_recursive(xs, ignore, closing, line, acc, prefix, prefix_len)
      else
        local and_24_ = ((_G.type(_11_) == "table") and ((_G.type(_11_[1]) == "table") and (nil ~= _11_[1][1])) and (_11_[2] == nil))
        if and_24_ then
          local x = _11_[1][1]
          local xs = {select(2, (table.unpack or _G.unpack)(_11_[1]))}
          and_24_ = (x == ",")
        end
        if and_24_ then
          local x = _11_[1][1]
          local xs = {select(2, (table.unpack or _G.unpack)(_11_[1]))}
          return format_args_recursive(xs, ignore, closing, {}, insert(acc, (string.rep(prefix, inc(prefix_len)) .. table.concat(insert(line, x)))), prefix, prefix_len)
        else
          local and_26_ = ((_G.type(_11_) == "table") and ((_G.type(_11_[1]) == "table") and (nil ~= _11_[1][1])) and (_11_[2] == nil))
          if and_26_ then
            local x = _11_[1][1]
            local xs = {select(2, (table.unpack or _G.unpack)(_11_[1]))}
            and_26_ = (x == closing)
          end
          if and_26_ then
            local x = _11_[1][1]
            local xs = {select(2, (table.unpack or _G.unpack)(_11_[1]))}
            return insert(insert(acc, (string.rep(prefix, inc(prefix_len)) .. table.concat(line))), (string.rep(prefix, prefix_len) .. closing .. table.concat(xs)))
          elseif (((_G.type(_11_[1]) == "table") and (nil ~= _11_[1][1])) and (_11_[2] == nil)) then
            local x = _11_[1][1]
            local xs = {select(2, (table.unpack or _G.unpack)(_11_[1]))}
            return format_args_recursive(xs, ignore, closing, insert(line, x), acc, prefix, prefix_len)
          else
            return nil
          end
        end
      end
    end
  end
end
local function FormatArgsF()
  local _let_29_ = vim.api.nvim_win_get_cursor(0)
  local line = _let_29_[1]
  local col = _let_29_[2]
  local current_line = vim.api.nvim_get_current_line()
  local char_list
  do
    local tbl_21_ = {}
    local i_22_ = 0
    for v in string.gmatch(current_line, ".") do
      local val_23_ = v
      if (nil ~= val_23_) then
        i_22_ = (i_22_ + 1)
        tbl_21_[i_22_] = val_23_
      else
      end
    end
    char_list = tbl_21_
  end
  local prefix, prefix_len = getPrefix(current_line)
  local rest_line, surrounding, first_line = find_first_surrounding({unpack(char_list, (2 + col))}, {unpack(char_list, 1, inc(col))})
  if (surrounding == nil) then
    return nil
  else
    return vim.api.nvim_buf_set_lines(0, (line - 1), line, true, format_args_recursive(rest_line, nil, surrounding, {}, {first_line}, prefix, prefix_len))
  end
end
FormatArgsF()
return {FormatArgsF = FormatArgsF}
