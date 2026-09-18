{
  den.aspects.kde.homeManager = {
    programs.plasma.session = {
      general.askForConfirmationOnLogout = false;
      sessionRestore = {
        excludeApplications = [ ];
        restoreOpenApplicationsOnLogin = "startWithEmptySession";
      };
    };
  };
}
