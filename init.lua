-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- bootstrap neotest config
require("neotest").setup({
  adapters = {
    require("neotest-dotnet"),
  },
})
