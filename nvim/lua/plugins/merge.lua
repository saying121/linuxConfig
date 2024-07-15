return {
    "whiteinge/diffconflicts",
    --     build = [[
    -- git config --global merge.tool diffconflicts
    -- git config --global mergetool.diffconflicts.cmd 'vim -c DiffConflictsWithHistory "$MERGED" "$BASE" "$LOCAL" "$REMOTE"'
    -- git config --global mergetool.diffconflicts.trustExitCode true
    -- git config --global mergetool.keepBackup false
    --     ]],
    cmd = { "DiffConflicts", "DiffConflictsWithHistory", "DiffConflictsShowHistory" },
}
