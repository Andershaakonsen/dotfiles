return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = function(_, opts)
    opts.filesystem = opts.filesystem or {}
    local fi = opts.filesystem.filtered_items or {}

    -- Keep hidden items toggleable with `H` (don't force them always-visible)
    fi.visible = false

    -- === satoru-only ignore list ===
    -- Names listed here are hidden ONLY inside the satoru vault, not in other
    -- projects. They're still on disk and tracked by git — just not shown by
    -- default. Press `H` in neo-tree to reveal them (dimmed).
    -- Add more folder/file names here as needed.
    local satoru_ignore = {
      "Archive",
      "Excalidraw",
      "assets",
      "scripts",
      "CLAUDE.md",
      "index.md",
    }

    fi.hide_by_pattern = fi.hide_by_pattern or {}
    for _, name in ipairs(satoru_ignore) do
      -- path-scoped glob: only matches items under a `satoru/` folder
      table.insert(fi.hide_by_pattern, "*/satoru/" .. name)
    end

    -- To hide something so it stays hidden even when toggling with `H`,
    -- use never_show_by_pattern instead:
    -- fi.never_show_by_pattern = fi.never_show_by_pattern or {}
    -- table.insert(fi.never_show_by_pattern, "*/satoru/assets")

    opts.filesystem.filtered_items = fi
  end,
}
