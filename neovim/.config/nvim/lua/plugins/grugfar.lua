return {
  "MagicDuck/grug-far.nvim",
  opts = {
    engines = {
      ripgrep = {
        extraArgs = "--hidden --glob !.git/ --glob !.terraform --glob !node_modules --glob !.DS_Store",
      },
    },
  },
}
