{
  description = "NixOS Workstation (GNOME + Hyprland, Dev, Science, AI)";

  inputs = {
    # Pin stable via flake.lock
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;

        # Allow passing inputs into modules when needed
        specialArgs = { inherit inputs; };

        modules = [
          # Base system
          ./configuration.nix

          # Home Manager (integrated)
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.tco = import ./home/tco/home.nix;
          }
        ];
      };
    };
}
