{
  den.aspects.kde.homeManager = {
    programs.plasma.panels = [
      {
        screen = 0;

        location = "bottom";
        floating = true;
        alignment = "center";
        hiding = "dodgewindows";

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
