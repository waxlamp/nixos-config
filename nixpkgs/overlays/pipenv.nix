self: super:

{
  pipenv = super.pipenv.overrideAttrs (oldAttrs: with self.python3.pkgs; rec {
    version = "2020.5.28";
    src = fetchPypi {
      inherit version;
      pname = "pipenv";
      sha256 = "072lc4nywcf9q9irvanwcz7w0sd9dcyannz208jm6glyj8a271l1";
    };
  });
}
