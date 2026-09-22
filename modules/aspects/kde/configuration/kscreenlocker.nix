{
  den.aspects.kde.homeManager = {
    programs.plasma.kscreenlocker = {
      appearance = {
        alwaysShowClock = true;
        showMediaControls = false;
      };

      lockOnResume = true;
      passwordRequired = true;
      # No grace period: require the password immediately on every resume,
      # not just after some seconds unattended.
      passwordRequiredDelay = 0;
      timeout = 5;
    };
  };
}
