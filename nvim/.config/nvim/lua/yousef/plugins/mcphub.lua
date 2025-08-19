return {
  "ravitemer/mcphub.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  build = "npm install -g mcp-hub@latest",
  event = "VeryLazy",
  config = function()
    require("mcphub").setup({
      -- Server configuration
      port = 37373,
      config = vim.fn.expand("~/.config/mcphub/servers.json"), -- Absolute path to MCP Servers config file (will create if not exists)
      global_env = {
        GITHUB_PERSONAL_ACCESS_TOKEN = os.getenv("GITHUB_PERSONAL_ACCESS_TOKEN") or "",
      },
      -- UI Configuration
      ui = {
        window = {
          width = 0.85,
          height = 0.85,
          align = "center",
          border = "rounded",
          relative = "editor",
          zindex = 50,
        },
      },

      -- Server management
      shutdown_timeout = 600000, -- 10 minutes
      request_timeout = 30000,   -- 30 seconds

      -- Auto-approval for tool execution (set to false for safety)
      auto_approve = false,

      extensions = {
        copilotchat = {
          enabled = true,
          convert_tools_to_functions = true,     -- Convert MCP tools to CopilotChat functions
          convert_resources_to_functions = true, -- Convert MCP resources to CopilotChat functions
          add_mcp_prefix = false,                -- Add "mcp_" prefix to function names
        }
      },

      -- Native Lua MCP Servers examples
      native_servers = {
        -- File system operations server
        filesystem = {
          name = "filesystem",
          capabilities = {
            tools = {
              {
                name = "read_file",
                description = "Read contents of a file",
                inputSchema = {
                  type = "object",
                  properties = {
                    path = { type = "string", description = "File path to read" }
                  },
                  required = { "path" }
                },
                handler = function(req, res)
                  local path = req.params.path
                  local file = io.open(path, "r")
                  if file then
                    local content = file:read("*a")
                    file:close()
                    return res:text("File content:\n" .. content):send()
                  else
                    return res:error("Could not read file: " .. path):send()
                  end
                end
              },
              {
                name = "list_directory",
                description = "List contents of a directory",
                inputSchema = {
                  type = "object",
                  properties = {
                    path = { type = "string", description = "Directory path to list" }
                  },
                  required = { "path" }
                },
                handler = function(req, res)
                  local path = req.params.path or "."
                  local handle = io.popen("ls -la '" .. path .. "'")
                  if handle then
                    local result = handle:read("*a")
                    handle:close()
                    return res:text("Directory listing for " .. path .. ":\n" .. result):send()
                  else
                    return res:error("Could not list directory: " .. path):send()
                  end
                end
              }
            }
          }
        },

        -- Git operations server
        git = {
          name = "git",
          capabilities = {
            tools = {
              {
                name = "git_status",
                description = "Get git repository status",
                inputSchema = {
                  type = "object",
                  properties = {}
                },
                handler = function(req, res)
                  local handle = io.popen("git status --porcelain")
                  if handle then
                    local result = handle:read("*a")
                    handle:close()
                    return res:text("Git status:\n" .. result):send()
                  else
                    return res:error("Could not get git status"):send()
                  end
                end
              },
              {
                name = "git_log",
                description = "Get recent git commits",
                inputSchema = {
                  type = "object",
                  properties = {
                    count = { type = "number", description = "Number of commits to show", default = 10 }
                  }
                },
                handler = function(req, res)
                  local count = req.params.count or 10
                  local handle = io.popen("git log --oneline -n " .. count)
                  if handle then
                    local result = handle:read("*a")
                    handle:close()
                    return res:text("Recent commits:\n" .. result):send()
                  else
                    return res:error("Could not get git log"):send()
                  end
                end
              }
            }
          }
        }
      }
    })
  end,

  keys = {
    -- Main MCP Hub interface
    {
      "<leader>Mh",
      "<cmd>MCPHub<cr>",
      desc = "Open MCP Hub interface"
    },

    -- Integration with CopilotChat
    {
      "<leader>aM",
      function()
        -- Open CopilotChat with MCP context
        require("CopilotChat").ask("Use @mcp to help with this code", {
          selection = function(source)
            return require("CopilotChat.select").visual(source) or
                require("CopilotChat.select").buffer(source)
          end,
        })
      end,
      desc = "Ask CopilotChat with MCP tools"
    },
  }
}
