# `rgb <preset>`: switch every RGB device to a named lighting preset.
# Presets are plain OpenRGB CLI arguments rather than GUI profiles: profiles
# match devices by location (/dev/hidrawN can move), and `--profile` reports
# success even for a name that doesn't exist. Mode names come from `openrgb -l`.
{
  lib,
  writeShellApplication,
  gamemode,
  gnugrep,
  openrgb,
  util-linux,
}: let
  gpu = mode: ["-d" "Sapphire" "-m" mode];
  mouse = mode: ["-d" "Glorious" "-m" mode];
  board = mode: ["-d" "B850M" "-m" mode];
  color = hex: ["-c" hex];
  speed = percent: ["-s" (toString percent)];

  # active is rainbow, idle blue, and gaming a colour cycle at the slowest speed so
  # it doesn't distract when playing on the TV. The GPU has no coloured effects,
  # only Static, and the wireless mouse stays dark while idle to save battery.
  # The board avoids Direct: it only reaches the LEDs in OpenRGB's zone sizes
  # (1 per ARGB header), leaving fans on their old colour.
  presets = {
    active = gpu "Rainbow Wave" ++ speed 50 ++ mouse "Rainbow Wave" ++ speed 50 ++ board "Wave 1";
    idle = gpu "Static" ++ color "5E81AC" ++ mouse "Off" ++ board "Breathing" ++ color "88C0D0" ++ speed 10;
    gaming = gpu "Spectrum Cycle" ++ speed 0 ++ mouse "Spectrum Cycle" ++ speed 0 ++ board "Color Cycle" ++ speed 0;
    off = gpu "Off" ++ mouse "Off" ++ board "Static" ++ color "000000";
  };

  names = lib.attrNames presets;
  cases = lib.concatLines (lib.mapAttrsToList (name: args: "  ${name}) args=(${lib.escapeShellArgs args}) ;;") presets);
in
  writeShellApplication {
    name = "rgb";
    runtimeInputs = [gamemode gnugrep openrgb util-linux];
    excludeShellChecks = ["SC2054"]; # commas in `-c A,B` are for openrgb, not bash
    text = ''
      preset=''${1:-}

      # `auto` is the right look for now: gaming during a GameMode session, else active
      if [ "$preset" = auto ]; then
        if gamemoded -s | grep -q "is active"; then preset=gaming; else preset=active; fi
      fi

      case "$preset" in
      ${cases}
        *)
          echo "usage: rgb <auto ${lib.concatStringsSep " " names}>" >&2
          exit 2
          ;;
      esac

      # Hooks can fire close together; overlapping runs would interleave device writes
      exec 9>"''${XDG_RUNTIME_DIR:-/tmp}/rgb.lock"
      flock -w 20 9

      # Saving a profile too keeps each applied preset listed in the OpenRGB GUI.
      # openrgb exits 0 even when a device rejects a mode, so check its output
      output=$(openrgb --noautoconnect "''${args[@]}" --save-profile "$preset" 2>&1)
      if grep -q "^Error" <<<"$output"; then
        logger -t rgb "preset $preset failed: $output"
        echo "$output" >&2
        exit 1
      fi
      logger -t rgb "preset: $preset"
    '';
  }
