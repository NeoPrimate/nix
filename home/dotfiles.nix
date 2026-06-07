{ config, ... }:
let
  repo = "${config.home.homeDirectory}/nix";
  link = path: config.lib.file.mkOutOfStoreSymlink path;
in {
  xdg.configFile = {
    "aerospace/aerospace.toml".source = link "${repo}/config/aerospace.toml";

    "alacritty/alacritty.toml".source                   = link "${repo}/config/alacritty/alacritty.toml";
    "alacritty/themes/catppuccin_macchiato.toml".source = link "${repo}/config/alacritty/themes/catppuccin_macchiato.toml";
    "alacritty/themes/tokyo_night_storm.toml".source    = link "${repo}/config/alacritty/themes/tokyo_night_storm.toml";

    "ghostty/config.ghostty".source = link "${repo}/config/ghostty/config.ghostty";
    "ghostty/shaders".source        = link "${repo}/config/ghostty/shaders";

    "helix/config.toml".source                      = link "${repo}/config/helix/config.toml";
    "helix/languages.toml".source                   = link "${repo}/config/helix/languages.toml";
    "helix/themes/catppuccin_macchiato.toml".source = link "${repo}/config/helix/themes/catppuccin_macchiato.toml";

    "karabiner/karabiner.json".source = link "${repo}/config/karabiner/karabiner.json";

    "starship.toml".source = link "${repo}/config/starship.toml";

    "yazi/yazi.toml".source = link "${repo}/config/yazi/yazi.toml";

    "zed/settings.json".source = link "${repo}/config/zed/settings.json";
    "zed/tasks.json".source    = link "${repo}/config/zed/tasks.json";

    "zellij/config.kdl".source          = link "${repo}/config/zellij/config.kdl";
    "zellij/layouts/default.kdl".source = link "${repo}/config/zellij/layouts/default.kdl";
    "zellij/layouts/dev.kdl".source     = link "${repo}/config/zellij/layouts/dev.kdl";
  };

  home.file = {
    ".zshrc".source                        = link "${repo}/zshrc";
    ".casty/config.json/casty.json".source = link "${repo}/config/casty/casty.json";
    ".local/bin/typst-preview".source      = link "${repo}/bin/typst-preview";

    "Library/Application Support/nushell/config.nu".source = link "${repo}/config/nushell/config.nu";
    "Library/Application Support/nushell/env.nu".source    = link "${repo}/config/nushell/env.nu";
  };
}
