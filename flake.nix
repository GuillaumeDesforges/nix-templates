{
  description = "A collection of flake templates";

  outputs = { ... }:
    {
      templates = {
        base = {
          path = ./base;
          description = "My base for all projects";
        };
      };
    };
}
