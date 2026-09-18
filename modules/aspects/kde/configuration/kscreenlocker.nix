{
  den.aspects.kde.homeManager = {
    programs.plasma.kscreenlocker = {
      appearance = {
        alwaysShowClock = true;
        showMediaControls = false;
      };

      lockOnResume = true;
      passwordRequired = true;
      passwordRequiredDelay = 0;
      timeout = 5;
    };
  };
}
