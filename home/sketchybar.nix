{ pkgs, lib, ... }:
let
  # Compiled helper that aerospace's exec-on-workspace-change runs to move the
  # SketchyBar workspace highlight over IPC (no PATH dependency, no CLI spawn).
  # Source lives in config/sketchybar/focus-helper.
  aerospace-sketchybar-focus = pkgs.rustPlatform.buildRustPackage {
    pname = "aerospace-sketchybar-focus";
    version = "0.1.0";
    # Exclude the local `target/` dir so cargo build artifacts don't enter the
    # store / change the source hash.
    src = lib.cleanSourceWith {
      src = ../config/sketchybar/focus-helper;
      filter = path: _type: builtins.baseNameOf path != "target";
    };
    cargoLock.lockFile = ../config/sketchybar/focus-helper/Cargo.lock;
  };
in {
  home.packages = [ aerospace-sketchybar-focus ];
}
