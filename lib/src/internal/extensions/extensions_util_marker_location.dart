import '../monitor/marker_location.dart';
import 'extensions_util_double.dart';

extension ExtensionUtilUEMarkerLocation on UEMarkerLocation {
  Map<String, String> get toJson => {
    'i': uuid,
    'x': rect.left.ratioToDouble.toString(),
    'y': rect.top.ratioToDouble.toString(),
    'w': rect.width.ratioToDouble.toString(),
    'h': rect.height.ratioToDouble.toString(),
  };
}