-- local animate = require('mini.animate')
-- animate.setup({
--     cursor = {
--         -- Animate for 200 milliseconds with linear easing
--         timing = animate.gen_timing.linear({ duration = 150, unit = 'total' }),
--
--         -- Animate with shortest line for any cursor move
--         path = animate.gen_path.line({
--             predicate = function() return true end,
--         }),
--     },
--     -- Vertical scroll
--     scroll = {
--         -- Whether to enable this animation
--         enable = false,
--     }
-- })

local cursor = require('smear_cursor')

cursor.setup({
    -- Smear cursor when switching buffers or windows.
    smear_between_buffers = true,

    -- Smear cursor when moving within line or to neighbor lines.
    -- Use `min_horizontal_distance_smear` and `min_vertical_distance_smear` for finer control
    smear_between_neighbor_lines = true,

    -- Draw the smear in buffer space instead of screen space when scrolling
    scroll_buffer_space = true,

    -- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
    -- Smears will blend better on all backgrounds.
    legacy_computing_symbols_support = false,

    -- Smear cursor in insert mode.
    -- See also `vertical_bar_cursor_insert_mode` and `distance_stop_animating_vertical_bar`.
    smear_insert_mode = true,
})


require('neoscroll').setup({
    mappings = { -- Keys to be mapped to their corresponding default scrolling animation
        '<C-u>', '<C-d>',
        '<C-b>', '<C-f>',
        '<C-y>', '<C-e>',
        'zt', 'zz', 'zb',
    },
    hide_cursor = true,          -- Hide cursor while scrolling
    stop_eof = false,            -- Stop at <EOF> when scrolling downwards
    respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
    duration_multiplier = 1,     -- Global duration multiplier
    easing = 'linear',           -- Default easing function
    pre_hook = nil,              -- Function to run before the scrolling animation starts
    post_hook = nil,             -- Function to run after the scrolling animation ends
    performance_mode = true,     -- Disable "Performance Mode" on all buffers.
    ignored_events = {           -- Events ignored while scrolling
        -- 'WinScrolled', 'CursorMoved'
    },
})
