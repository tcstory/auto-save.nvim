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


 function M.read_file(path)
  local fd = vim.loop.fs_open(path, "r", 438)
  if not fd then
    return ""
  end
  local stat = vim.loop.fs_fstat(fd)
  if not stat then
    return ""
  end
  local data = vim.loop.fs_read(fd, stat.size, 0)
  vim.loop.fs_close(fd)
  return data or ""
end

function M.write_file(path, content)
  local fd = vim.loop.fs_open(path, "w", 438)
  if not fd then
    return nil
  end

  return vim.loop.fs_write(fd, content)
end

return M
