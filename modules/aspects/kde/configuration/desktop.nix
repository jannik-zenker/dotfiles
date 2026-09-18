{
  den.aspects.kde.homeManager = {
    programs.plasma.desktop = {
      icons = {
        alignment = "left";
        arrangement = "topToBottom";
        folderPreviewPopups = false;
        lockInPlace = false;
        # Slider ranges 0 (small) to 6 (large); default is 3.
        size = 2;
        sorting = {
          descending = false;
          foldersFirst = true;
          mode = "name";
        };
      };
    };
  };
}
