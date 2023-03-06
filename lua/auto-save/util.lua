local M = {}

function M.debounce(callback, duration)
  local timer = nil
  local clear = function ()
    timer:stop()
    timer:close()
    timer = nil
  end

  local wrapper = function ()
    if timer ~= nil then
      vim.pretty_print("alreay .. clear it")
      clear() 
    end

    timer = vim.defer_fn(function ()
      timer = nil
      callback()
    end, duration)
  end

  return wrapper
end

return M
