# Wofi is a app-launcher
{ username, config, pkgs, ... }: {
  home-manager.users.${username} = { ... }: 
  let
    theme = config.modules.theme.data;
  in
  {
    programs.wofi = {
      enable = true;

      settings = {
        show = "drun";
        width = 512;
        height = 384;
        always_parse_args = true;
        show_all = true;
        print_command = true;
        prompt = "";
        layer = "overlay";
        insensitive = true;
        content_halign = "top";
        allow_images = true;
      };

      style = ''
        @define-color base   #${theme.colors.bg};
        @define-color accent #${theme.colors.accent};
        @define-color text   #${theme.colors.fg};

        #window {
          margin: 0px;
          border: 2px solid @accent;
          border-radius: 0px;
          background-color: @base;
          font-size: 16px;
          font-weight: normal;
        }

        #input {
          border-radius: 0px;
          color: @text;
          background-color: @base;
          padding: 6px 8px;
          font-size: 16px;
          border: 4px solid @accent;
          margin-bottom: 6px;
        }

        #outer-box {
          margin: 8px;
          border: none;
          border-radius: 0px;
          background-color: transparent;
        }

        #text {
          margin: 0px 8px;
          border: none;
          color: @text;
        }

        #entry:selected {
          background-color: @base;
          font-weight: bold;
          border-radius: 0px;
        }

        #text:selected {
          background-color: @base;
          color: @text;
          font-weight: bold;
        }

        #expander-box {
          background: @base;
          color: @text;
          font-weight: normal;
        }

        #expander-box:selected {
          background: @base;
          color: @text;
          font-weight: normal;
        }

        /* Override the blue selection indicator (e.g. app icon circle) */
        #entry:selected image {
          background-color: transparent;
          color: white;
          border-radius: 50%;
        }
      '';
    };
  };
}
