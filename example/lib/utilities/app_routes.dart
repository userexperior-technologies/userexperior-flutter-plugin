enum AppRoutes {
  base,
  login,
  uiCatalog,
  utilityEpisodes,
  utilityCharacters,
  utilityCharacterDetails;

  String get description {
    switch (this) {
      case base:
        return "/";
      case login:
        return "/login";
      case uiCatalog:
        return "/ui_catalog";
      case utilityEpisodes:
        return "/episodes";
      case utilityCharacters:
        return "/characters";
      case utilityCharacterDetails:
        return "/characters/details";
      default:
        return "/";
    }
  }

  static AppRoutes from(String? str) {
    if (str == null) return AppRoutes.base;
    switch (str) {
      case "/":
        return AppRoutes.base;
      case "/login":
        return AppRoutes.login;
      case "/ui_catalog":
        return AppRoutes.uiCatalog;
      case "/episodes":
        return AppRoutes.utilityEpisodes;
      case "/characters":
        return AppRoutes.utilityCharacters;
      case "/characters/details":
        return AppRoutes.utilityCharacterDetails;
      default:
        return AppRoutes.base;
    }
  }
}
