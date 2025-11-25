require("yousef.config")
require("yousef.lazy")
vim.filetype.add({
  extension = {
    gs = "javascript",
    tf = "terraform",
    tfvars = "terraform",
    hcl = "hcl",

  },
  filename = {
    ["test"] = "ruby",
  },
})
