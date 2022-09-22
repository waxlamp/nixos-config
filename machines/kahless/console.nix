{ nixpkgs, ... }:

{
  # Set up console properties.
  console = {
    packages = with nixpkgs; [
      terminus_font
    ];
    font = "ter-u32b";
    keyMap = "us";
  };
}
