local M = {}

local config = require('auto-save.config')
local saver = require('auto-save.saver')


local command_name = "AutoSave"
local group_id

local on = function ()
  group_id = vim.api.nvim_create_augroup(command_name, {})

  vim.api.nvim_create_autocmd(config.trigger_events, {
    group = group_id,
    callback = function(ctx)
      saver.add_to_saved_files(ctx.match)

      if saver.has_file(ctx.match) then
        local buf = vim.api.nvim_get_current_buf()
        saver.save(buf, ctx.match)
      end
    end,
    pattern = "*",
  })


  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group_id,
    callback = function()
      saver.destroy()
    end,
    pattern = "*",
  })
end

local function off()
  vim.api.nvim_del_augroup_by_id(group_id)
end

function M.setup()
  on()
  saver.init()
end


local command = vim.api.nvim_create_user_command

command("AutoSaveOff", function ()
  off();
end, {})

return M
