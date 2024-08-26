import 'package:buysellbiz/Data/DataSource/Resources/imports.dart';
import 'package:buysellbiz/Data/DataSource/Resources/strings.dart';

class CustomListTile extends StatelessWidget {
  final String? leadingicon;
  final String? title;
  final String? trailing;
  final VoidCallback onPressed;
  const CustomListTile({
    super.key,
    this.leadingicon,
    this.title,
    this.trailing,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.symmetric(vertical: 15.sp, horizontal: 5.sp),
      onPressed: onPressed,
      child: Row(children: [
        Expanded(
            child: SvgPicture.asset(
          leadingicon!,
          height: 20.sp,
          width: 20.sp,
        )),
        Expanded(
          flex: 5,
          child: AppText(title!,
              style: Styles.circularStdMedium(context, fontSize: 16.sp)),
        ),
        Expanded(child: SvgPicture.asset(trailing!)),
      ]),
    );
  }
}
