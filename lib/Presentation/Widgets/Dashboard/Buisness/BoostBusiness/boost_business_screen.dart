import 'dart:developer';

import 'package:buysellbiz/Application/Services/Navigation/navigation.dart';
import 'package:buysellbiz/Data/DataSource/Resources/imports.dart';
import 'package:buysellbiz/Domain/BusinessModel/boost_model.dart';
import 'package:buysellbiz/Domain/BusinessModel/buisiness_model.dart';
import 'package:buysellbiz/Domain/User/user_model.dart';
import 'package:buysellbiz/Presentation/Common/Dialogs/loading_dialog.dart';
import 'package:buysellbiz/Presentation/Common/app_buttons.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Buisness/BoostBusiness/Common/boost_widget.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Buisness/BoostBusiness/Controller/business_boost_cubit.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Buisness/BoostBusiness/State/business_boost_state.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/Components/custom_appbar.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/add_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoostBusinessScreen extends StatefulWidget {
  const BoostBusinessScreen(
      {super.key, required this.model, this.buisnessModelId});

  final BusinessModel? model;
  final String? buisnessModelId;

  @override
  State<BoostBusinessScreen> createState() => _BoostBusinessScreenState();
}

class _BoostBusinessScreenState extends State<BoostBusinessScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BusinessBoostCubit>().getPackages();
  }

  List<BoostModel> packages = [];
  BoostModel? selected;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (val)
      {
        Navigate.toReplaceAll(
            context,
            const BottomNavigationScreen(
              initialPage: 1,
            ));
      },
      child: Scaffold(
        appBar: AppBar(
          title: AppText('Boost your Business', style: Styles.circularStdBold(context, fontSize: 18.sp),),
          //leading: widget.buisnessModelId != null ? false : true,

          leading: widget.buisnessModelId != null? 0.y:BackButton(

            onPressed: (){

              Navigate.toReplaceAll(
                  context,
                  const BottomNavigationScreen(
                    initialPage: 1,
                  ));


            },
          ),
          actions: [
            widget.buisnessModelId != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                          builder: (context) {
                            return const BottomNavigationScreen(
                              initialPage: 0,
                            );
                          },
                        ),(_)=>false);
                      },
                      child: AppText(
                        'Skip',
                        style: Styles.circularStdBold(
                          context,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(
                    height: 0,
                    width: 0,
                  )
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: AppText(
                'You can boost your business to reach out your possible buyer',
                maxLine: 3,
                style: Styles.circularStdRegular(context, fontSize: 14),
              ),
            ),
            const Divider(height: 1),
            BlocConsumer<BusinessBoostCubit, BusinessBoostState>(
              listener: (BuildContext context, BusinessBoostState state) {
                log(state.toString());
                if (state is BusinessBoostLoadingState) {
                  LoadingDialog.showLoadingDialog(context);
                }
                if (state is BusinessBoostErrorState) {
                  Navigator.pop(context);
                  WidgetFunctions.instance
                      .showErrorSnackBar(context: context, error: state.error);
                }

                if (state is BusinessBoostLoadedState) {
                  packages = state.boostPackages;
                  Navigator.pop(context);
                }
                if (state is BusinessBoostActivatedState) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BottomNavigationScreen(),
                      ),
                      (route) => false);
                  // Navigator.pop(context);
                  // Navigator.pop(context);
                }
              },
              builder: (BuildContext context, BusinessBoostState state) =>
                  packages.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: packages.length,
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 100, top: 30),
                            itemBuilder: (context, index) => BoostTile(
                              model: packages[index],
                              isSelected: selected?.id == packages[index].id,
                              onTap: () {
                                setState(() {
                                  selected = packages[index];
                                });
                              },
                            ),
                          ),
                        )
                      : const SizedBox(),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: CustomButton(
          horizontalMargin: 20,
          verticalMargin: 20,
          onTap: () {
            if (selected != null) {
              _boostBusinessConfirmation(context);
            }
          },
          text: 'Continue',
        ),
      ),
    );
  }

  Future<dynamic> _boostBusinessConfirmation(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      enableDrag: false,
      builder: (ctx) {
        return Container(
          height: 270,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.y,
                AppText(
                  maxLine: 3,
                  'Confirmation',
                  style: Styles.circularStdBold(
                    context,
                    fontSize: 24,
                  ),
                ),
                10.y,
                AppText(
                  maxLine: 3,
                  'Are you sure you want to boost your business for ${selected!.duration} for \$${selected!.price}',
                  style: Styles.circularStdMedium(
                    context,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                CustomButton(
                    onTap: () {
                      Navigate.pop(context);

                      if (selected != null) {
                        User? user = Data.app.user!.user;
                        if (user?.stripeCustomer?.cardAttached == true) {
                          context.read<BusinessBoostCubit>().activateBoost(
                                planId: selected?.id ?? '',
                                businessId: widget.model?.id ??
                                    widget.buisnessModelId ??
                                    "",
                                context: context,
                              );
                        } else {
                          Navigate.to(context, const StripeCardWidget());
                        }
                      } else {
                        WidgetFunctions.instance.showErrorSnackBar(
                            context: context,
                            error: 'Select a boost package to continue');
                      }
                    },
                    text: 'Continue'),
                10.y,
              ],
            ),
          ),
        );
      },
    );
  }
}
