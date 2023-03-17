local M = {}

local local_history = require('auto-save.local_history')
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

function M.has_file(cur)
  for i, item in ipairs(auto_saved_files) do
    if item == cur then
      return true
    else
      return nil
    end
  end
end

local save_buf = {}

function M.save(buf, path)
  if save_buf[buf] then
    --
  else
    save_buf[buf] = debounce(function()
      vim.api.nvim_buf_call(buf, function()
        -- vim.cmd("silent! write")
        local_history.add(buf, path)
      end)
    end, config.debounce_delay)
  end

  save_buf[buf]()
end

function M.init()
  local_history.init()
end

function M.destroy()
  local_history.destroy()
end

return M
