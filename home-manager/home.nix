{system, ...}: {
  imports =
    if system == "x86_64-darwin"
    then [./darwin]
    else [./nixos];
}
