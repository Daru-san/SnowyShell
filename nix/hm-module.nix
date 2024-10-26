self:
{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkMerge types;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption mkEnableOption;

  package = self.packages.${pkgs.system}.snowy-shell;
  cfg = config.programs.snowy-shell;
in
{
  options.programs.snowy-shell = {
    enable = mkEnableOption "Snowy wayland shell";

    systemd.enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        Enable systemd integration.
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    { home.packages = [ package ]; }
    (mkIf cfg.systemd.enable {
      systemd.user.services.snowy-shell = {
        Unit = {
          Description = "A wayland shell";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session-pre.target" ];
        };

        Service = {
          ExecStart = "${package}/bin/snowy-shell";
          Restart = "on-failure";
          KillMode = "mixed";
        };

        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    })
  ]);
}
