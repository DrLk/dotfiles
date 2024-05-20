local gen_spec = require('mini.ai').gen_spec
require('mini.ai').setup(
    {
        -- Table with textobject id as fields, textobject specification as values.
        -- Also use this to disable builtin textobjects. See |MiniAi.config|.
        custom_textobjects = {
            -- Tweak argument textobject
            a = require('mini.ai').gen_spec.argument({ brackets = { '%b()' } }),

            -- Disable brackets alias in favor of builtin block textobject
            b = false,

            -- Now `vax` should select `xxx` and `vix` - middle `x`
            x = { 'x()x()x' },

            -- Whole buffer
            g = function()
                local from = { line = 1, col = 1 }
                local to = {
                    line = vim.fn.line('$'),
                    col = math.max(vim.fn.getline('$'):len(), 1)
                }
                return { from = from, to = to }
            end,
            c = gen_spec.treesitter({ a = '@call.outer', i = '@call.inner' }),
            f = gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
        },

        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
            -- Main textobject prefixes
            around = 'a',
            inside = 'i',

            -- Next/last variants
            around_next = 'an',
            inside_next = 'in',
            around_last = 'al',
            inside_last = 'il',

            -- Move cursor to corresponding edge of `a` textobject
            goto_left = 'g[',
            goto_right = 'g]',
        },

        -- Number of lines within which textobject is searched
        n_lines = 50,

        -- How to search for object (first inside current line, then inside
        -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
        -- 'cover_or_nearest', 'next', 'previous', 'nearest'.
        search_method = 'cover_or_next',

        -- Whether to disable showing non-error feedback
        silent = false,
    }
)

-- local config = {
--     textobjects = {
--         select = {
--             enable = true,
--
--             -- Automatically jump forward to textobj, similar to targets.vim
--             lookahead = true,
--
--             keymaps = {
--                 -- You can use the capture groups defined in textobjects.scm
--                 ["af"] = "@function.outer",
--                 ["if"] = "@function.inner",
--                 ["ac"] = "@class.outer",
--                 -- You can optionally set descriptions to the mappings (used in the desc parameter of
--                 -- nvim_buf_set_keymap) which plugins like which-key display
--                 ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
--                 -- You can also use captures from other query groups like `locals.scm`
--                 ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
--             },
--             -- You can choose the select mode (default is charwise 'v')
--             --
--             -- Can also be a function which gets passed a table with the keys
--             -- * query_string: eg '@function.inner'
--             -- * method: eg 'v' or 'o'
--             -- and should return the mode ('v', 'V', or '<c-v>') or a table
--             -- mapping query_strings to modes.
--             selection_modes = {
--                 ['@parameter.outer'] = 'v', -- charwise
--                 ['@function.outer'] = 'V',  -- linewise
--                 ['@class.outer'] = '<c-v>', -- blockwise
--             },
--             -- If you set this to `true` (default is `false`) then any textobject is
--             -- extended to include preceding or succeeding whitespace. Succeeding
--             -- whitespace has priority in order to act similarly to eg the built-in
--             -- `ap`.
--             --
--             -- Can also be a function which gets passed a table with the keys
--             -- * query_string: eg '@function.inner'
--             -- * selection_mode: eg 'v'
--             -- and should return true or false
--             include_surrounding_whitespace = false,
--         },
--     },
-- }
--
-- require("nvim-treesitter.configs").setup(config)
