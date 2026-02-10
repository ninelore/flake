#!/usr/bin/env nu
def --wrapped main [...args: string] {
    let inFlake = (nix flake metadata | complete | get exit_code) == 0
    if ($env.HOME + '/.flakepath' | path exists) and not $inFlake {
        $env.NH_FLAKE = open ($env.HOME + '/.flakepath')
        cd (open ($env.HOME + '/.flakepath'))
        echo $"Set flake path (pwd) as NH_FLAKE"
    }
    if (ping -c1 github.com | complete | get exit_code) == 0 { git pull --autostash }
    run0 nixos-rebuild --refresh --flake . ...$args
}
