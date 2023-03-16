-- the code is copied from  https://github.com/nvim-neo-tree/neo-tree.nvim/blob/main/lua/neo-tree/utils.lua
--
local M  = {}

---The file system path separator for the current platform.
local path_separator = "/"
local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win32unix") == 1

if is_windows == true then
  path_separator = "\\"
end

local split = function(inputString, sep)
  local fields = {}

  local pattern = string.format("([^%s]+)", sep)
  local _ = string.gsub(inputString, pattern, function(c)
    fields[#fields + 1] = c
  end)

  return fields
end


function M.path_join(...)
  local args = { ... }
  if #args == 0 then
    return ""
  end

  local all_parts = {}
  if type(args[1]) == "string" and args[1]:sub(1, 1) == path_separator then
    all_parts[1] = ""
  end

  for _, arg in ipairs(args) do
    if arg == "" and #all_parts == 0 and not is_windows then
      all_parts = { "" }
    else
      local arg_parts = split(arg, path_separator)
      vim.list_extend(all_parts, arg_parts)
    end
  end
  return table.concat(all_parts, path_separator)
end

return M
