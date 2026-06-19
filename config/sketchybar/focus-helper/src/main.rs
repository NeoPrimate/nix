//! Fast path for aerospace -> SketchyBar workspace highlighting.
//!
//! Invoked directly by aerospace's `exec-on-workspace-change` (which sets
//! `AEROSPACE_FOCUSED_WORKSPACE` / `AEROSPACE_PREV_WORKSPACE` in the env). Talks
//! to the running SketchyBar over its mach IPC socket — no PATH dependency, no
//! `sketchybar` CLI spawn — so it works from aerospace's minimal environment and
//! is about as fast as a per-switch update can be.
//!
//! It only recolors / toggles drawing. App-icon labels are owned by the bash
//! `aerospace_icons.sh` plugin (which also writes the cache this reads); icons
//! don't change on a mere focus switch, so we never touch `label=`.

use std::env;
use std::fs;

// Catppuccin Macchiato — keep in sync with config/sketchybar/colors.sh
const ACCENT: &str = "0xffc6a0f6"; // focused background (mauve)
const BASE: &str = "0xff24273a"; // focused fg (dark, on accent)
const SURFACE0: &str = "0xff363a4f"; // unfocused background
const TEXT: &str = "0xffcad3f5"; // unfocused fg

const CACHE: &str = "/tmp/sketchybar_spaces";

fn focused(sid: &str) -> String {
    format!("--set space.{sid} drawing=on background.color={ACCENT} icon.color={BASE} label.color={BASE}")
}

fn unfocused(sid: &str) -> String {
    format!("--set space.{sid} drawing=on background.color={SURFACE0} icon.color={TEXT} label.color={TEXT}")
}

fn hidden(sid: &str) -> String {
    format!("--set space.{sid} drawing=off")
}

fn main() {
    let focus = env::var("AEROSPACE_FOCUSED_WORKSPACE").unwrap_or_default();
    let prev = env::var("AEROSPACE_PREV_WORKSPACE").unwrap_or_default();
    if focus.is_empty() {
        return;
    }

    // Cache (written by aerospace_icons.sh): "ALL <sid...>" / "NONEMPTY <sid...>".
    let mut all: Vec<String> = Vec::new();
    let mut nonempty: Vec<String> = Vec::new();
    if let Ok(contents) = fs::read_to_string(CACHE) {
        for line in contents.lines() {
            if let Some(rest) = line.strip_prefix("ALL ") {
                all = rest.split_whitespace().map(str::to_string).collect();
            } else if let Some(rest) = line.strip_prefix("NONEMPTY ") {
                nonempty = rest.split_whitespace().map(str::to_string).collect();
            }
        }
    }
    let is_nonempty = |sid: &str| nonempty.iter().any(|s| s == sid);

    let mut parts: Vec<String> = Vec::new();

    if !prev.is_empty() && prev != focus {
        // Minimal update: only the two affected workspaces.
        parts.push(if is_nonempty(&prev) {
            unfocused(&prev)
        } else {
            hidden(&prev) // hide the empty desktop we just left
        });
        parts.push(focused(&focus)); // always draw focused, even if empty
    } else if !all.is_empty() {
        // Fallback: repaint all (first switch / unknown prev).
        for sid in &all {
            parts.push(if *sid == focus {
                focused(sid)
            } else if is_nonempty(sid) {
                unfocused(sid)
            } else {
                hidden(sid)
            });
        }
    } else {
        // No cache yet: at least highlight the focused workspace.
        parts.push(focused(&focus));
    }

    // One batched IPC message (tokens are space-safe: no labels, no spaces).
    // Second arg is the bar name; None uses the default bar.
    let _ = sketchybar_rs::message(&parts.join(" "), None);
}
