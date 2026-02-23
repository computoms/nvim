-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- bootstrap neotest config
require("neotest").setup({
  adapters = {
    require("neotest-dotnet"),
  },
})

-- Mason config
require("mason").setup({
  registries = {
    "github:mason-org/mason-registry",
    "github:Crashdummyy/mason-registry",
  },
})

-- Debug adapter config
require("config.debug")
