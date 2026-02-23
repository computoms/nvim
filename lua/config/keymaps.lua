-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local wk = require("which-key")
wk.add({
  { "<leader>t", group = "Tests" },
  { "<leader>tr", "<cmd>lua require('neotest').run.run()<cr>", desc = "Run nearest test" },
  { "<leader>ta", "<cmd>lua require('neotest').run.run({ suite = true })<cr>", desc = "Run all tests" },
  { "<leader>to", "<cmd>lua require('neotest').output.open()<cr>", desc = "Show tests output" },
  { "<leader>tp", "<cmd>lua require('neotest').output_panel.toggle()<cr>", desc = "Show tests panel" },
  { "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<cr>", desc = "Show tests summary" },
})
