{
  nixConfig.bash-prompt-prefix = "(nix) ";

  # it is recommended to pin to a specific revision or tag of nixpkgs
  # e.g.:
  # inputs.nixpkgs.url = "github:nixos/nixpkgs/22.05"
  inputs.nixpkgs.url = "github:nixos/nixpkgs/22.05";

  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    # minimize how many nixpkgs we evaluate
    # might hit cache less
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.flake-compat = {
    url = github:edolstra/flake-compat;
    # minimize how many nixpkgs we evaluate
    # might hit cache less
    inputs.nixpkgs.follows = "nixpkgs";
    flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          # don't use overlays here
          # https://zimbatm.com/notes/1000-instances-of-nixpkgs
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          devShells.default = pkgs.callPackage ./nix/devShell.nix { };

          # useful for debugging with the Nix REPL
          passthru = { inherit pkgs; };
        }
      );
}
