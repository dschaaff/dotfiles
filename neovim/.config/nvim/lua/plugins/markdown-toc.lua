return {
  'hedyhli/markdown-toc.nvim',
  ft = 'markdown',
  opts = {
    -- Auto-update the TOC on save. Enabled by default.
    auto_update = {
      enabled = true,
      -- This allows the ToC to be refreshed silently on save
      -- for any markdown file. The refresh operation uses `Mtoc update`
      -- and does NOT create the ToC if it does not exist.
    },
    -- Other configuration options can go here
  },
}
