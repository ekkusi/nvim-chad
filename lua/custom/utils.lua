local M = {}
-- Function that is called on the <Esc> key press
function M.OnEscape()
  -- Close the floating windows
  local floating_wins = vim.api.nvim_list_wins()
  for _, win in ipairs(floating_wins) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then -- Checks if the window is a floating window
      vim.api.nvim_win_close(win, false)
      return -- Close the first floating window found and exit
    end
  end
  -- Remove search
  vim.api.nvim_command "noh"
end

M.ReloadConfig = function()
  -- Clear the Lua cache
  for name, _ in pairs(package.loaded) do
    if name:match "^custom" or name:match "^core" then
      package.loaded[name] = nil
    end
  end

  -- Reload chadrc and other configurations
  dofile(vim.env.MYVIMRC) -- This points to your main `init.lua` or `init.vim`
  require("vscode").load()
  print "Configuration reloaded!"
end

M.DeleteQfItem = function()
  local items = vim.fn.getqflist()
  local line = vim.fn.line "."
  table.remove(items, line)
  vim.fn.setqflist(items, "r")
  vim.api.nvim_win_set_cursor(0, { line, 0 })
end

return M
