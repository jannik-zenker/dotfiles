{
  den.aspects.nextcloudClient = {
    homeManager = {
      services.nextcloud-client = {
        enable = true;
        startInBackground = true;
      };
    };
  };
}
