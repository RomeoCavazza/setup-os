{
  description = "NixOS config (modulaire) pour host nixos";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    # Ajout de Home Manager
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = { inherit inputs; };

        modules = [
          ./configuration.nix

          # Module Home Manager intégré à NixOS
          home-manager.nixosModules.home-manager

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.tco = {
              # à adapter si tu changes de version un jour
              home.stateVersion = "25.05";
            };
          }
        ];
      };
    };

    # DevShell optionnel
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [ git ];
    };
  };
}
