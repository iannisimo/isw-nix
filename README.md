# isw-nix

YoyPa's [ISW / Ice-Sealed Wyvern](https://example.com) for nix.
It provides an easy solution to install and configure ISW as a nixos module.

## Usage

To use it add this flake to your nixos's flake inputs:

```nix
{
  # create an input called isw-nix, and set its url to this repository
  inputs.isw-nix.url = "github:iannisimo/isw-nix";
}
```

## Configuration

Please refer to [ISW README](https://github.com/YoyPa/isw/blob/master/README.md) for a detailed explaination of the configuration.

```nix
{
  inputs,
  ...
}: {
  imports = [ inputs.isw-nix.nixosModule ];
  services.isw = {
    enable = true;
    address_profile = "MSI_ADDRESS_DEFAULT";

    # The default section created by this configuration is `NIX`
    # By changhing this value it is possible to load a different section
    # - A default one already defined in the config file
    # - Or a custom one defined in extraConfig
    section = "NIX";

    # 12:  Auto mode
    # 76:  Simple mode
    # 140: Advanced mode
    fan_mode = 140;

    cpu = {
      temp = {
        _0 = 25;    # cpu_temp_0
        _1 = 37;    # cpu_temp_1
        _2 = 49;    # cpu_temp_2
        _3 = 61;    # cpu_temp_3
        _4 = 73;    # cpu_temp_4
        _5 = 85;    # cpu_temp_5
      };

      speed = {
        _0 = 10;    # cpu_fan_speed_0
        _1 = 25;    # cpu_fan_speed_1
        _2 = 40;    # cpu_fan_speed_2
        _3 = 55;    # cpu_fan_speed_3
        _4 = 70;    # cpu_fan_speed_4
        _5 = 85;    # cpu_fan_speed_5
        _6 = 100;   # cpu_fan_speed_6
      };
    };

    gpu = {
      temp = {
        _0 = 25;    # gpu_temp_0
        _1 = 37;    # gpu_temp_1
        _2 = 49;    # gpu_temp_2
        _3 = 61;    # gpu_temp_3
        _4 = 73;    # gpu_temp_4
        _5 = 85;    # gpu_temp_5
      };

      speed = {
        _0 = 10;    # gpu_fan_speed_0
        _1 = 25;    # gpu_fan_speed_1
        _2 = 40;    # gpu_fan_speed_2
        _3 = 55;    # gpu_fan_speed_3
        _4 = 70;    # gpu_fan_speed_4
        _5 = 85;    # gpu_fan_speed_5
        _6 = 100;   # gpu_fan_speed_6
      };
    };

    extraConfig = ''
      # This gets appended at the end of isw.conf
    '';
  };
}
```