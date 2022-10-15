{ config, pkgs, specialArgs, ... }:

let
  nixpkgs = specialArgs.nixpkgs;
  nixpkgs-unstable = specialArgs.nixpkgs-unstable;
in {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "roni";
  home.homeDirectory = "/home/roni";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.03";

  home.file = with nixpkgs; {
    # XMonad.
    ".xmonad/xmonad.hs".source = substituteAll {
      src = ./sources/xmonad/xmonad.hs;

      alacritty = "${alacritty}/bin/alacritty";
      rofi = "${rofi}/bin/rofi";
      nmcli = "${networkmanager}/bin/nmcli";
      elgato = "${elgato}/bin/elgato";
      xbacklight = "${xorg.xbacklight}/bin/xbacklight";
      xlock = "${xlockmore}/bin/xlock";
      xrandr = "${xorg.xrandr}/bin/xrandr";
      xmobar = "${xmobar}/bin/xmobar";
      xmonad = "${xmonad-with-packages}/bin/xmonad";
    };

    ".xmonad/xmobarrc".source = ./sources/xmonad/xmobarrc;

    ".xmonad/battpercent.sh".source = nixpkgs.substituteAll {
      src = ./sources/xmonad/battpercent.sh;
      isExecutable = true;

      acpi = "${acpi}/bin/acpi";
    };

    # Alacritty.
    ".config/alacritty/alacritty.yml".source = ./sources/alacritty/alacritty.yml;

    # Git.
    ".gitconfig".source = nixpkgs.substituteAll {
      src = ./sources/git/gitconfig;

      diffsofancy = "${diff-so-fancy}/bin/diff-so-fancy";
    };

    # Neovim.
    ".config/nvim/init.vim".source = ./sources/neovim/init.vim;

    # Tmux.
    ".tmux.conf".source = ./sources/tmux/tmux.conf;

    # ZShell.
    ".zshrc".source = ./sources/zsh/zshrc;
  };
}
