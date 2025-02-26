# SPDX-FileCopyrightText: 2022 The Standard Authors
# SPDX-FileCopyrightText: 2022 Kevin Amado <kamadorueda@gmail.com>
{
  inputs,
  cell,
}: let
  nixpkgs = inputs.nixpkgs;
in {
  default = let
    version = "0.10.0+dev";
  in
    nixpkgs.buildGoModule rec {
      inherit version;
      pname = "std";
      meta = {
        description = "A tui for projects that conform to Standard";
        license = nixpkgs.lib.licenses.unlicense;
        homepage = "https://github.com/divnix/std";
        maintainers = with nixpkgs.lib.maintainers; [blaggacao];
      };

      src = ./cli;

      vendorSha256 = "sha256-nT98rJtnATPNQYi1a29H7H8xd4JLEACSawR+Cn5eyYg=";

      nativeBuildInputs = [nixpkgs.installShellFiles];

      postInstall = ''
        installShellCompletion --cmd std \
          --bash <($out/bin/std _carapace bash) \
          --fish <($out/bin/std _carapace fish) \
          --zsh <($out/bin/std _carapace zsh)
      '';

      ldflags = [
        "-s"
        "-w"
        "-X main.buildVersion=${version}"
      ];
    };
}
