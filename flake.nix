{
  description = "FFTW bindings for the xtensor C++ multi-dimensional array library.";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = rec {
          default = pkgs.stdenv.mkDerivation (finalAttrs: {
            name = "xtensor-fftw";

            # version = "0.2.6";
            # version = "e6be85a376624da10629b6525c81759e02020308";
            version = "master";

            src = pkgs.fetchFromGitHub {
              owner = "Xyhlon";
              repo = "xtensor-fftw";
              rev = finalAttrs.version;
              hash = "sha256-JeXs4aolaMC2eFaDfzPBzj6eMX+Hd+l9Szbrgm/E4SY=";
            };

            nativeBuildInputs = with pkgs; [cmake libgcc pkg-config];

            propagatedBuildInputs = with pkgs; [
              fftw
              fftwQuad
              fftwFloat
              fftwLongDouble
              xtensor
              xtl
            ];

            meta = with pkgs.lib; {
              description = "FFTW bindings for the xtensor C++ multi-dimensional array library.";
              homepage = "https://github.com/Xyhlon/xtensor-fftw";
              license = licenses.bsd3;
              # maintainers = with maintainers; [ cpcloud ];
              platforms = platforms.all;
            };
          });
        };
        formatter = nixpkgs.legacyPackages.${system}.alejandra;
      }
    );
}
