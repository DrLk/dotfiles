local gitsigns = require('gitsigns')
gitsigns.setup {
    on_attach                         = function(bufnr)
        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
            if vim.wo.diff then
                vim.cmd.normal({ ']c', bang = true })
            else
                gitsigns.nav_hunk('next')
            end
        end)

        map('n', '[c', function()
            if vim.wo.diff then
                vim.cmd.normal({ '[c', bang = true })
            else
                gitsigns.nav_hunk('prev')
            end
        end)

        -- Actions
        map('n', '<leader>hs', gitsigns.stage_hunk)
        map('n', '<leader>hr', gitsigns.reset_hunk)
        map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
        map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
        map('n', '<leader>hS', gitsigns.stage_buffer)
        map('n', '<leader>hu', gitsigns.undo_stage_hunk)
        map('n', '<leader>hR', gitsigns.reset_buffer)
        map('n', '<leader>hp', gitsigns.preview_hunk)
        map('n', '<leader>hb', function() gitsigns.blame_line { full = true } end)
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
        map('n', '<leader>hd', gitsigns.diffthis)
        map('n', '<leader>hD', function() gitsigns.diffthis('~') end)
        map('n', '<leader>td', gitsigns.toggle_deleted)

        vim.keymap.set("n", "<leader>rr", function()
            gitsigns.preview_hunk_inline()
            local deleted = require('gitsigns.config').config.show_deleted
            gitsigns.toggle_deleted(false)

            vim.defer_fn(function()
                -- Get the current window ID
                local current_win = vim.api.nvim_get_current_win()

                -- Get a list of all window IDs
                local all_wins = vim.api.nvim_list_wins()

                -- Find the index of the current window in the list
                local current_index = nil
                for i, win in ipairs(all_wins) do
                    if win == current_win then
                        current_index = i
                        break
                    end
                end

                -- If current_index is found and it's not the last window, switch to the next window
                if current_index and current_index < #all_wins then
                    local next_win = all_wins[current_index + 1]
                    vim.api.nvim_set_current_win(next_win)

                    local buf = vim.api.nvim_win_get_buf(next_win)

                    -- Get the visible range of lines in the current window
                    local first_line = vim.fn.line('w0')
                    local last_line = vim.fn.line('w$')

                    vim.api.nvim_buf_set_lines(buf, last_line, -1, false, {})
                    vim.api.nvim_buf_set_lines(buf, 0, first_line - 1, false, {})

                    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
                    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '', {
                        noremap = true,
                        silent = true,
                        callback = function()
                            gitsigns.toggle_deleted(deleted)
                            vim.api.nvim_input('<C-w>q')
                        end
                    })
                end
            end, 50)

            -- vim.api.nvim_win_close(win_id, true)
        end, { desc = "document" })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end,
    signs                             = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
    },
    show_deleted                      = true,
    signcolumn                        = true,  -- Toggle with `:Gitsigns toggle_signs`
    numhl                             = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl                            = true,  -- Toggle with `:Gitsigns toggle_linehl`
    word_diff                         = false, -- Toggle with `:Gitsigns toggle_word_diff`
    diff_opts                         = {
        algorithm = "histogram",
        ignore_whitespace_change = true,
    },
    watch_gitdir                      = {
        follow_files = true
    },
    auto_attach                       = true,
    attach_to_untracked               = false,
    current_line_blame                = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts           = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
    },
    current_line_blame_formatter      = '<author>, <author_time:%Y-%m-%d> - <summary>',
    current_line_blame_formatter_opts = {
        relative_time = false,
    },
    sign_priority                     = 6,
    update_debounce                   = 100,
    status_formatter                  = nil,   -- Use default
    max_file_length                   = 40000, -- Disable if file is longer than this (in lines)
    preview_config                    = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
    },
}
vim.keymap.set('n', '<leader>rb', function() gitsigns.blame_line { full = true } end)
