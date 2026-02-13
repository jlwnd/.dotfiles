return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").setup({
            ensure_installed = {
                "lua",
                "python",
                "rust",
                "go",
                "javascript",
                "typescript",
                "html",
                "css",
                "yml",
                "gosum",
            },
            highlight = { enable = true },
            indent = { enable = true },
        })
    end
}
