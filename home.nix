{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "vipul.gupta";
  home.homeDirectory = "/Users/vipul.gupta";
  nixpkgs.config.allowUnfree = true;
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    nix-output-monitor # https://github.com/maralorn/nix-output-monitor
    nix-info
    cachix
    lazygit # Better git UI
    fzf
    ripgrep # Better `grep`
    nil # Nix language server
  ];
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/vipulgupta/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };
  nix.gc = {
    automatic = true;
    # Change how often the garbage collector runs (default: weekly)
    # frequency = "monthly";
  };
  # Let Home Manager install and manage itself.
  # programs.home-manager.enable = true;
  programs = {
    # on macOS, you probably don't need this
    home-manager = {
      enable = true;
    };

    emacs = {                              
      enable = false;
      extraPackages = epkgs: [
        epkgs.nix-mode
        epkgs.magit
      ];
    };

    bash = {
      enable = true;
      initExtra = ''
        # Make Nix and home-manager installed things available in PATH.
        export PATH=/run/current-system/sw/bin/:/nix/var/nix/profiles/default/bin:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:$PATH
        
        alias enc="sh /Users/vipul.gupta/Desktop/utils/encrypt/encrypt.sh android"
        alias encios="sh /Users/vipul.gupta/Desktop/utils/encrypt/encrypt.sh ios"
        alias loadenv='source ~/Repo/lightbox/.env'
        # alias python="python3"
        # alias python="/opt/homebrew/bin/python3.11"
        # alias pip="/opt/homebrew/bin/pip3.11"
        alias k="kubectl"
        #Path to run Euler build
        # export PATH="$PATH:/Users/vipul.gupta/Desktop/Backend/euler-tools/euler-bin"

        # The next line updates PATH for the Google Cloud SDK.
        if [ -f '/Users/vipul.gupta/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '/Users/vipul.gupta/Downloads/google-cloud-sdk/path.bash.inc'; fi

        # The next line enables shell command completion for gcloud.
        if [ -f '/Users/vipul.gupta/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/vipul.gupta/Downloads/google-cloud-sdk/completion.bash.inc'; fi

        export PATH="/opt/homebrew/sbin:$PATH"
        export PATH="/opt/homebrew/bin:$PATH"
        # export PATH="/usr/local/opt/postgresql/bin:$PATH"
        export PATH=/opt/homebrew/bin:$PATH
        export PATH=/opt/homebrew/opt/ruby/bin:$PATH
        # export PATH="/usr/local/opt/postgresql@9.6/bin:$PATH"
        # export PATH="/usr/local/opt/postgresql@9.6/bin:$PATH"
        # export NVM_DIR=~/.nvm
        # source $(brew --prefix nvm)/nvm.sh
        export NVM_DIR="$HOME/.nvm"
        [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
        [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

        export LDFLAGS="-L/opt/homebrew/opt/mysql-client/lib"
        export CPPFLAGS="-I/opt/homebrew/opt/mysql-client/include"

        export LDFLAGS="-L/opt/homebrew/opt/libpq/lib"
        export CPPFLAGS="-I/opt/homebrew/opt/libpq/include"
        export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

        export PKG_CONFIG_PATH="/opt/homebrew/opt/mysql-client/lib/pkgconfig"

        export ANDROID_HOME=$HOME/Library/Android/sdk
        export PATH=$PATH:$HOME/.cargo/env
        export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
        export PATH=$PATH:$ANDROID_HOME/emulator
        export PATH=$PATH:$ANDROID_HOME/platform-toolsexport PATH="/usr/local/opt/openjdk@17/bin:$PATH"
        export PATH=$PATH:/Users/vipul.gupta/.cargo/bin
        eval "$(direnv hook bash)"
        # eval $(minikube -p minikube docker-env)
      '';
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    # For macOS's default shell.
    zsh = {
      enable = true;
      autocd = true;
      dotDir = ".config/zsh";
      autosuggestion.enable = false;
      enableCompletion = false;
      shellAliases = {
        l = "ls -la";
      };
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "sudo"
          "git"
          "terraform"
          "systemadmin"
          "vi-mode"
        ];
      };
      envExtra = ''

        # Make Nix and home-manager installed things available in PATH.
        export PATH=/run/current-system/sw/bin/:/nix/var/nix/profiles/default/bin:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:$PATH
        alias loadenv='source ~/Repo/lightbox/.env'
        alias enc="sh /Users/vipul.gupta/utils/encrypt/encrypt.sh android"
        alias encios="sh /Users/vipul.gupta/utils/encrypt/encrypt.sh ios"
        export PATH="/opt/homebrew/sbin:$PATH"
        export PATH="/opt/homebrew/bin:$PATH"
        # alias python="python3"
        # alias python="/opt/homebrew/bin/python3.11"
        # alias pip="/opt/homebrew/bin/pip3.11"
        alias k="kubectl"
        # The next line updates PATH for the Google Cloud SDK.
        if [ -f '/Users/vipul.gupta/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/vipul.gupta/Downloads/google-cloud-sdk/path.zsh.inc'; fi

        # The next line enables shell command completion for gcloud.
        if [ -f '/Users/vipul.gupta/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/vipul.gupta/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

        #Path to run Euler build
        # export PATH="$PATH:/Users/vipul.gupta/Desktop/Backend/euler-tools/euler-bin"


        # export PATH="/usr/local/opt/postgresql/bin:$PATH"

        # export PATH="/usr/local/opt/postgresql@9.6/bin:$PATH"
        # export PATH="/usr/local/opt/postgresql@9.6/bin:$PATH"
        # export NVM_DIR=~/.nvm
        export PATH=$PATH:$HOME/.cargo/env
        export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
        
        export LDFLAGS="-L/opt/homebrew/opt/mysql-client/lib"
        export CPPFLAGS="-I/opt/homebrew/opt/mysql-client/include"
        
        export LDFLAGS="-L/opt/homebrew/opt/libpq/lib"
        export CPPFLAGS="-I/opt/homebrew/opt/libpq/include"
        
        export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
        export PKG_CONFIG_PATH="/opt/homebrew/opt/mysql-client/lib/pkgconfig"

        # # fix path by checking $(brew --prefix nvm)
        # source /usr/local/opt/nvm/nvm.sh
        export NVM_DIR="$HOME/.nvm"
        export PATH=/opt/homebrew/opt/ruby/bin:$PATH
        [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
        [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

        export PATH=/opt/homebrew/bin:$PATH
        export ANDROID_HOME=$HOME/Library/Android/sdk
        export PATH=$PATH:$ANDROID_HOME/emulator
        export PATH=$PATH:$ANDROID_HOME/platform-toolsexport PATH="/usr/local/opt/openjdk@17/bin:$PATH"
        export PATH=$PATH:/Users/vipul.gupta/.cargo/bin
        eval "$(direnv hook zsh)"
        # eval $(minikube -p minikube docker-env)
      '';
    };

    # https://haskell.flake.page/direnv
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    # starship.enable = true;
    # Type `z <pat>` to cd to some directory
    zoxide.enable = true;
  };
}
