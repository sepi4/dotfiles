#!/usr/bin/env bash
jq -r '
  def color($p):
    if $p >= 75 then "\u001b[31m"
    elif $p >= 50 then "\u001b[38;5;208m"
    elif $p >= 25 then "\u001b[33m"
    else "\u001b[32m"
    end;
  def reset: "\u001b[0m";
  def dim: "\u001b[2m";
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
  (
    [
      group($q; "Gem"; "gemini-5h"; "gemini-weekly"),
      group($q; "3p"; "3p-5h"; "3p-weekly"),
      (
        $q | to_entries[]
        | select((.key | IN("gemini-5h", "gemini-weekly", "3p-5h", "3p-weekly") | not)
                 and (.value | type == "object" and (.disabled != true) and (.remaining_fraction != null)))
        | "\(.key | sub("weekly"; "w")):\(fmt_pct(pct(.value)))"
      )
    ] | join(" \(dim)|\(reset) ")
  ) as $qs |
  if ($qs | length) > 0 then "\($ctx) \(dim)|\(reset) \($qs)" else $ctx end
'
