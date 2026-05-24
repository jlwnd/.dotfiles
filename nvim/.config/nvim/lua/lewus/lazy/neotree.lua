return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require("neo-tree").setup({
            close_if_last_window = true,
            window = {
                width = "25",
                position = "right",
            },
            filesystem = {
                filtered_items = {
                    visible = true,
                    hide_dotfiles = false,
                    hide_gitignored = true,
                },
                follow_current_file = {
                    enabled = true,
                },
            },
        })

        vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<CR>', { desc = "Toggle Neo-tree file explorer" })
        vim.keymap.set('n', '<leader>o', '<cmd>Neotree focus<CR>', { desc = "Focus Neo-tree file explorer" })
    end
}

