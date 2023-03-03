local M = {}

local config = require('auto-save.config')

local cacheRoot = {}
local autoSavedFiles = {}

local isUnderGit = function (cur, cacheRoot)
  for k, v in pairs(cacheRoot) do
    vim.pretty_print('test', k, v)    
    if vim.regex(k .. '*'):match_str(cur) then
      return true
    end
  end

  for dir in vim.fs.parents(cur) do
    if vim.fn.isdirectory(dir .. "/.git") == 1 then
      cacheRoot[dir] = true
      return true
    end
  end
  return false
end

local addToSavedFiles = function (cur, autoSavedFiles)
  table.insert(autoSavedFiles, cur)
end

local save = function (buf)
  vim.pretty_print('[auto-save]: save', buf)
end

local on = function () 
  local id = vim.api.nvim_create_augroup("AutoSave", {})
  vim.api.nvim_create_autocmd({"BufReadPost", "BufNewFile"}, {
    group = id,
    callback = function (ctx)
      if vim.bo.modifiable then
        if isUnderGit(ctx.file, cacheRoot) then
          addToSavedFiles(ctx.file, autoSavedFiles)
        end
      end
    end
  })


  vim.api.nvim_create_autocmd(config.trigger_events, {
    group = id,
    callback = function()
      save(vim.api.nvim_get_current_buf())
    end,
    pattern = "*",
  })
end

function M.setup()
  on()
end

return M
