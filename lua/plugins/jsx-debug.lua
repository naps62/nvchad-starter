return {
  {
    "jsx-debug",
    dir = vim.fn.stdpath("config"),
    ft = { "javascriptreact", "typescriptreact", "jsx", "tsx" },
    config = function()
      require("jsx-debug").setup()
    end,
  },
}
