lockdir=$(mktemp -d)
trap 'rm -r "$lockdir"' EXIT

# lazy writes lockfile after a restore, store copy is read only
cp "$LOCKFILE" "$lockdir/lazy-lock.json"
chmod u+w "$lockdir/lazy-lock.json"

# treeshitter config builds parsers in background, so nvim waits for them before it quits
parser_build_timeout_ms=$((10 * 60 * 1000))
wait_for_parsers="lua require('nvim-treesitter').install(require('plugins.treeshitter').opts.parsers):wait($parser_build_timeout_ms)"

# plugin build steps call tools from user and system profiles
PATH="$PATH:$PROFILE_BIN:/run/current-system/sw/bin" \
	LAZY_LOCKFILE="$lockdir/lazy-lock.json" \
	nvim --headless "+Lazy! restore" "+Lazy! clean" "+$wait_for_parsers" +qa
