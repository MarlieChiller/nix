{
  description = "NixOS + standalone home-manager config of marliechiller";

  inputs = {
    # common
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    alejandra = {
      url = "github:kamadorueda/alejandra/3.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixos
    ags.url = "github:Aylur/ags";
    matugen.url = "github:InioX/matugen?ref=v2.2.0";
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    helix.url = "github:helix-editor/helix";
    rycee-nurpkgs = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nurpkgs.url = "github:nix-community/NUR";

    # darwin
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    nixvim,
    alejandra,
    mac-app-util,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;

    # --- change this depending on system ---
    sys_config = {
      host = "home-laptop";
      # host = "MOCULON03"";
      user = "marliechiller";
      # user = "charliemiller";
      # ---------------------------------------
    };
    system = forAllSystems (system: nixpkgs.${system});
  in {
    nixosConfigurations = {
      "${sys_config.user}@${sys_config.host}" = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs sys_config;};
        modules = [
          ./hosts/nixos/configuration.nix
        ];
      };
    };

    darwinConfigurations = {
      "${sys_config.user}@${sys_config.host}" = nix-darwin.lib.darwinSystem {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin; # Home-manager requires 'pkgs' instance
        specialArgs = {inherit inputs outputs sys_config;};
        modules = [
          mac-app-util.darwinModules.default
          ./hosts/darwin/configuration.nix
        ];
      };
    };

    homeConfigurations = {
      "${sys_config.user}@${sys_config.host}" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs system sys_config;};
        modules = [
          ./home-manager/home.nix
        ];
      };
    };
  };
}
