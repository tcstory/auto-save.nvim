local M = {}

function M.debounce(callback, duration)
  local timer = nil
  local clear = function ()
    timer:stop()
    timer:close()
    timer = nil
  end

  local wrapper = function (...)
    local args = {...}
    if timer ~= nil then
      clear() 
    end

    timer = vim.defer_fn(function ()
      timer = nil
      callback(unpack(args))
    end, duration)
  end

  return wrapper
end

return M
