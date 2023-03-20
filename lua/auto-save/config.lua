local config = {
  trigger_events = { "InsertLeave", "TextChanged" }, -- vim events that trigger auto-save. See :h events
  debounce_delay = 300,
  local_history_number = 2
}

return config
