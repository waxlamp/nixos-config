{
  allowUnfree = true;

  chromium = {
    enablePepperFlash = true;
  };

  packageOverrides = super: let self = super.pkgs; in {
    rEnv = super.rWrapper.override {
      packages = with self.rPackages; [
        devtools
        remotes
      ];
    };
  };
}
