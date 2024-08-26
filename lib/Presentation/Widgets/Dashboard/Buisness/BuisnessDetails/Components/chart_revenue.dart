import 'dart:developer';

import 'package:buysellbiz/Data/DataSource/Resources/imports.dart';
import 'package:buysellbiz/Domain/BusinessModel/buisiness_model.dart';

import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarChartData {
  final String year;

  final int revenueValue;

  BarChartData(this.year, this.revenueValue);
}

class VerticalBarChart extends StatelessWidget {
  final BusinessModel? business;

  const VerticalBarChart({
    super.key,
    this.business,
  });

  String formatNumber(int value) {
    if (value >= 1000000) {
      double millions = value / 1000000;
      return '${millions.toStringAsFixed(millions.truncateToDouble() == millions ? 0 : 2)}M';
    } else if (value >= 1000) {
      double thousands = value / 1000;
      return '${thousands.toStringAsFixed(thousands.truncateToDouble() == thousands ? 0 : 2)}K';
    } else {
      return value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<BarChartData> chartData = [];

    if (business != null && business!.financialDetails != null) {
      chartData = business!.financialDetails!.map((detail) {
        log(' ${detail.financialYear},  ${detail.revenue}');
        return BarChartData(detail.financialYear!, detail.revenue!);
      }).toList();
    }

    return SfCartesianChart(
      borderWidth: 0,
      borderColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      plotAreaBackgroundColor: Colors.transparent,
      primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(color: Colors.transparent),
          labelStyle: Styles.circularStdRegular(context,
              fontWeight: FontWeight.w500,
              color: AppColors.greyLightColor,
              fontSize: 13.sp)),
      primaryYAxis: NumericAxis(
          isVisible: true,
          numberFormat: NumberFormat.compact(),
          majorGridLines: const MajorGridLines(color: Colors.transparent),
          majorTickLines: const MajorTickLines(size: 0)),
      series: <ColumnSeries<BarChartData, String>>[
        ColumnSeries<BarChartData, String>(
          isTrackVisible: false,
          dataSource: chartData,
          xValueMapper: (BarChartData data, _) =>
              "${data.year.split(' ').first} ${formatNumber(data.revenueValue)}\n${data.year.split(' ')[1]}",
          yValueMapper: (BarChartData data, _) => data.revenueValue,
          name: '',
          color: AppColors.primaryColor,
          width: 0.4,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.sp),
              topRight: Radius.circular(10.sp)),
        ),
      ],
    );
  }
}
