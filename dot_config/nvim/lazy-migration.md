# Migrating from lazy.nvim to vim.pack

After pulling the updated config, run these commands to clean up lazy.nvim's data:

```bash
# Remove lazy.nvim's plugin install directory
rm -rf ~/.local/share/nvim/lazy/

# Remove lazy.nvim's state/cache
rm -rf ~/.local/state/nvim/lazy/
rm -rf ~/.cache/nvim/luac/  # optional: clear bytecode cache to avoid stale entries
```

On next `nvim` launch, vim.pack will prompt to install all plugins.

Run `:checkhealth vim.pack` to verify everything is healthy.
