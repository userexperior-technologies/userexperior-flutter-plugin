import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:user_experior_example/dependency_injection/injectable.config.dart';

final GetIt dependencyProvider = GetIt.instance;

@injectableInit
void configureDependencies() => dependencyProvider.init();
