{
  den.aspects.kde = {
    programs.plasma.input = {
      keyboard = {
        layouts = [
          {
            layout = "de";
          }
        ];

        numlockOnStartup = "on";
        repeatDelay = 200;
        repeatRate = 40;
        switchingPolicy = "global";
      };

      # Mice & Touchpads are not configured here since settings have to be applied for every model
    };
  };
}
