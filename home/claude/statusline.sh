#!/usr/bin/env zsh
# MANAGED FILE - deployed to your home directory by the
# DevDesktop-mkarpoff-scripts Apollo package. Edits to the deployed copy are
# OVERWRITTEN on the next activation. Change the source in the package instead.
# Powerline-style status line matching zsh PS1 aesthetic
input=$(cat)

# Symbols (matching ~/.zsh_ps1)
typeset -A syms
syms=( RA '' RB '' LB '' LA '' BRANCH '' CLEAN '√' DIRTY '×' LOCAL 'Δ' STASH '→' AHEAD '↑' BHIND '↓' )

# Colors (matching ~/.zsh_ps1 256-color palette)
typeset -A c
c=(
  TERMF '\e[0m'
  BLKF '\e[38;5;0m'
  GRYF '\e[38;5;240m'
  GRYB '\e[48;5;240m'
  REDF '\e[38;5;160m'
  REDB '\e[48;5;160m'
  GREF '\e[38;5;70m'
  GREB '\e[48;5;70m'
  YELF '\e[38;5;178m'
  YELB '\e[48;5;178m'
  BLUF '\e[38;5;32m'
  BLUB '\e[48;5;32m'
  PRPF '\e[38;5;96m'
  PRPB '\e[48;5;96m'
  AQUF '\e[38;5;37m'
  AQUB '\e[48;5;37m'
  RSTB '\e[49m'
  RST '\e[0m'
)

# Extract fields from JSON
model=${${input##*'"display_name":"'}%%'"'*}
pct=${${input##*'"used_percentage":'}%%[,\}]*}
[[ "$pct" == "null" || -z "$pct" ]] && pct="0"
cwd=${${input##*'"current_dir":"'}%%'"'*}
session_id=${${input##*'"session_id":"'}%%'"'*}
vim_mode=${${input##*'"mode":"'}%%'"'*}

# Vim mode colors
case "$vim_mode" in
  INSERT)      vim_fg="${c[BLKF]}"  vim_bg="${c[PRPB]}"  vim_arrow="${c[PRPF]}" ;;
  NORMAL)      vim_fg="${c[BLKF]}"  vim_bg="${c[GREB]}"  vim_arrow="${c[GREF]}" ;;
  VISUAL*)     vim_fg="${c[BLKF]}"  vim_bg="${c[BLUB]}"  vim_arrow="${c[BLUF]}" ;;
  REPLACE)     vim_fg="${c[BLKF]}"  vim_bg="${c[REDB]}"  vim_arrow="${c[REDF]}" ;;
  *)           vim_fg="${c[BLKF]}"  vim_bg="${c[GRYB]}"  vim_arrow="${c[GRYF]}" ;;
esac

# Cache git and midway data
CACHE_FILE="/tmp/statusline-cache-${session_id:-$$}"
CACHE_MAX_AGE=10

cache_is_stale() {
  [[ ! -f "$CACHE_FILE" ]] || \
  [[ $(($(date +%s) - $(stat -c %Y "$CACHE_FILE" 2>/dev/null || stat -f %m "$CACHE_FILE" 2>/dev/null || echo 0))) -gt $CACHE_MAX_AGE ]]
}

if cache_is_stale; then
  git_branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null)
  if [[ -n "$git_branch" ]]; then
    git_repo=$(basename "$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)")
    git_dirty=$(git -C "$cwd" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    ahead=$(git -C "$cwd" rev-list "@{u}..HEAD" 2>/dev/null | wc -l | tr -d ' ')
    behind=$(git -C "$cwd" rev-list "HEAD..@{u}" 2>/dev/null | wc -l | tr -d ' ')
    stash=$(git -C "$cwd" stash list 2>/dev/null | wc -l | tr -d ' ')
  else
    git_repo="" git_dirty="" ahead="" behind="" stash=""
  fi

  midway=$("$HOME/.toolbox/bin/claude" amzn-statusline --format "{midway_session_length}" <<< "$input" 2>/dev/null)
  midway_clean=$(echo "$midway" | sed 's/\x1b\[[0-9;]*m//g')

  echo "${git_branch}|${git_repo}|${git_dirty}|${ahead}|${behind}|${stash}|${midway_clean}" > "$CACHE_FILE"
else
  IFS='|' read -r git_branch git_repo git_dirty ahead behind stash midway_clean < "$CACHE_FILE"
fi

# Build git segment
if [[ -n "$git_branch" ]]; then
  if [[ "$git_dirty" -gt 0 ]]; then
    status_indicator="${c[REDF]}${syms[DIRTY]}${git_dirty}${syms[LOCAL]}${c[BLKF]}"
  else
    status_indicator="${c[GREF]}${syms[CLEAN]}${c[BLKF]}"
  fi

  remote_delta=""
  [[ "$ahead" -gt 0 ]] && remote_delta="${remote_delta}${ahead}${syms[AHEAD]}"
  [[ "$behind" -gt 0 ]] && remote_delta="${remote_delta}${behind}${syms[BHIND]}"

  stash_indicator=""
  [[ "$stash" -gt 0 ]] && stash_indicator="${stash}${syms[STASH]}"

  git_info="${syms[BRANCH]}${git_repo}:${git_branch} ${status_indicator}${stash_indicator}${remote_delta}"

  git_seg="${c[PRPF]}${c[YELB]}${syms[RA]}${c[BLKF]} ${git_info} "
  git_to_next="${c[YELF]}${c[AQUB]}${syms[RA]}"
else
  git_seg=""
  git_to_next="${c[PRPF]}${c[AQUB]}${syms[RA]}"
fi

# Line 1: model | git | context% | midway
printf '%b' \
  "${c[GRYB]} ${c[GRYF]}${c[PRPB]}${syms[RA]}${c[BLKF]} ${model:-Claude} " \
  "${git_seg}" \
  "${git_to_next}${c[BLKF]} ${pct:-0}% " \
  "${c[AQUF]}${c[GREB]}${syms[RA]}${c[BLKF]} M:${midway_clean} " \
  "${c[GREF]}${c[RSTB]}${syms[RA]}${c[RST]}"
echo

# Line 2: vim mode | full path
printf '%b' \
  "${c[GRYB]} ${c[GRYF]}${vim_bg}${syms[RA]}${vim_fg} ${vim_mode:-??} ${vim_arrow}${c[BLUB]}${syms[RA]}${c[BLKF]} ${cwd} " \
  "${c[BLUF]}${c[RSTB]}${syms[RA]}${c[RST]}"
echo
