lockdir=$(mktemp -d)
trap 'rm -r "$lockdir"' EXIT

# lazy writes lockfile after a restore, store copy is read only
cp "$LOCKFILE" "$lockdir/lazy-lock.json"
chmod u+w "$lockdir/lazy-lock.json"

# plugin build steps call tools from user and system profiles
PATH="$PATH:$PROFILE_BIN:/run/current-system/sw/bin" \
	LAZY_LOCKFILE="$lockdir/lazy-lock.json" \
	nvim --headless "+Lazy! restore" "+Lazy! clean" +qa
