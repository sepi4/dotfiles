#!/usr/bin/env bash
INPUT=$(cat)

{
  IFS= read -r VCS_BRANCH
  IFS= read -r VCS_DIRTY
  IFS= read -r DIR
} < <(
  jq -r '
    (.vcs.branch // ""),
    (if .vcs.dirty == true then "true" elif .vcs.dirty == false then "false" else "" end),
    (.workspace.current_dir // .cwd // "")
  ' <<< "$INPUT"
)

BRANCH=""
DIRTY="false"

if [[ -n "$VCS_BRANCH" ]]; then
  BRANCH="$VCS_BRANCH"
  [[ "$VCS_DIRTY" == "true" ]] && DIRTY="true"
else
  TARGET_DIR="${DIR:-$PWD}"
  if BRANCH=$(git -C "$TARGET_DIR" symbolic-ref --short HEAD 2>/dev/null || git -C "$TARGET_DIR" rev-parse --short HEAD 2>/dev/null); then
    if ! git -C "$TARGET_DIR" diff --quiet --ignore-submodules 2>/dev/null \
       || ! git -C "$TARGET_DIR" diff --cached --quiet --ignore-submodules 2>/dev/null; then
      DIRTY="true"
    fi
  else
    BRANCH=""
  fi
fi

jq -r --arg branch "$BRANCH" --argjson dirty "$DIRTY" '
  def color($p):
    if $p >= 75 then "\u001b[31m"
    elif $p >= 50 then "\u001b[38;5;208m"
    elif $p >= 25 then "\u001b[33m"
    else "\u001b[32m"
    end;
  def reset: "\u001b[0m";
  def dim: "\u001b[2m";
  def cyan: "\u001b[36m";
  def pct($v): (((1 - $v.remaining_fraction) * 100) | round);
  def fmt_pct($p): "\(color($p))\($p)%\(reset)";
  def active($q; $k):
    ($q[$k] | type == "object") and ($q[$k].disabled != true) and ($q[$k].remaining_fraction != null);
  def group($q; $name; $h; $w):
    [
      (if active($q; $h) then "5h:\(fmt_pct(pct($q[$h])))" else empty end),
      (if active($q; $w) then "w:\(fmt_pct(pct($q[$w])))" else empty end)
    ] | if length > 0 then "\($name) \(join(" "))" else empty end;

  .context_window as $c |
  (if ($c.context_window_size // 0) > 0 then
    (($c.used_percentage // 0) | round) as $p |
    ((($c.used_percentage // 0) * $c.context_window_size / 100000) | round) as $used_k |
    (($c.context_window_size / 1000) | round) as $max_k |
    "Ctx \(fmt_pct($p)) \(dim)(\($used_k)k/\($max_k)k)\(reset)"
  else
    "Ctx -"
  end) as $ctx |
  (.quota // {}) as $q |
  [
    (if ($branch | length) > 0 then
      "\(cyan)\($branch)\(if $dirty then "\u001b[33m*" else "" end)\(reset)"
    else
      empty
    end),
    $ctx,
    group($q; "Gem"; "gemini-5h"; "gemini-weekly"),
    group($q; "3p"; "3p-5h"; "3p-weekly"),
    (
      $q | to_entries[]
      | select((.key | IN("gemini-5h", "gemini-weekly", "3p-5h", "3p-weekly") | not)
               and (.value | type == "object" and (.disabled != true) and (.remaining_fraction != null)))
      | "\(.key | sub("weekly"; "w")):\(fmt_pct(pct(.value)))"
    )
  ] | join(" \(dim)|\(reset) ")
' <<< "$INPUT"
