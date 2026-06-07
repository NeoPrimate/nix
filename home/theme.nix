{ ... }: {
  # Shared theme values. Each tool spells catppuccin slightly differently,
  # so we expose per-tool names. Override one entry to change just one app,
  # or rewrite all of them to switch flavor everywhere.
  _module.args.theme = {
    helix     = "catppuccin_macchiato";
    alacritty = "catppuccin_macchiato";
    ghostty   = "Catppuccin Macchiato";
    zellij    = "catppuccin-macchiato";
    zed       = "Catppuccin Macchiato - No Italics";
  };
}
