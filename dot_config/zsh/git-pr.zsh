# git-pr.zsh - Async PR info for shell prompt
# Provides clickable PR links in the prompt without blocking on `gh` calls.
#
# How it works:
#   1. precmd calls _update_pr_cache which runs `gh pr view` in the background
#   2. The result is written to a cache file (~/.cache/git-pr/<repo>/<branch>)
#   3. _git_pr_prompt reads the cache synchronously (instant, just a file read)
#   4. The prompt is never blocked; PR info is at most one render stale

_GIT_PR_CACHE_DIR="$HOME/.cache/git-pr"

# Extract a repo identifier from the git remote URL
# Handles both SSH (git@github.com:org/repo.git) and HTTPS formats
_git_repo_id() {
  local url
  url=$(git remote get-url origin 2>/dev/null) || return 1
  url="${url%.git}"
  if [[ "$url" == git@* ]]; then
    echo "${url#*:}" | tr '/' '_'
  else
    echo "$url" | sed 's|.*/\([^/]*/[^/]*\)$|\1|' | tr '/' '_'
  fi
}

# Sanitize a branch name for use as a filename (slashes become underscores)
_sanitize_branch() {
  echo "${1//\//_}"
}

# Run `gh pr view` in the background and cache the result.
# Called from precmd so it fires after every command.
_update_pr_cache() {
  git rev-parse --git-dir &>/dev/null || return

  local branch repo_id cache_dir cache_file safe_branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null) || return
  repo_id=$(_git_repo_id) || return
  [[ -z "$branch" || -z "$repo_id" ]] && return

  safe_branch=$(_sanitize_branch "$branch")
  cache_dir="$_GIT_PR_CACHE_DIR/$repo_id"
  cache_file="$cache_dir/$safe_branch"

  # Skip if cache is fresh (< 30 seconds old)
  if [[ -f "$cache_file" ]]; then
    local now age mtime
    now=$(date +%s)
    mtime=$(stat -f %m "$cache_file" 2>/dev/null || echo 0)
    age=$(( now - mtime ))
    (( age < 30 )) && return
  fi

  # Background: query gh and write plain-text cache "number url"
  (
    mkdir -p "$cache_dir" 2>/dev/null
    local pr_info
    pr_info=$(gh pr view --json number,url --jq '"\(.number) \(.url)"' 2>/dev/null)
    if [[ $? -eq 0 && -n "$pr_info" ]]; then
      echo "$pr_info" > "$cache_file"
    else
      echo "" > "$cache_file"
    fi
  ) &>/dev/null &!
}

# Read cached PR info and format it as a clickable prompt segment.
# Uses OSC 8 hyperlinks (supported by Kitty, iTerm2, WezTerm, etc.)
_git_pr_prompt() {
  git rev-parse --git-dir &>/dev/null || return

  local branch repo_id cache_file safe_branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null) || return
  repo_id=$(_git_repo_id) || return
  [[ -z "$branch" || -z "$repo_id" ]] && return

  safe_branch=$(_sanitize_branch "$branch")
  cache_file="$_GIT_PR_CACHE_DIR/$repo_id/$safe_branch"
  [[ ! -f "$cache_file" ]] && return

  local content number url
  content=$(<"$cache_file" 2>/dev/null) || return
  [[ -z "$content" ]] && return

  number="${content%% *}"
  url="${content#* }"
  [[ -z "$number" ]] && return

  # OSC 8 clickable hyperlink, wrapped in %{...%} so zsh doesn't count
  # the escape bytes toward prompt width
  printf ' %%{\e]8;;%s\e\\%%}%%F{magenta}#%s%%f%%{\e]8;;\e\\%%}' "$url" "$number"
}
