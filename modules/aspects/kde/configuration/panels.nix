{
  den.aspects.kde.homeManager = {
    programs.plasma.panels = [
      {
        screen = "all";

        location = "bottom";
        floating = true;
        alignment = "center";

        lengthMode = "fit";

        height = 44;

        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }
    ];
  };
}
