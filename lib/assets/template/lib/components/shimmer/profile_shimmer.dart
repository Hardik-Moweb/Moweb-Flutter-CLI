import 'package:{{project_name}}/utils/import.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Additional Information Shimmer
          Container(
            color: whiteColor,
            padding: EdgeInsets.all(s.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        _buildInfoItemShimmer(),
                        sb(s.s20),
                      ],
                    );
                  }
                ),

                // Button shimmer 1
                shimmerContainer(s.s36, double.infinity),
                sb(s.s12),

                // Button shimmer 2
                shimmerContainer(s.s36, double.infinity),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoItemShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label Shimmer
        shimmerContainer(s.s16, double.infinity),
        sb(s.s8),
        
        // Value Shimmer
        shimmerContainer(s.s35, double.infinity),
      ],
    );
  }
}