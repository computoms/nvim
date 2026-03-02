return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "Issafalcon/neotest-dotnet",
      "nvim-neotest/neotest-jest",
    },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      table.insert(opts.adapters, require("neotest-dotnet"))

      local jest = require("neotest-jest")({
        jestCommand = "yarn test",
        jestConfigFile = function()
          return vim.fn.getcwd() .. "/jest.config.js"
        end,
        jest_test_discovery = true,
        jestArguments = function(defaultArguments, context)
          return defaultArguments
        end,
        cwd = function()
          return vim.fn.getcwd()
        end,
        isTestFile = function(file_path)
          if file_path == nil then
            return false
          end
          return file_path:match("[_%.]test%.[jt]sx?$") ~= nil or file_path:match("[_%.]spec%.[jt]sx?$") ~= nil
        end,
      })

      local orig = jest.build_spec
      jest.build_spec = function(args)
        local spec = orig(args)
        if not spec or not args.tree then
          return spec
        end
        local pos = args.tree:data()
        if not pos then
          return spec
        end
        local filename = vim.fs.basename(vim.fs.normalize(pos.path)):gsub("%.", "\\.")
        spec.command[#spec.command] = filename
        vim.notify("[neotest-jest] running: " .. table.concat(spec.command, " "), vim.log.levels.INFO)
        return spec
      end

      table.insert(opts.adapters, jest)
      return opts
    end,
  },
  { "nvim-neotest/neotest-jest" },
}
