local M = {}
local debounce = require('auto-save.lib').debounce
local config = require('auto-save.config')

local cache_root = {}
local auto_saved_files = {}

function M.is_under_git(cur)
  for k in pairs(cache_root) do
    if vim.regex(k .. '*'):match_str(cur) then
      return true
    end
  end

  for dir in vim.fs.parents(cur) do
    if vim.fn.isdirectory(dir .. "/.git") == 1 then
      cache_root[dir] = true
      return true
    end
  end
  return false
end

function M.add_to_saved_files(cur)
  table.insert(auto_saved_files, cur)
end

local save_buf = {}

function M.save(buf)
  if save_buf[buf] then
    -- 
  else
    save_buf[buf] = debounce(function ()
      vim.pretty_print('[auto-save]: save', buf)
    end, config.debounce_delay)
  end

  save_buf[buf]()
end

return M
