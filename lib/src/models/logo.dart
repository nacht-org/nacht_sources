class Logo {
  const Logo({required this.src, required this.color});

  const Logo.github(String name, this.color)
      : src =
            "https://raw.githubusercontent.com/nacht-org/nacht_sources/main/assets/$name";

  final int color;
  final String src;
}
