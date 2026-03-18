import 'package:{{project_name}}/utils/import.dart';
class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withValues(alpha: 0.7),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Shimmer effect for the loader
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: shimmerContainer(s.s80, s.s80),
            ),
            sb(s.s16),
            TitleTextView(
              "Please wait...",
              color: Colors.grey.shade700,
              fontSize: FontSize.s16,
              fontWeight: MyFontWeights.medium,
            ),
          ],
        ),
      ),
    );
  }
}