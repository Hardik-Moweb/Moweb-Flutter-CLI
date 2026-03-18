import 'package:{{project_name}}/utils/import.dart';

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          children: [
            // Header buttons shimmer
            Padding(
              padding: EdgeInsets.all(s.s16),
              child: Row(
                children: [
                  // Clock-In button shimmer
                  Expanded(
                    child: shimmerContainer(s.s48, double.infinity),
                  ),
                  SizedBox(width: s.s12),
                  // Start Activity button shimmer
                  Expanded(
                    child: shimmerContainer(s.s48, double.infinity),
                  ),
                ],
              ),
            ),
            
            // Active Projects section shimmer
            Container(
              margin: EdgeInsets.symmetric(horizontal: s.s16, vertical: s.s10),
              padding: EdgeInsets.all(s.s16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(s.s10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with count
                  Row(
                    children: [
                      shimmerContainer(s.s40, s.s40),
                      SizedBox(width: s.s12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          shimmerContainer(s.s16, s.s150),
                          SizedBox(height: s.s6),
                          shimmerContainer(s.s12, s.s200),
                        ],
                      ),
                      Spacer(),
                      shimmerContainer(s.s30, s.s30),
                    ],
                  ),
                  
                  SizedBox(height: s.s16),
                  
                  // Project items shimmer
                  for (int i = 0; i < 2; i++) ...[
                    if (i > 0) Divider(height: 1),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: s.s12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                shimmerContainer(s.s16, s.s120),
                                SizedBox(height: s.s6),
                                shimmerContainer(s.s12, s.s100),
                              ],
                            ),
                          ),
                          shimmerContainer(s.s30, s.s80),
                        ],
                      ),
                    ),
                  ],
                  
                  SizedBox(height: s.s16),
                  
                  // View All button shimmer
                  shimmerContainer(s.s48, double.infinity),
                ],
              ),
            ),
            
            // My Leaves section shimmer
            Container(
              margin: EdgeInsets.symmetric(horizontal: s.s16, vertical: s.s10),
              padding: EdgeInsets.all(s.s16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(s.s10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      shimmerContainer(s.s40, s.s40),
                      SizedBox(width: s.s12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          shimmerContainer(s.s16, s.s100),
                          SizedBox(height: s.s6),
                          shimmerContainer(s.s12, s.s220),
                        ],
                      ),
                    ],
                  ),
                  
                  SizedBox(height: s.s16),
                  
                  // Leave item shimmer
                  Container(
                    padding: EdgeInsets.symmetric(vertical: s.s12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        shimmerContainer(s.s16, s.s150),
                        SizedBox(height: s.s6),
                        shimmerContainerH(s.s12),
                        SizedBox(height: s.s12),
                        shimmerContainerH(s.s12),
                        SizedBox(height: s.s10),
                        Row(
                          children: [
                            shimmerContainer(s.s16, s.s16),
                            SizedBox(width: s.s8),
                            shimmerContainer(s.s12, s.s100),
                            Spacer(),
                            shimmerContainer(s.s24, s.s80),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: s.s16),
                  
                  // View All button shimmer
                  shimmerContainer(s.s48, double.infinity),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}