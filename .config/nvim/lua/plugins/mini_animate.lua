return {
  {
    "echasnovski/mini.animate",
    version = false,
    config = function()
      local animate = require("mini.animate")
      local opts = {
        cursor = {
          timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
        },
        scroll = {
          enable = true,
          timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
        },
        close = {
          enable = false,
        },
        open = {
          enable = false,
        },
        resize = {
          enable = false,
        },
      }
      animate.setup(opts)
    end,
  },
}
