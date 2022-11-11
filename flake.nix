{
  description = "Segger J-Link Software and Documentation pack";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = {self, nixpkgs}: 
    let

      supportedSystems =
        [ "x86_64-linux" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { 
        inherit system; 
        config = {
          allowUnfree = true;
          segger-jlink.acceptLicense = true;
        };
      });

    in {

      packages = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in rec {

          segger-jlink = pkgs.callPackage ./segger-jlink.nix { };

          default = segger-jlink;

        });
        
    };
}