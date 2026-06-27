#!/usr/bin/env -S nu --stdin
def main [arg?: string] {
  let input = if $arg != null {$arg} else {$in}
  $input |
  str replace --all "\n" '' |
  str replace --all ' ' '' |
  decode base64 |
  decode
}
