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

use std::collections::HashMap;
use std::env;
use std::fs;

const CACHE: &str = "/tmp/sketchybar_spaces";

/// The four colors this helper needs, loaded from config/sketchybar/colors.sh —
/// the single source of truth shared with the bash plugins.
struct Theme {
    accent: String,   // focused background
    base: String,     // focused foreground (on accent)
    surface0: String, // unfocused background
    text: String,     // unfocused foreground
}

impl Theme {
    /// Parse colors.sh, resolving one level of `$VAR` indirection (e.g.
    /// `ACCENT=$MAUVE`). Built-in Catppuccin Macchiato values are an inert
    /// fallback used only if the file can't be read (it always exists in a
    /// deployed config, so in practice colors.sh is the only source).
    fn load() -> Theme {
        let mut vars: HashMap<String, String> = HashMap::new();
        if let Ok(home) = env::var("HOME") {
            if let Ok(contents) = fs::read_to_string(format!("{home}/.config/sketchybar/colors.sh")) {
                for raw in contents.lines() {
                    let line = raw.trim();
                    let line = line.strip_prefix("export ").unwrap_or(line);
                    if let Some((name, val)) = line.split_once('=') {
                        // drop inline comments / surrounding quotes / whitespace
                        let val = val.split('#').next().unwrap_or("").trim().trim_matches('"');
                        if !val.is_empty() {
                            vars.insert(name.trim().to_string(), val.to_string());
                        }
                    }
                }
            }
        }
        let get = |key: &str, default: &str| -> String {
            match vars.get(key) {
                Some(v) => match v.strip_prefix('$') {
                    // role points at a palette var (ACCENT=$MAUVE) -> resolve it
                    Some(reference) => vars.get(reference).cloned().unwrap_or_else(|| default.into()),
                    None => v.clone(),
                },
                None => default.into(),
            }
        };
        Theme {
            accent: get("ACCENT", "0xffc6a0f6"),
            base: get("BASE", "0xff24273a"),
            surface0: get("SURFACE0", "0xff363a4f"),
            text: get("TEXT", "0xffcad3f5"),
        }
    }

    fn focused(&self, sid: &str) -> String {
        format!(
            "--set space.{sid} drawing=on background.color={} icon.color={} label.color={}",
            self.accent, self.base, self.base
        )
    }

    fn unfocused(&self, sid: &str) -> String {
        format!(
            "--set space.{sid} drawing=on background.color={} icon.color={} label.color={}",
            self.surface0, self.text, self.text
        )
    }
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

    let theme = Theme::load();

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
            theme.unfocused(&prev)
        } else {
            hidden(&prev) // hide the empty desktop we just left
        });
        parts.push(theme.focused(&focus)); // always draw focused, even if empty
    } else if !all.is_empty() {
        // Fallback: repaint all (first switch / unknown prev).
        for sid in &all {
            parts.push(if *sid == focus {
                theme.focused(sid)
            } else if is_nonempty(sid) {
                theme.unfocused(sid)
            } else {
                hidden(sid)
            });
        }
    } else {
        // No cache yet: at least highlight the focused workspace.
        parts.push(theme.focused(&focus));
    }

    // One batched IPC message (tokens are space-safe: no labels, no spaces).
    // Second arg is the bar name; None uses the default bar.
    let _ = sketchybar_rs::message(&parts.join(" "), None);
}
