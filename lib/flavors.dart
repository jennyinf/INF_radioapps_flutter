enum Flavor {
  hfm,
  greatdriffield,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.hfm:
        return 'HFM';
      case Flavor.greatdriffield:
        return 'Great Driffield';
      default:
        return 'title';
    }
  }

}
