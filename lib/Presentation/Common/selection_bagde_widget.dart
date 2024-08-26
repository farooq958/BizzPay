import 'package:buysellbiz/Data/DataSource/Resources/api_constants.dart';
import 'package:buysellbiz/Domain/Badges/badgeModel.dart';

import '../../Data/DataSource/Resources/imports.dart';

class BadgeSelectionWidget extends StatelessWidget {
  const BadgeSelectionWidget({
    super.key,
    required this.model,
    required this.isSelected,
    required this.onTap,
  });

  final BadgeModel model;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: isSelected ? Border.all(color: AppColors.primaryColor) : null,
        color: model.alreadyRequested != true
            ? AppColors.lightBlue
            : AppColors.chipColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        // padding: const EdgeInsets.all(0),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedImage(
                radius: 20.sp, url: "${ApiConstant.baseurl}${model.icon}"),
            AppText(
              "\$${model.price}",
              maxLine: 3,
              style: Styles.circularStdBold(context,
                  fontSize: 24, color: AppColors.primaryColor),
            ),
            AppText(
              model.title.toString(),
              maxLine: 2,
              style: Styles.circularStdRegular(context),
            )
          ],
        ),
      ),
    );
  }
}
