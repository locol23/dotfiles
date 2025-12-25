local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("VimEnter", {
    group = augroup("autoupdate"),
    callback = function()
        if require("lazy.status").has_updates then
            require("lazy").update({ show = false, })
        end
    end,
})

-- Auto reload files when they are changed externally
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    group = augroup("auto_reload"),
    pattern = "*",
    command = "if mode() != 'c' | checktime | endif",
})

-- Notify when file is reloaded from disk
vim.api.nvim_create_autocmd("FileChangedShellPost", {
    group = augroup("auto_reload_notify"),
    pattern = "*",
    callback = function()
        vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.WARN)
    end,
})

-- Auto expand all folds when opening Markdown files
vim.api.nvim_create_autocmd({ "BufReadPost", "BufWinEnter" }, {
    group = augroup("markdown_unfold"),
    pattern = "*.md",
    command = "normal! zR",
})
