local M = { "neovim/nvim-lspconfig" }

M.config = function(opts)
    local lspconfig = require("lspconfig")

    -- Setting the border of LspInfo
    require("lspconfig.ui.windows").default_options.border = "rounded"
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspConfig", {}),
        callback = function(env)
            -- Hide all semantic highlights because it is current overriding highlights in a manner I don't like for rust
            -- TODO: Find a better solution to this because semantic highlighting can be useful
            local client = vim.lsp.get_client_by_id(env.data.client_id)
            client.server_capabilities.semanticTokensProvider = nil

            local opts = { noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
            vim.keymap.set("n", "<Leader>d", ":lua vim.diagnostic.open_float()<CR>", opts)
            vim.keymap.set("n", "<Leader>r", ":lua vim.lsp.buf.rename()<CR>", opts)
        end,
    })

    -- Diagnostic configuration
    vim.diagnostic.config({
        virtual_text = false,
        float = { border = "single" },
        signs = { severity_sort = true, priority = 2 },
        underline = false,
        update_in_insert = true,
        severity_sort = true,
    })

    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = false

    -- Language sever setups
    lspconfig.gopls.setup({
        cmd = { "gopls", "--remote=auto" },
        capabilities = capabilities,
        init_options = { staticcheck = true },
    })

    lspconfig.rust_analyzer.setup({ capabilities = capabilities })
    lspconfig.pyright.setup({ capabilities = capabilities })
    lspconfig.tsserver.setup({ capabilities = capabilities })
    lspconfig.svelte.setup({ { capabilities = capabilities } })
end

return M
