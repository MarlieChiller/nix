{
  description = "";

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
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    nixvim,
    alejandra,
    stylix,
    mac-app-util,
    ...
  } @ inputs: let
    inherit (self) outputs;
    home_user = "marliechiller";
    systems = [
      "aarch64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
    system = forAllSystems (system: nixpkgs.legacyPackages.${system});
  in {
    darwinConfigurations = {
      "${home_user}@mba" = nix-darwin.lib.darwinSystem {
        pkgs = import nixpkgs { system = "aarch64-darwin"; config.allowUnfree = true; };
#        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        specialArgs = {inherit inputs outputs;};
        modules = [
          system/home/configuration.nix
          mac-app-util.darwinModules.default
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.marliechiller = import home-manager/hosts/home/default.nix;
            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
          stylix.darwinModules.stylix
        ];
      };
      "charliemiler@MOCULON03" = nix-darwin.lib.darwinSystem {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        specialArgs = {inherit inputs outputs;};
        modules = [
          system/work/configuration.nix
          mac-app-util.darwinModules.default
#          home-manager.darwinModules.home-manager
#          {
#            home-manager.useGlobalPkgs = true;
#            home-manager.useUserPackages = true;
#            home-manager.users.charliemiller = import ./hosts/work/default.nix;
#          }
#                              stylix.homeManagerModules.stylix

        ];
      };
    };
   };
}
