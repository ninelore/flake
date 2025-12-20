#!/usr/bin/env nu
def main [] {
	print "checking flake validity..."
	let flakepath = try { (nix flake metadata --quiet --quiet --json | from json | get resolvedUrl | url parse | get path) } catch { null }
	if ( $flakepath | path exists ) {
		$flakepath | save -f $"($env.HOME)/.flakepath"
		print "success"
		exit 0
	}
	print "failed"
	exit 1
}
