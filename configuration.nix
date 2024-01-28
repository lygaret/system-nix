{ config, pkgs, ... }:
{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
      consoleMode = "auto";
    };

    efi = {
      canTouchEfiVariables = true;
    };
  };

  # networking
  networking.hostName = "feynman"; 
  networking.networkmanager.enable = true;

  # locales 
  console.keyMap = "dvorak";
  time.timeZone = "America/Denver";
  i18n.defaultLocale = "en_US.UTF-8";

  # graphics
  services.xserver = {
    enable = true;

    layout = "us";
    xkbVariant = "dvorak";
    xkbOptions = "ctrl:nocaps";
    
    #displayManager.gdm.enable = true;
    #desktopManager.gnome.enable = true;

    # displayManager.sddm.enable = true;
    # desktopManager.plasma5.enable = true;
   
    displayManager.lightdm.enable = true;
    desktopManager.budgie.enable = true;
  };

  # audio
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # printing
  services.printing.enable = true;

  # users
  users.users.jonathan = {
    isNormalUser = true;
    description  = "jonathan";
    extraGroups  = [ "networkmanager" "wheel" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
    htop

    # dconf
    desktop-file-utils

    emacs29

    birdtray
    thunderbird-bin

    # wine
    # winetricks
    # lutris # used to get adobe digital editions in wine
    # calibre

    plasma-browser-integration
    xdg-desktop-portal-kde
    (firefox.override {
      nativeMessagingHosts = [
        pkgs.plasma-browser-integration
      ];
    })
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = ["jonathan"];
  };

  services.openssh.enable = true;

  services.emacs = {
    enable = true;
    startWithGraphical = true;
    defaultEditor = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
