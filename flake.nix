{
  description = "NixOS Workstation Configuration";

  inputs = {
    # --- Nixpkgs (Unstable Channel) ---
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # --- Home Manager ---
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # --- Rust Overlay (Latest Toolchain) ---
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, rust-overlay, ... }@inputs:
    let
      system = "x86_64-linux";
      
      # Initialize pkgs with overlays and unfree packages allowed
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ (import rust-overlay) ];
      };
    in
    {
      # ========================================================================
      # SYSTEM CONFIGURATION
      # ========================================================================
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.tco = import ./home/tco/home.nix;
          }
        ];
      };

      # ========================================================================
      # DEVELOPMENT ENVIRONMENTS (DevShells)
      # ========================================================================
      devShells.${system} = {
        
        # --- AI & Data Science (Python 3.11 + CUDA 12) ---
        # Usage: nix develop .#ai
        ai = pkgs.mkShell {
          name = "ai-lab";
          buildInputs = with pkgs; [
            pkgs.python311
            pkgs.git
            # Native compilation dependencies
            stdenv.cc.cc.lib
            zlib
            glib
            # CUDA Stack
            cudaPackages.cudatoolkit
            cudaPackages.cudnn
            cudaPackages.libcublas
            linuxPackages.nvidia_x11
            # Agentic
            ps.pip
            ps.openai
            ps.langchain
            ps.langgraph
          ];

          # Environment Setup for CUDA visibility
          shellHook = ''
            export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.linuxPackages.nvidia_x11}/lib:${pkgs.ncurses5}/lib:$LD_LIBRARY_PATH
            export CUDA_PATH=${pkgs.cudaPackages.cudatoolkit}
            export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
            export EXTRA_CCFLAGS="-I/usr/include"
            
            echo "🧠 AI Lab Activated (Python 3.11 + CUDA ${pkgs.cudaPackages.cudatoolkit.version})"
            echo "💡 Tip: Use 'uv venv' or 'python -m venv .venv' to install pip packages locally."
          '';
        };

        # --- Embedded Systems (C/C++, Rust, Arduino, ESP32) ---
        # Usage: nix develop .#embedded
        embedded = pkgs.mkShell {
          name = "embedded-lab";
          buildInputs = with pkgs; [
            # Rust (Latest Stable via Overlay)
            (pkgs.rust-bin.stable.latest.default.override {
              extensions = [ "rust-src" "rust-analyzer" ];
            })
            cargo-watch

            # C / C++ Toolchain
            gcc
            clang
            cmake
            gnumake
            gdb

            # Embedded Tooling
            arduino-ide
            arduino-cli
            esptool
            openocd
            minicom
            
            # Protocols
            mosquitto # MQTT
          ];
          
          shellHook = ''
            echo "Embedded Lab Activated (Rust, C++, Arduino, ESP32)"
          '';
        };
      };
    };
}
