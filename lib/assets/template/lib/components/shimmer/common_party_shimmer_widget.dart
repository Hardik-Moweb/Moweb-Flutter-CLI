import 'package:{{project_name}}/utils/import.dart';

class CommonPartyShimmerWidget extends StatelessWidget {
  final int itemCount;

  const CommonPartyShimmerWidget({super.key, this.itemCount = 10});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(s.s16),
      itemCount: itemCount,
      separatorBuilder: (context, index) => sb(s.s16),
      itemBuilder: (context, index) {
        return _partyShimmerItem();
      },
    );
  }

  Widget _partyShimmerItem() {
    return Container(
      padding: EdgeInsets.all(s.s16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(s.s8),
        border: Border.all(color: AppColors.borderColor),
        color: AppColors.whiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerContainer(s.s16, 150),
                    sb(s.s8),
                    shimmerContainer(s.s16, s.s40),
                  ],
                ),
              ),
              sbw(s.s12),
              Row(
                children: [
                  shimmerContainer(s.s40, s.s40),
                  sbw(s.s8),
                  shimmerContainer(s.s40, s.s40),
                ],
              ),
            ],
          ),

          sb(s.s12),
          Divider(height: 1, color: AppColors.borderColor),
          sb(s.s12),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerContainer(s.s12, 50),
                    sb(s.s8),
                    shimmerContainer(s.s14, 100),
                  ],
                ),
              ),
              sbw(s.s8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerContainer(s.s12, 70),
                    sb(s.s8),
                    shimmerContainer(s.s14, 120),
                  ],
                ),
              ),
            ],
          ),

          sb(s.s12),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerContainer(s.s12, 60),
                    sb(s.s8),
                    shimmerContainer(s.s14, 140),
                  ],
                ),
              ),
              sbw(s.s8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerContainer(s.s12, 60),
                    sb(s.s8),
                    shimmerContainer(s.s14, 110),
                  ],
                ),
              ),
            ],
          ),

          sb(s.s12),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerContainer(s.s12, 50),
                    sb(s.s8),
                    shimmerContainer(s.s14, 150),
                  ],
                ),
              ),
              sbw(s.s8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerContainer(s.s12, 80),
                    sb(s.s8),
                    shimmerContainer(s.s14, 100),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
