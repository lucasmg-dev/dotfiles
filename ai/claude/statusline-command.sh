#!/usr/bin/env bash
# Claude Code statusLine — 2 lines:
#   L1: project [branch (worktree)] - Model - ▓▓▓░░░░░░░ NN%   (bar = context window used)
#   L2: 5h: NN% / HH:MM                                        (5-hour rate limit + reset time)
input=$(cat)

# --- Rosé Pine (main) palette (truecolor) ---
C_BLUE=$'\033[38;2;156;207;216m'    # project   (foam  #9ccfd8)
C_MAUVE=$'\033[38;2;196;167;231m'   # branch    (iris  #c4a7e7)
C_TEXT=$'\033[38;2;224;222;244m'    # model     (text  #e0def4)
C_GREEN=$'\033[38;2;49;116;143m'    # bar <50% / reset time (pine #31748f)
C_YELLOW=$'\033[38;2;246;193;119m'  # bar 50-80% (gold  #f6c177)
C_RED=$'\033[38;2;235;111;146m'     # bar >=80%  (love  #eb6f92)
C_DIM=$'\033[38;2;110;106;134m'     # separators / empty bar (muted #6e6a86)
C_BOLD=$'\033[1m'
C_RST=$'\033[0m'

SEP="${C_DIM} - ${C_RST}"

# --- Parse fields ---
project_dir=$(printf '%s' "$input" | jq -r '.workspace.project_dir // .workspace.current_dir // .cwd // ""')
current_dir=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(printf '%s' "$input" | jq -r '.model.display_name // empty')
ctx=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // 0')
tok_used=$(printf '%s' "$input" | jq -r '.context_window.total_input_tokens // empty')
tok_total=$(printf '%s' "$input" | jq -r '.context_window.context_window_size // empty')
wt=$(printf '%s' "$input" | jq -r '.worktree.name // .workspace.git_worktree // empty')
five_h=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_h_reset=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')

# --- Pick threshold color for a 0-100 value ---
threshold_color() {
  if [ "$1" -lt 50 ]; then printf '%s' "$C_GREEN"
  elif [ "$1" -lt 80 ]; then printf '%s' "$C_YELLOW"
  else printf '%s' "$C_RED"
  fi
}

# --- Format a raw token count -> "60k" / "1M" / "1.5M" (>=1000k becomes M) ---
fmt_tokens() {
  awk -v t="$1" 'BEGIN{
    k = int(t/1000 + 0.5)
    if (k >= 1000) {
      m = int((k/1000)*10 + 0.5)/10
      if (m == int(m)) printf "%dM", m; else printf "%.1fM", m
    } else printf "%dk", k
  }'
}

# === Line 1 ============================================================
# Project name (basename of the project root)
project=$(basename "$project_dir" 2>/dev/null)
[ -z "$project" ] && project="?"
l1="${C_BOLD}${C_BLUE}${project}${C_RST}"

# Branch (run git per render; payload has no branch). Append worktree in parens.
branch=""
[ -n "$current_dir" ] && branch=$(git -C "$current_dir" rev-parse --abbrev-ref HEAD 2>/dev/null)
if [ -n "$branch" ]; then
  if [ -n "$wt" ]; then
    l1="${l1} ${C_MAUVE}[${branch} (${wt})]${C_RST}"
  else
    l1="${l1} ${C_MAUVE}[${branch}]${C_RST}"
  fi
fi

# Model
[ -n "$model" ] && l1="${l1}${SEP}${C_TEXT}${model}${C_RST}"

# Context window bar (10 segments)
ctx_int=$(awk -v p="$ctx" 'BEGIN{ printf "%d", p+0.5 }')
width=10
filled=$(awk -v p="$ctx" -v w="$width" 'BEGIN{ f=int((p/100*w)+0.5); if(f<0)f=0; if(f>w)f=w; print f }')
full=""; empty=""; i=0
while [ "$i" -lt "$filled" ]; do full="${full}▓"; i=$((i + 1)); done
while [ "$i" -lt "$width" ]; do empty="${empty}░"; i=$((i + 1)); done
bcol=$(threshold_color "$ctx_int")
tokens_part=""
if [ -n "$tok_used" ] && [ -n "$tok_total" ]; then
  uk=$(fmt_tokens "$tok_used")
  tk=$(fmt_tokens "$tok_total")
  tokens_part=" ${C_DIM}(${uk}/${tk} tokens)${C_RST}"
fi
l1="${l1}${SEP}${bcol}${full}${C_DIM}${empty}${C_RST} ${bcol}${ctx_int}%${C_RST}${tokens_part}"

# === Line 2 (only for Pro/Max, after first API response) ==============
l2=""
if [ -n "$five_h" ]; then
  fh_int=$(awk -v p="$five_h" 'BEGIN{ printf "%d", p+0.5 }')
  fcol=$(threshold_color "$fh_int")
  l2="${C_DIM}Used in 5h: ${C_RST}${fcol}${fh_int}%${C_RST}"
  if [ -n "$five_h_reset" ]; then
    rt=$(date -r "$five_h_reset" +%H:%M 2>/dev/null)
    [ -n "$rt" ] && l2="${l2}${C_DIM} - Resets at ${C_RST}${C_GREEN}${rt}${C_RST}"
  fi
fi

# === Output ============================================================
printf '%s' "$l1"
[ -n "$l2" ] && printf '\n%s' "$l2"
