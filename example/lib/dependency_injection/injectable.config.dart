// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:user_experior_example/characters/data/character_networking_service.dart'
    as _i12;
import 'package:user_experior_example/characters/provider/characters_provider.dart'
    as _i3;
import 'package:user_experior_example/characters/repository/characters_repository.dart'
    as _i13;
import 'package:user_experior_example/flows/ui_catalog/drawer_pages/page_animations/provider/animation_provider.dart'
    as _i10;
import 'package:user_experior_example/flows/ui_catalog/drawer_pages/page_horizontal_list/data/h_list_data_service.dart'
    as _i9;
import 'package:user_experior_example/flows/ui_catalog/drawer_pages/page_horizontal_list/repository/h_list_repository.dart'
    as _i8;
import 'package:user_experior_example/flows/ui_catalog/drawer_pages/page_vertical_list/data/v_list_data_service.dart'
    as _i7;
import 'package:user_experior_example/flows/ui_catalog/drawer_pages/page_vertical_list/repository/v_list_repository.dart'
    as _i6;
import 'package:user_experior_example/flows/ui_catalog/drawer_pages/page_video/video_provider.dart/video_provider.dart'
    as _i11;
import 'package:user_experior_example/flows/ui_utility/provider/character_details_provider.dart'
    as _i4;
import 'package:user_experior_example/flows/ui_utility/screen_login/provider/login_provider.dart'
    as _i5;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i3.CharacterProvider>(() => _i3.CharacterProvider());
    gh.factory<_i4.CharacterDetailsProvider>(
        () => _i4.CharacterDetailsProvider());
    gh.factory<_i5.LoginProvider>(() => _i5.LoginProvider());
    gh.factory<_i6.VListRepository>(() => _i6.VListRepository());
    gh.factory<_i7.VListDataService>(() => _i7.VListDataService());
    gh.factory<_i8.HListRepository>(() => _i8.HListRepository());
    gh.factory<_i9.HListDataService>(() => _i9.HListDataService());
    gh.factory<_i10.AnimationProvider>(() => _i10.AnimationProvider());
    gh.factory<_i11.VideoProvider>(() => _i11.VideoProvider());
    gh.lazySingleton<_i12.CharacterNetworkingService>(
        () => _i12.CharacterNetworkingService());
    gh.lazySingleton<_i13.CharacterRepository>(
        () => _i13.CharacterRepositoryImpl());
    return this;
  }
}
