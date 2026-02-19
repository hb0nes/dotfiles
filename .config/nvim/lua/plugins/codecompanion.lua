local opts = {
  extensions = {
    history = {
      enabled = true,
      opts = {
        -- keymap to open history from chat buffer (default: gh)
        keymap = "oa",
        -- keymap to save the current chat manually (when auto_save is disabled)
        save_chat_keymap = "sc",
        -- save all chats by default (disable to save only manually using 'sc')
        auto_save = true,
        -- number of days after which chats are automatically deleted (0 to disable)
        expiration_days = 0,
        -- picker interface (auto resolved to a valid picker)
        picker = "snacks", --- ("telescope", "snacks", "fzf-lua", or "default")
        ---optional filter function to control which chats are shown when browsing
        chat_filter = nil, -- function(chat_data) return boolean end
        -- customize picker keymaps (optional)
        picker_keymaps = {
          rename = { n = "r", i = "<m-r>" },
          delete = { n = "d", i = "<m-d>" },
          duplicate = { n = "<c-y>", i = "<c-y>" },
        },
        ---automatically generate titles for new chats
        auto_generate_title = false,
        title_generation_opts = {
          ---adapter for generating titles (defaults to current chat adapter)
          adapter = nil,               -- "copilot"
          ---model for generating titles (defaults to current chat model)
          model = nil,                 -- "gpt-4o"
          ---number of user prompts after which to refresh the title (0 to disable)
          refresh_every_n_prompts = 0, -- e.g., 3 to refresh after every 3rd user prompt
          ---maximum number of times to refresh the title (default: 3)
          max_refreshes = 3,
          format_title = function(original_title)
            -- this can be a custom function that applies some custom
            -- formatting to the title.
            return original_title
          end
        },
        ---on exiting and entering neovim, loads the last chat on opening chat
        continue_last_chat = false,
        ---when chat is cleared with `gx` delete the chat from history
        delete_on_clearing_chat = false,
        ---directory path to save the chats
        dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
        ---enable detailed logging for history extension
        enable_logging = false,

        -- summary system
        summary = {
          -- keymap to generate summary for current chat (default: "gcs")
          create_summary_keymap = "gcs",
          -- keymap to browse summaries (default: "gbs")
          browse_summaries_keymap = "gbs",

          generation_opts = {
            adapter = nil,               -- defaults to current chat adapter
            model = nil,                 -- defaults to current chat model
            context_size = 90000,        -- max tokens that the model supports
            include_references = true,   -- include slash command content
            include_tool_outputs = true, -- include tool execution results
            system_prompt = nil,         -- custom system prompt (string or function)
            format_summary = nil,        -- custom function to format generated summary e.g to remove <think/> tags from summary
          },
        },

        -- memory system (requires vectorcode cli)
        memory = {
          -- automatically index summaries when they are generated
          auto_create_memories_on_summary_generation = true,
          -- path to the vectorcode executable
          vectorcode_exe = "vectorcode",
          -- tool configuration
          tool_opts = {
            -- default number of memories to retrieve
            default_num = 10
          },
          -- enable notifications for indexing progress
          notify = true,
          -- index all existing memories on startup
          -- (requires vectorcode 0.6.12+ for efficient incremental indexing)
          index_on_startup = false,
        },
      }
    }
  },
  display = {
    action_palette = {
      provider = 'snacks',
    },
  },
  interactions = {
    chat = {
      adapter = {
        name = "claude_code",
        model = "opus",
      },
    },
  },
  -- note: the log_level is in `opts.opts`
  opts = {
    log_level = "debug",
  },
}

return {
  "olimorris/codecompanion.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "ravitemer/codecompanion-history.nvim"
  },
  keys = {
    {
      "<leader>c",
      function() vim.cmd("CodeCompanionChat toggle") end,
      mode = { "n" },
      desc = "open codecompanionchat",
    },
    {
      "ch",
      function() vim.cmd("CodeCompanionHistory") end,
      mode = { "n" },
      desc = "open codecompanionchat",
    },
  },
  config = function()
    require("codecompanion").setup(opts)
  end,
}
