local M = {}

local path_join = require('auto-save.utils.path_join').path_join

local store = {}


local read_file = function (path)
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

local write_file = function (path, content)
  local fd = vim.loop.fs_open(path, "w", 438)
  if not fd then
    return nil
  end

  return vim.loop.fs_write(fd, content)
end

function M.init()
  local path = path_join(vim.fn.stdpath("data"), "auto-save")

  local stat, err = vim.loop.fs_stat(path)
  if err then
    local ok = vim.loop.fs_mkdir(path, 493)
  end


  local local_history_path = path_join(path, 'local-history')
  stat, err = vim.loop.fs_stat(local_history_path)
  if err then
    local ok = vim.loop.fs_mkdir(local_history_path, 493)
  end

  local store_path = path_join(path, 'store.json')
  stat, err = vim.loop.fs_stat(store_path)

  if err then
    vim.pretty_print("werite me")
    write_file(store_path, 998)
  else
    local str = read_file(store_path)
    store = vim.json.decode(str)
  end

end

function M.add()

end

function M.del()

end


return M
