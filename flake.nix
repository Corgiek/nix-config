{
  description = "corggie Flake";

  inputs = {
    # Official NixOS repo
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";

    # NixOS community
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:/nix-community/impermanence";
    stylix.url = "github:danth/stylix";

    # MacOS configuration
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland ecosystem
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1&rev=c5feee1e357f3c3c59ebe406630601c627807963";
    };

    xdghypr = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland/v1.3.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Unoficial users flakes
    any-nix-shell.url = "github:TheMaxMur/any-nix-shell";
    cryptopro.url = "github:SomeoneSerge/pkgs";

    # Security
    sops-nix.url = "github:Mic92/sops-nix";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Just for pretty flake.nix
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Zsh plugins
    powerlevel10k = {
      url = "github:romkatv/powerlevel10k";
      flake = false;
    };

    zsh-autosuggestions = {
      url = "github:zsh-users/zsh-autosuggestions";
      flake = false;
    };

    zsh-syntax-highlighting = {
      url = "github:zsh-users/zsh-syntax-highlighting";
      flake = false;
    };

    fzf-zsh-completions = {
      url = "github:chitoku-k/fzf-zsh-completions";
      flake = false;
    };

    zsh-history-substring-search = {
      url = "github:zsh-users/zsh-history-substring-search";
      flake = false;
    };

    zsh-auto-notify = {
      url = "github:MichaelAquilina/zsh-auto-notify";
      flake = false;
    };
  };

  outputs = { self, flake-parts, ... } @ inputs:
  let
    # Import helper funcfions
    libx = import ./lib { inherit self inputs; };

    # Description of hosts
    hosts = {
      pcbox = {
        hostname      = "pcbox";
        username      = "corg";
        platform      = "x86_64-linux";
        stateVersion  = "24.11";
        isWorkstation = true;
        wm            = "sway";
      };

      nbox = {
        hostname      = "nbox";
        username      = "corg";
        platform      = "x86_64-linux";
        stateVersion  = "24.11";
        isWorkstation = true;
        wm            = "sway";
      };

      rasp = {
        hostname      = "rasp";
        username      = "corg";
        platform      = "aarch64-linux";
        stateVersion  = "24.11";
        isWorkstation = false;
      };

      macbox = {
        hostname      = "macbox";
        username      = "corg";
        platform      = "aarch64-darwin";
        stateVersion  = 6;
        isWorkstation = true;
      };
    };
  in flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];

    flake = {
      nixosConfigurations = {
        ${hosts.pcbox.hostname} = libx.mkHost hosts.pcbox;
        ${hosts.nbox.hostname}  = libx.mkHost hosts.nbox;
        ${hosts.rasp.hostname}  = libx.mkHost hosts.rasp;
      };

      darwinConfigurations = {
        ${hosts.macbox.hostname} = libx.mkHostDarwin hosts.macbox;
      };

      templates = import "${self}/templates" { inherit self; };
    };
  };
}

