local dap = require("dap")

dap.adapters.coreclr = {
  type = "executable",
  command = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg",
  args = { "--interpreter=vscode" },
}

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "Launch",
    request = "launch",
    program = function()
      return vim.fn.input("Path to DLL: ", vim.fn.getcwd() .. "/bin/Debug/net9.0/", "file")
    end,
    cwd = "${workspaceFolder}",
    args = { "show" },
    stopAtEntry = false,
  },
}

require("dapui").setup({
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.25 },
        { id = "breakpoints", size = 0.25 },
        { id = "stacks", size = 0.25 },
        { id = "watches", size = 0.25 },
      },
      size = 40,
      position = "left",
    },
    {
      elements = {
        { id = "repl", size = 0.5 },
        { id = "console", size = 0.5 },
      },
      size = 10,
      position = "bottom",
    },
  },
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  floating = {
    border = "single",
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
})
