-- Refresh neo-tree git status when leaving lazygit buffer
-- This ensures git file status indicators are updated after git operations
vim.api.nvim_create_autocmd({ 'BufLeave' }, {
  buffer = 0,
  callback = function()
    local ok, events = pcall(require, 'neo-tree.events')
    if ok then
      events.fire_event(events.GIT_EVENT)
    end
  end,
})
