{
  description = "Yousef's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      darwinSystem = "aarch64-darwin";
      x86DarwinSystem = "x86_64-darwin";
      
      pkgs = nixpkgs.legacyPackages.${system};
      darwinPkgs = nixpkgs.legacyPackages.${darwinSystem};
      x86DarwinPkgs = nixpkgs.legacyPackages.${x86DarwinSystem};
    in {
      homeConfigurations = {
        # Linux configuration
        "yousef@linux" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          modules = [ ./home.nix ];
          extraSpecialArgs = { inherit system; };
        };
        
        # macOS Apple Silicon configuration
        "yousef@darwin" = home-manager.lib.homeManagerConfiguration {
          pkgs = darwinPkgs;
          modules = [ ./home.nix ];
          extraSpecialArgs = { system = darwinSystem; };
        };
        
        # macOS Intel configuration
        "yousef@darwin-x86" = home-manager.lib.homeManagerConfiguration {
          pkgs = x86DarwinPkgs;
          modules = [ ./home.nix ];
          extraSpecialArgs = { system = x86DarwinSystem; };
        };
      };
    };
}