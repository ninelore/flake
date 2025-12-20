#!/usr/bin/env nu
def --wrapped main [...args: string] {
	if (nix flake metadata | complete | get exit_code) == 0 {
		$env.NH_FLAKE = '.'
	} else if ($env.HOME + '/.flakepath' | path exists) {
		$env.NH_FLAKE = (open ($env.HOME + '/.flakepath'))
		echo $"Set NH_FLAKE to ($env.NH_FLAKE)"
	} else {
		error make {msg: "No flake found"}
	}
	if (ping -c1 github.com | complete | get exit_code) == 0 {
		git -C $env.NH_FLAKE pull --autostash
	}
	nh ...$args
}
