{
  nixConfig.bash-prompt-suffix = "(nix) ";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.flake-compat = {
    url = github:edolstra/flake-compat;
    flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    let
      overlay = import ./nix/overlay.nix;
    in
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ overlay ];
          };
        in
        {
          devShell = pkgs.callPackage ./nix/devShell.nix { };

          passthru = { inherit pkgs; };
        }
      )
    // {
      inherit overlay;
    };
}
