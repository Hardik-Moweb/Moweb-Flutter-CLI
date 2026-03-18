import 'package:{{project_name}}/utils/import.dart';

class LoaderView extends StatelessWidget {
  final double size;
  final Color? color;
  const LoaderView({super.key, this.size = 25, this.color});

  @override
  Widget build(BuildContext context) {
    return SpinKitFadingCircle(
      color: color ?? themeColor,
      size: size,
    );
  }
}
