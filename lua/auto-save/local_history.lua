local M = {}

local path_join = require('auto-save.utils.path_join').path_join
local read_file = require('auto-save.utils.path_join').read_file
local write_file = require('auto-save.utils.path_join').write_file

local store = {
  version = "0.1.0",
  history = {}
}


function M.init()
  local path = path_join(vim.fn.stdpath("data"), "auto-save")

  local stat, err = vim.loop.fs_stat(path)
  if err then
    vim.loop.fs_mkdir(path, 493)
  end


  local local_history_path = path_join(path, 'local-history')
  stat, err = vim.loop.fs_stat(local_history_path)
  if err then
    vim.loop.fs_mkdir(local_history_path, 493)
  end

  local store_path = path_join(path, 'store.json')
  stat, err = vim.loop.fs_stat(store_path)

  if err then
    -- write_file(store_path, vim.json.encode(store))
  else
    local str = read_file(store_path)
    store = vim.json.decode(str)
  end

end

function M.add(buf, file_path)
  local content = vim.api.nvim_buf_get_lines(buf, 0, -1, false)  
  local file_name = vim.fn.rand()
  local path = path_join(vim.fn.stdpath("data"), "auto-save", "local-history", file_name)
  local bytes = write_file(path, content)



  if bytes ~= nil then
    if store.history[file_path] == nil then
      store.history[file_path] = {}
    end
    table.insert(store.history[file_path], file_name)
  end
end

function M.del()

end

function M.destroy()
  local path = path_join(vim.fn.stdpath("data"), "auto-save", 'store.json')

  write_file(path, vim.json.encode(store))
end


return M
