return {
  {
    "windwp/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- stylua: ignore
    keys = {
      { "<leader>S", function() require("spectre").open() end, desc = "Replace in files (Spectre)", },
    },
  },
}
