return {
    "smoka7/multicursors.nvim",
    version = "*",
    lazy = true,
    dependencies = {
        "nvimtools/hydra.nvim",
    },
    cmd = { 
            'MCstart',
            'MCvisual', 
            'MCclear', 
            'MCpattern', 
            'MCvisualPattern', 
            'MCunderCursor'
          },

    config = function()
        require("multicursors").setup({
           hint_config = {
                   float_opts = {
                       border = 'rounded',
                   },
                   position = 'bottom-right',
               },
               generate_hints = {
                   normal = true,
                   insert = true,
                   extend = true,
                   config = {
                       column_count = 1,
                   },
               },
        })
    end,
}
