{
  den.aspects.kde.homeManager = {
    programs.plasma.powerdevil = {
      AC = {
        autoSuspend = {
          action = "sleep";
          idleTimeout = 600;
        };

        dimDisplay = {
          enable = true;
          idleTimeout = 270;
        };
        dimKeyboard.enable = true;

        whenLaptopLidClosed = "sleep";
        inhibitLidActionWhenExternalMonitorConnected = true;

        powerButtonAction = "shutDown";

        powerProfile = "balanced";

        turnOffDisplay = {
          idleTimeout = 285;
          idleTimeoutWhenLocked = 30;
        };

        whenSleepingEnter = "standby";
      };

      battery = {
        autoSuspend = {
          action = "sleep";
          idleTimeout = 300;
        };

        dimDisplay = {
          enable = true;
          idleTimeout = 90;
        };
        dimKeyboard.enable = true;

        whenLaptopLidClosed = "sleep";
        inhibitLidActionWhenExternalMonitorConnected = true;

        powerButtonAction = "shutDown";

        powerProfile = "balanced";

        turnOffDisplay = {
          idleTimeout = 105;
          idleTimeoutWhenLocked = 30;
        };

        whenSleepingEnter = "standby";
      };

      lowBattery = {
        autoSuspend = {
          action = "sleep";
          idleTimeout = 300;
        };

        dimDisplay = {
          enable = true;
          idleTimeout = 75;
        };
        dimKeyboard.enable = true;

        whenLaptopLidClosed = "sleep";
        inhibitLidActionWhenExternalMonitorConnected = true;

        powerButtonAction = "shutDown";

        powerProfile = "powerSaving";

        turnOffDisplay = {
          idleTimeout = 90;
          idleTimeoutWhenLocked = 30;
        };

        whenSleepingEnter = "standby";
      };
    };
  };
}
