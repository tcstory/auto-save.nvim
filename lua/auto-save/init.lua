local M = {}

local config = require('auto-save.config')
local is_under_git = require('auto-save.util').is_under_git
local add_to_saved_files = require('auto-save.util').add_to_saved_files
local save = require('auto-save.util').save

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
    callback = function()
      save(vim.api.nvim_get_current_buf())
    end,
    pattern = "*",
  })
end

function M.setup()
  on()
end

local function off()
    vim.api.nvim_del_augroup_by_id(group_id)
end


local command = vim.api.nvim_create_user_command

command("AutoSaveOff", function ()
  off();
end, {})

return M
