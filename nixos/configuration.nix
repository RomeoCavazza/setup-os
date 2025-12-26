# ==============================================================================
#  HYPRLAND MAIN CONFIGURATION
# ==============================================================================

# --- MONITOR CONFIGURATION ---
monitor = ,preferred,auto,1.25

# --- AUTOSTART ---
exec-once = waybar

# --- ENVIRONMENT VARIABLES ---
env = LIBSEAT_BACKEND,logind

# --- TOOLS & APPLICATIONS ---
$terminal    = foot
$fileManager = nemo
$menu        = $HOME/.config/rofi/scripts/rofi-push.sh 
$powermenu   = $HOME/.config/rofi/scripts/rofi-push.sh

# ==============================================================================
#  APPEARANCE & THEME
# ==============================================================================
general {
    layout = dwindle
    gaps_in = 8
    gaps_out = 16
    border_size = 2
    
    # Colors
    col.active_border = rgba(94e2d5ff)
    col.inactive_border = rgba(595959aa)
    
    resize_on_border = true
}

decoration {
    rounding = 10
    active_opacity = 0.90
    inactive_opacity = 0.80

    blur {
        enabled = true
        size = 6
        passes = 3
        new_optimizations = true
        ignore_opacity = true
        noise = 0.01
        contrast = 0.9
        brightness = 0.8
        vibrancy = 0.1696
    }

    shadow {
        enabled = true
        range = 4
        render_power = 3
        color = rgba(1a1a1aee)
    }
}

animations {
    enabled = yes
    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
    
    animation = windows, 1, 3, myBezier
    animation = windowsOut, 1, 3, default, popin 80%
    animation = border, 1, 3, default
    animation = fade, 1, 3, default
    animation = workspaces, 1, 3, default
}

dwindle {
    pseudotile = true
    preserve_split = true
}

misc {
    force_default_wallpaper = 2
    disable_hyprland_logo = false
}

# ==============================================================================
#  INPUT DEVICES
# ==============================================================================
input {
    kb_layout = fr
    kb_options = caps:ctrl_modifier
    follow_mouse = 1
    natural_scroll = yes
    
    touchpad {
        natural_scroll = yes
    }
}

# ==============================================================================
#  WINDOW & LAYER RULES
# ==============================================================================

# --- ROFI DOCK STYLING ---
windowrulev2 = float, class:^(Rofi)$
windowrulev2 = move 0 0, class:^(Rofi)$
windowrulev2 = pin, class:^(Rofi)$
windowrulev2 = noborder, class:^(Rofi)$
windowrulev2 = noshadow, class:^(Rofi)$
windowrulev2 = size 110 100%, class:^(Rofi)$
# Force opacity for blur effect
windowrulev2 = opacity 0.85 override 0.85 override, class:^(Rofi)$

# --- WAYBAR STYLING ---
layerrule = blur, waybar
layerrule = ignorezero, waybar

# ==============================================================================
#  KEYBINDINGS
# ==============================================================================
$mod = SUPER

# --- Core Actions ---
bind = $mod, Return, exec, $terminal
bind = $mod, Tab,    exec, $fileManager
bind = $mod, Space,  exec, $powermenu
bind = $mod, Q,      killactive
bind = $mod, F,      togglefloating
bind = $mod, V,      fullscreen, 0

# --- AI Agent Launcher (Specific) ---
bind = $mod, twosuperior, exec, foot -e bash -lc "cd /home/tco/dev/ai-lab && nix develop -c python agent_cli.py"

# --- Layout Management ---
bind = $mod, less, layoutmsg, togglesplit

# --- Focus Movement ---
bind = $mod, left,  movefocus, l
bind = $mod, right, movefocus, r
bind = $mod, up,    movefocus, u
bind = $mod, down,  movefocus, d

# --- Window Movement (Super + Ctrl) ---
bind = SUPER CTRL, Left,  moveactive, -50 0
bind = SUPER CTRL, Right, moveactive, 50 0
bind = SUPER CTRL, Up,    moveactive, 0 -50
bind = SUPER CTRL, Down,  moveactive, 0 50

# --- Window Swapping (Super + Shift) ---
bind = SUPER SHIFT, Left,  swapwindow, l
bind = SUPER SHIFT, Right, swapwindow, r
bind = SUPER SHIFT, Up,    swapwindow, u
bind = SUPER SHIFT, Down,  swapwindow, d

# --- Window Resizing (Super + Alt) ---
bind = SUPER ALT, Left,  resizeactive, -30 0
bind = SUPER ALT, Right, resizeactive, 30 0
bind = SUPER ALT, Up,    resizeactive, 0 -30
bind = SUPER ALT, Down,  resizeactive, 0 30

# --- Mouse Bindings ---
bindm = $mod, mouse:272, movewindow
bindm = $mod, mouse:273, resizewindow

# --- Workspaces (French Azerty) ---
bind = $mod, ampersand, workspace, 1
bind = $mod, eacute,    workspace, 2
bind = $mod, quotedbl,  workspace, 3
bind = $mod, apostrophe, workspace, 4
bind = $mod, parenleft, workspace, 5

bind = $mod SHIFT, ampersand, movetoworkspace, 1
bind = $mod SHIFT, eacute,    movetoworkspace, 2
bind = $mod SHIFT, quotedbl,  movetoworkspace, 3
bind = $mod SHIFT, apostrophe, movetoworkspace, 4
bind = $mod SHIFT, parenleft, movetoworkspace, 5

# --- Media & Screenshots ---
bind = , F1, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
bind = , F2, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bind = , F3, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
bind = SUPER SHIFT, S, exec, grim -g "$(slurp)" - | swappy -f -

# ==============================================================================
#  FIX PIXELISATION (XWAYLAND)
# ==============================================================================
# Empêche Hyprland d'étirer les vieilles applis (Cursor, Discord, etc.)
# Résultat : Elles seront NETTES, mais peut-être petites (il faudra zoomer dedans).
xwayland {
  force_zero_scaling = true
}
