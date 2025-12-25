{
  description = "Multi-host macOS configuration using Nix Darwin + Home Manager for personal and work environments";

  inputs = {
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
    stylix.url = "github:danth/stylix";

    helix.url = "github:helix-editor/helix";
    rycee-nurpkgs = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nurpkgs.url = "github:nix-community/NUR";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-yazi-plugins = {
      url = "github:lordkekz/nix-yazi-plugins?ref=yazi-v0.2.5";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    nixvim,
    alejandra,
    stylix,
    nixos-hardware,
    ...
  } @ inputs: let
    inherit (self) outputs;
    users = import ./users.nix;
    systems = [
      "aarch64-darwin"
      "x86_64-linux"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
    system = forAllSystems (system: nixpkgs.legacyPackages.${system});
  in {
    nixosConfigurations = {
      home-nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./system/nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${users.nixos.username} = {
              imports = [
                ./home-manager/packages
                ./home-manager/hosts/home/nixos
              ];
            };
            home-manager.extraSpecialArgs = {
              inherit inputs;
              userConfig = users.nixos // {gitName = users.gitName;};
            };
          }
          stylix.nixosModules.stylix
        ];
      };
    };

    darwinConfigurations = {
      home-darwin = nix-darwin.lib.darwinSystem {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./system/darwin/home.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${users.home.username} = {
              imports = [
                ./home-manager/packages
                ./home-manager/hosts/home/darwin
              ];
            };
            home-manager.extraSpecialArgs = {
              inherit inputs;
              userConfig = users.home // {gitName = users.gitName;};
            };
          }
          stylix.darwinModules.stylix
        ];
      };
      work-darwin = nix-darwin.lib.darwinSystem {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./system/darwin/work.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${users.work.username} = {
              imports = [
                ./home-manager/packages
                ./home-manager/packages/granted
                ./home-manager/hosts/work/darwin
                ./home-manager/hosts/work/darwin/fish
              ];
            };
            home-manager.extraSpecialArgs = {
              inherit inputs;
              userConfig = users.work // {gitName = users.gitName;};
            };
          }
          stylix.darwinModules.stylix
        ];
      };
    };
  };
}
