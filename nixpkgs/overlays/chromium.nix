self: super:

{
  chromiumBig = super.chromium.override {
    commandLineArgs = ''--add-flags "--force-device-scale-factor=1.5"'';
  };
}
