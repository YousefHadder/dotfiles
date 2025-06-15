return {
  'nmac427/guess-indent.nvim',
  config = function()
    require('guess-indent').setup({
      auto_cmd = true,                                                       -- Automatically run on BufRead and BufNewFile
      filetype_exclude = { 'netrw', 'TelescopePrompt', 'TelescopeResults' }, -- Exclude certain filetypes
      buftype_exclude = { 'terminal', 'nofile' },                            -- Exclude certain buffer types
      indent_style = 'space',                                                -- Use spaces for indentation
      indent_size = 2,                                                       -- Set the size of the indent to 2 spaces
    })
  end,
}
