return {
  "github/copilot.vim",
  event = "InsertEnter",
  config = function()
    vim.g.copilot_filetypes = {
      ["go"] = true,
      ["python"] = true,
      ["javascript"] = true,
      ["typescript"] = true,
      ["lua"] = true,
      ["html"] = true,
      ["css"] = true,
      ["markdown"] = true,
      ["json"] = true,
      ["yaml"] = true,
      ["bash"] = true,
      ["sh"] = true,
      ["vim"] = true,
      ["c"] = true,
      ["cpp"] = true,
      ["java"] = true,
      ["ruby"] = true,
      ["graphql"] = true,
      ["dockerfile"] = true,
      ["terraform"] = true,
      ["makefile"] = true,
      ["cmake"] = true,
      ["sql"] = true,
      ["fish"] = true,
    }
  end
}
