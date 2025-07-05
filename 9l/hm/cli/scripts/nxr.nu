def main [args?: string = ""] {
	let inFlake: bool = ( nix flake metadata | complete | get exit_code ) == 0 
	if ($env.HOME + '/.flakepath' | path exists) and not $inFlake {
		cd (open ($env.HOME + '/.flakepath'))
	echo $"Entered flake directory (pwd)"
	}
	if (ping -c1 github.com | complete | get exit_code) == 0 {
		git pull --ff-only --autostash
	}
	run0 nixos-rebuild --flake . $args
}
