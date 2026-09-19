{ lib, ... }: {
  den.aspects.xdg.homeManager =
    { config, host, ... }:
    let
      cfg = config.defaultApps;

      # Mime types associated with each defaultApps.<name>. A category with
      # no declared app is silently skipped instead of failing eval, since
      # not every host/user wires up every category.
      categoryMimeTypes = {
        browser = [
          "text/html"
          "application/xhtml+xml"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
          "x-scheme-handler/ftp"
        ];

        fileManager = [ "inode/directory" ];

        editor = [
          "text/plain"
          "text/markdown"
          "application/json"
          "application/xml"
          "text/xml"
          "text/css"
          "text/javascript"
        ];

        pdf = [ "application/pdf" ];

        imageViewer = [
          "image/jpeg"
          "image/png"
          "image/gif"
          "image/webp"
          "image/bmp"
          "image/tiff"
          "image/svg+xml"
          "image/avif"
        ];

        videoPlayer = [
          "video/mp4"
          "video/x-matroska"
          "video/webm"
          "video/quicktime"
          "video/x-msvideo"
          "video/mpeg"
        ];

        audioPlayer = [
          "audio/mpeg"
          "audio/flac"
          "audio/ogg"
          "audio/opus"
          "audio/x-wav"
          "audio/aac"
          "audio/mp4"
        ];

        mail = [ "x-scheme-handler/mailto" ];

        archiveManager = [
          "application/zip"
          "application/x-7z-compressed"
          "application/x-rar"
          "application/vnd.rar"
          "application/x-tar"
          "application/gzip"
          "application/x-bzip2"
          "application/x-xz"
        ];

        office = [
          "application/msword"
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
          "application/vnd.oasis.opendocument.text"
        ];

        spreadsheet = [
          "application/vnd.ms-excel"
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
          "application/vnd.oasis.opendocument.spreadsheet"
          "text/csv"
        ];

        presentation = [
          "application/vnd.ms-powerpoint"
          "application/vnd.openxmlformats-officedocument.presentationml.presentation"
          "application/vnd.oasis.opendocument.presentation"
        ];

        ebookReader = [
          "application/epub+zip"
          "application/x-mobipocket-ebook"
        ];
      };
      defaultApplications = lib.concatMapAttrs (
        category: mimeTypes:
        lib.optionalAttrs (builtins.hasAttr category cfg) (
          lib.genAttrs mimeTypes (_: cfg.${category}.desktopFile)
        )
      ) categoryMimeTypes;
    in
    {
      options.defaultApps = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              command = lib.mkOption {
                type = lib.types.str;
                description = "Command used to launch the application.";
              };

              desktopFile = lib.mkOption {
                type = lib.types.str;
                description = "Desktop file ID of the application.";
              };
            };
          }
        );

        default = { };
        description = "Default applications.";
      };

      config.xdg = {
        enable = true;
        userDirs =
          lib.mkIf
            (builtins.elem host.profile [
              "desktop"
              "laptop"
            ])
            {
              enable = true;
              createDirectories = true;
            };

        mimeApps = {
          enable = true;

          inherit defaultApplications;
        };

        terminal-exec = lib.mkIf (builtins.hasAttr "terminal" cfg) {
          enable = true;
          settings.default = [ cfg.terminal.desktopFile ];
        };
      };
    };
}
