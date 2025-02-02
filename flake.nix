{
  description = "Nix flake for Foxglove Studio";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = { self, nixpkgs }: 
  let 
    pkgs_amd64_linux = import nixpkgs { system = "x86_64-linux"; };
    pkgs_aarch64_linux = import nixpkgs { system = "aarch64-linux"; };
  in 
  {
    packages.x86_64-linux.default = pkgs_amd64_linux.stdenv.mkDerivation {
      pname = "foxglove-studio";
      version = "latest";

      src = builtins.fetchurl {
        url = "https://get.foxglove.dev/desktop/latest/foxglove-studio-latest-linux-amd64.deb";
        sha256 = "06hl2v7cwmkx1422zaqx5pbviw7iqydvkwdvcy157r1bbsvr302f"; # Replace if incorrect
      };

      nativeBuildInputs = [ pkgs_amd64_linux.dpkg pkgs_amd64_linux.autoPatchelfHook ];
      buildInputs = with pkgs_amd64_linux; [
      alsa-lib
      atk
      cairo
      dbus
      glib
      gtk3
      libxkbcommon
      mesa
      nspr
      nss
      ];
      
      installPhase = ''
        mkdir -p $out
        dpkg-deb -x $src ./extracted
        mv "./extracted/opt/Foxglove Studio" "$out/Foxglove Studio"
        rm -rf "./extracted/opt/Foxglove Studio"
        mkdir -p $out/bin
        ln -s $out/Foxglove\ Studio/foxglove-studio $out/bin/foxglove-studio
      '';

      postFixup = ''
        autoPatchelf $out/Foxglove\ Studio/foxglove-studio --ignore-missing libffmpeg.so # I dont know why this is not being found
      '';

      meta = with nixpkgs.lib; {
        description = "Foxglove Studio - visualization tool for robotics data";
        homepage = "https://foxglove.dev";
        license = licenses.mit;
        platforms = platforms.linux;
      };
    };
    packages.aarch64-linux.default = pkgs_aarch64_linux.stdenv.mkDerivation {
      pname = "foxglove-studio";
      version = "latest";

      src = builtins.fetchurl {
        url = "https://get.foxglove.dev/desktop/latest/foxglove-studio-latest-linux-arm64.deb";
        sha256 = "00qvx430pia69kvj8f8jvxvkh8x13hymxy7k59pd4z4l5wciwdr4"; # Replace if incorrect
      };

      nativeBuildInputs = [ pkgs_aarch64_linux.dpkg pkgs_aarch64_linux.autoPatchelfHook ];
      buildInputs = with pkgs_aarch64_linux; [
      alsa-lib
      atk
      cairo
      dbus
      glib
      gtk3
      libxkbcommon
      mesa
      nspr
      nss
      ];
      
      installPhase = ''
        mkdir -p $out
        dpkg-deb -x $src ./extracted
        mv "./extracted/opt/Foxglove Studio" "$out/Foxglove Studio"
        rm -rf "./extracted/opt/Foxglove Studio"
        mkdir -p $out/bin
        chmod +X $out/Foxglove\ Studio/foxglove-studio
        ln -s $out/Foxglove\ Studio/foxglove-studio $out/bin/foxglove-studio
      '';

      postFixup = ''
        autoPatchelf $out/Foxglove\ Studio/foxglove-studio --ignore-missing libffmpeg.so # I dont know why this is not being found
      '';

      meta = with nixpkgs.lib; {
        description = "Foxglove Studio - visualization tool for robotics data";
        homepage = "https://foxglove.dev";
        license = licenses.mit;
        platforms = platforms.linux;
      };
    };
  };
}
