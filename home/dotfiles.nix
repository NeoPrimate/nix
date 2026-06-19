{ config, theme, ... }:
let
  repo = "${config.home.homeDirectory}/nix";
  link = path: config.lib.file.mkOutOfStoreSymlink path;

  # Render a config file with theme substitutions applied.
  # subs is an attrset of "needle" -> "replacement".
  themed = file: subs: builtins.replaceStrings
    (builtins.attrNames subs)
    (builtins.attrValues subs)
    (builtins.readFile file);
in {
  xdg.configFile = {
    "aerospace/aerospace.toml".source = link "${repo}/config/aerospace.toml";

    "alacritty/alacritty.toml".text = themed ../config/alacritty/alacritty.toml {
      "catppuccin_macchiato.toml" = "${theme.alacritty}.toml";
    };
    "alacritty/themes/catppuccin_macchiato.toml".source = link "${repo}/config/alacritty/themes/catppuccin_macchiato.toml";
    "alacritty/themes/tokyo_night_storm.toml".source    = link "${repo}/config/alacritty/themes/tokyo_night_storm.toml";

    "ghostty/config.ghostty".text = themed ../config/ghostty/config.ghostty {
      "theme = catppuccin-macchiato" = "theme = ${theme.ghostty}";
    };
    "ghostty/shaders".source = link "${repo}/config/ghostty/shaders";

    "helix/config.toml".text = themed ../config/helix/config.toml {
      "theme = \"catppuccin_macchiato\"" = "theme = \"${theme.helix}\"";
    };
    "helix/languages.toml".source                   = link "${repo}/config/helix/languages.toml";
    "helix/themes/catppuccin_macchiato.toml".source = link "${repo}/config/helix/themes/catppuccin_macchiato.toml";

    "karabiner/karabiner.json".source = link "${repo}/config/karabiner/karabiner.json";

    "sketchybar".source = link "${repo}/config/sketchybar";

    "starship.toml".source = link "${repo}/config/starship.toml";

    "yazi/yazi.toml".source = link "${repo}/config/yazi/yazi.toml";

    "zed/settings.json".text = themed ../config/zed/settings.json {
      "\"theme\": \"Catppuccin Macchiato - No Italics\"" = "\"theme\": \"${theme.zed}\"";
    };
    "zed/tasks.json".source = link "${repo}/config/zed/tasks.json";

    "zellij/config.kdl".text = themed ../config/zellij/config.kdl {
      "theme \"catppuccin-macchiato\"" = "theme \"${theme.zellij}\"";
    };
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
