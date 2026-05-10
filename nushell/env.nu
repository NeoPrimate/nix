$env.PATH = (
    $env.PATH
    | split row (char esep)
    | prepend '/opt/homebrew/bin'
    | append [
        $"($env.HOME)/.local/bin"
        $"($env.HOME)/.cargo/bin"
        "/usr/local/bin"
    ]
    | uniq
)

$env.ENABLE_CLAUDEAI_MCP_SERVERS = "false"
