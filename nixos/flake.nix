{
  description = "NixOS config (modulaire) pour host nixos";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs, ... }@inputs:
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
        # Passe les inputs aux modules si besoin (specialArgs.inputs)
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
        ];
      };
    };

    # (Optionnel) petit devShell
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [ git ];
    };
  };
}
