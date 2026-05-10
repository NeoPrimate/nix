# if "ZELLIJ" not-in $env {
#     zellij
# }

if "ZELLIJ" not-in $env {
    "config.nu loaded, about to start zellij" | save -f /tmp/nu-trace.txt
    zellij
    "zellij exited" | save --append /tmp/nu-trace.txt
}

def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	^yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != $env.PWD and ($cwd | path exists) {
		cd $cwd
	}
	rm -fp $tmp
}

def "typst-view" [file: path] {
    let pdf = ($file | path parse | update extension "pdf" | path join)
    typst compile $file
    if ($env.LAST_EXIT_CODE == 0) {
        mupdf $pdf &
    } else {
        osascript -e 'display notification "Typst compilation failed" with title "Typst Error"'
    }
}

mkdir ($nu.data-dir | path join "vendor/autoload")
zoxide init nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

alias dev = zellij action new-tab --layout dev

$env.config.show_banner = false
