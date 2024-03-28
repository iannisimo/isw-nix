{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.services.isw;
  iswPkg = pkgs.callPackage ./isw.nix { };
in {
  options.services.isw = {
    enable = lib.mkEnableOption "YoyPa's isw";

    section = lib.mkOption {
      description = "Section to enable from isw.conf";
      type = lib.types.str;
      default = "NIX";
    };

    address_profile = lib.mkOption {
      description = "The isw addess profile to use";
      type = lib.types.str;
      default = "MSI_ADDRESS_DEFAULT";
    };

    fan_mode = lib.mkOption {
      description = "Value of fan_mode can be 140, 76 or 12, for Advanced, Basic or Auto. Advanced seems to work better with suspend/hibernate.";
      type = lib.types.int;
      default = 140;
    };

    extraConfig = lib.mkOption {
      description = "Extra configuration appended to isw.conf";
      type = lib.types.str;
      default = "";
      example = ''
        [section]

        address_profile = MSI_ADDRESS_DEFAULT
        fan_mode = 140
        ...
      '';
    };

    cpu = {
      temp = ( 
        builtins.listToAttrs (
          builtins.map (
            x: { 
              name = "_" + builtins.toString x; 
              value = lib.mkOption {
                description = "cpu_temp_" + x;
                type = lib.types.int;
                default = 25 + 12*x;
              }; 
            }
          ) [ 0 1 2 3 4 5 ]
        ) 
      );
      speed = ( 
        builtins.listToAttrs (
          builtins.map (
            x: { 
              name = "_" + builtins.toString x; 
              value = lib.mkOption {
                description = "cpu_fan_speed_" + x;
                type = lib.types.int;
                default = 10 + 15*x;
              }; 
            }
          ) [ 0 1 2 3 4 5 6 ]
        ) 
      );
    };

    gpu = {
      temp = ( 
        builtins.listToAttrs (
          builtins.map (
            x: { 
              name = "_" + builtins.toString x; 
              value = lib.mkOption {
                description = "gpu_temp_" + x;
                type = lib.types.int;
                default = 25 + 12*x;
              }; 
            }
          ) [ 0 1 2 3 4 5 ]
        ) 
      );
      speed = ( 
        builtins.listToAttrs (
          builtins.map (
            x: { 
              name = "_" + builtins.toString x; 
              value = lib.mkOption {
                description = "gpu_fan_speed_" + x;
                type = lib.types.int;
                default = 10 + 15*x;
              }; 
            }
          ) [ 0 1 2 3 4 5 6 ]
        ) 
      );
    };
  };

  config = lib.mkIf cfg.enable ({
    environment.systemPackages = [ iswPkg ];

    systemd.services.isw = {
      description = "ISW fan control service";
      after = [ "sleep.target" ];
      wantedBy = [ "multi-user.target" "sleep.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecPreStart = "sleep 2s";
        ExecStart = "${iswPkg}/bin/isw -w ${cfg.section}";
      };
    };

    boot.kernelModules = [ "ec_sys" ];
    boot.extraModprobeConfig = lib.mkOrder 153 "options ec_sys write_support=1";

    environment.etc."isw.conf".text = (
      builtins.readFile "${iswPkg}/etc/isw.conf"
    ) + (''

      [NIX]

      address_profile = ${cfg.address_profile}
      fan_mode = ${builtins.toString cfg.fan_mode}

    '') + "\n" + (
      lib.strings.concatStringsSep "\n" (
        builtins.map (
          x: ( "cpu_temp_" + (builtins.toString x ) + " = " + ( builtins.toString cfg.cpu.temp."_${x}" ) )
        ) [ "0" "1" "2" "3" "4" "5" ]
      )
    ) + "\n" + (
      lib.strings.concatStringsSep "\n" (
        builtins.map (
          x: ( "cpu_fan_speed_" + (builtins.toString x ) + " = " + ( builtins.toString cfg.cpu.speed."_${x}" ) )
        ) [ "0" "1" "2" "3" "4" "5" "6" ]
      )
    ) + "\n" + (
      lib.strings.concatStringsSep "\n" (
        builtins.map (
          x: ( "gpu_temp_" + (builtins.toString x ) + " = " + ( builtins.toString cfg.gpu.temp."_${x}" ) )
        ) [ "0" "1" "2" "3" "4" "5" ]
      )
    ) + "\n" + (
      lib.strings.concatStringsSep "\n" (
        builtins.map (
          x: ( "gpu_fan_speed_" + (builtins.toString x ) + " = " + ( builtins.toString cfg.gpu.speed."_${x}" ) )
        ) [ "0" "1" "2" "3" "4" "5" "6" ]
      )
    ) + "\n" + cfg.extraConfig;
  });
}