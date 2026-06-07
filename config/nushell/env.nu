$env.PATH = (
    $env.PATH
    | split row (char esep)
    | prepend [
        '/run/current-system/sw/bin'
        $"/etc/profiles/per-user/($env.USER)/bin"
        '/nix/var/nix/profiles/default/bin'
        $"($env.HOME)/.nix-profile/bin"
        '/opt/homebrew/bin'
    ]
    | append [
        $"($env.HOME)/.local/bin"
        $"($env.HOME)/.cargo/bin"
        "/usr/local/bin"
    ]
    | uniq
)

# Nix: surface installed apps to Spotlight / `open`, and point tools at the cert bundle
$env.XDG_DATA_DIRS = ([
    "/nix/var/nix/profiles/default/share"
    $"($env.HOME)/.nix-profile/share"
    ($env.XDG_DATA_DIRS? | default "/usr/local/share:/usr/share")
] | str join ":")

$env.NIX_SSL_CERT_FILE = "/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt"

$env.ENABLE_CLAUDEAI_MCP_SERVERS = "false"
