local dap = require("dap")
local mason_dap = require("mason-nvim-dap")
local ui = require("dapui")
local dap_virtual_text = require("nvim-dap-virtual-text")

dap_virtual_text.setup({})

mason_dap.setup({
  ensure_installed = { "netcoredbg" },
  automatic_installation = true,
  handlers = {
    function(config)
      require("mason-nvim-dap").default_setup(config)
    end,
  },
})

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
    --[[
    program = function()
      return vim.fn.input("Path to DLL: ", vim.fn.getcwd() .. "/bin/Debug/net9.0/", "file")
    end,
    ]]
    program = "/Users/thomas/Developer/Projects/clk/clk/bin/Debug/net9.0/clk.dll",
    cwd = "${workspaceFolder}",
    args = { "show" },
    stopAtEntry = false,
  },
}

ui.setup({
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

dap.listeners.before.attach.dapui_config = function()
  ui.open()
end
dap.listeners.before.launch.dapui_config = function()
  ui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  ui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  ui.close()
end
