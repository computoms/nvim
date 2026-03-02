return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      automatic_installation = {
        exclude = { "chrome-debug-adapter" },
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    recommended = true,
    desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",

    dependencies = {
      "rcarriga/nvim-dap-ui",
      -- virtual text for the debugger
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
    },

  -- stylua: ignore
  keys = {
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
    { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
    { "<leader>dd", function() require("dapui").open() end, desc = "Open DAP UI" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
    { "<leader>dj", function() require("dap").down() end, desc = "Down" },
    { "<leader>dk", function() require("dap").up() end, desc = "Up" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
    { "<leader>du", function() require("dap").step_out() end, desc = "Step Out" },
    { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
    { "<leader>dP", function() require("dap").pause() end, desc = "Pause" },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    { "<leader>ds", function() require("dap").session() end, desc = "Session" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
  },

    config = function()
      -- load mason-nvim-dap here, after all adapters have been setup
      if LazyVim.has("mason-nvim-dap.nvim") then
        require("mason-nvim-dap").setup(LazyVim.opts("mason-nvim-dap.nvim"))
      end

      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(LazyVim.config.icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end

      -- setup dap config by VsCode launch.json file
      local vscode = require("dap.ext.vscode")
      local json = require("plenary.json")
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end


      -- js-debug-adapter (vscode-js-debug) for Electron
      local dap = require("dap")
      local js_debug = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"

      local js_adapter = {
        type = "server",
        host = "::1",
        port = "${port}",
        executable = {
          command = "node",
          args = { js_debug, "${port}" },
        },
      }

      for _, adapter in ipairs({ "pwa-node", "pwa-chrome" }) do
        dap.adapters[adapter] = js_adapter
      end

      -- Remap legacy type names: transform config before sending to js-debug
      dap.adapters["node"] = function(cb, config)
        cb(js_adapter, vim.tbl_extend("force", config, { type = "pwa-node" }))
      end
      dap.adapters["chrome"] = function(cb, config)
        cb(js_adapter, vim.tbl_extend("force", config, { type = "pwa-chrome" }))
      end

      for _, lang in ipairs({ "javascript", "typescript" }) do
        dap.configurations[lang] = dap.configurations[lang] or {}
        vim.list_extend(dap.configurations[lang], {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch Electron (Main)",
            runtimeExecutable = "electron",
            args = { "." },
            skipFiles = { "<node_internals>/**", "node_modules/**" },
            resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to Electron (Main)",
            port = 9229,
            skipFiles = { "<node_internals>/**", "node_modules/**" },
          },
          {
            type = "pwa-chrome",
            request = "attach",
            name = "Attach to Electron (Renderer)",
            port = 9222,
            webRoot = "${workspaceFolder}",
            skipFiles = { "<node_internals>/**", "node_modules/**" },
          },
        })
      end
    end,
  },
}
