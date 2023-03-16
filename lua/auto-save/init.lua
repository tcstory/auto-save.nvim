local M = {}

local config = require('auto-save.config')
local is_under_git = require('auto-save.util').is_under_git
local add_to_saved_files = require('auto-save.util').add_to_saved_files
local has_file = require('auto-save.util').has_file
local save = require('auto-save.util').save
local local_history = require('auto-save.local_history')


local command_name = "AutoSave"
local group_id

local on = function ()
  group_id = vim.api.nvim_create_augroup(command_name, {})
  vim.api.nvim_create_autocmd({"BufReadPost", "BufNewFile"}, {
    group = group_id,
    callback = function (ctx)
      if vim.bo.modifiable then
        if is_under_git(ctx.file) then
          add_to_saved_files(ctx.file)
        end
      end
    end
  })


  vim.api.nvim_create_autocmd(config.trigger_events, {
    group = group_id,
    callback = function(ctx)
      if has_file(ctx.file) then
        save(vim.api.nvim_get_current_buf())
      end
    end,
    pattern = "*",
  })
end

local function off()
  vim.api.nvim_del_augroup_by_id(group_id)
end

function M.setup()
  on()
  local_history.init()
end


local command = vim.api.nvim_create_user_command

command("AutoSaveOff", function ()
  off();
end, {})

return M
