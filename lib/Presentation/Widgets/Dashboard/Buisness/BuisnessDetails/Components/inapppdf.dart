import 'dart:developer';

import 'package:buysellbiz/Data/DataSource/Resources/imports.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Buisness/BuisnessDetails/Controller/download_file.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/Components/custom_appbar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class NetworkPdfViewer extends StatelessWidget {
  const NetworkPdfViewer({super.key, this.src});
  final String? src;
  @override
  Widget build(BuildContext context) {
    log(src ?? 'NULL SRC');
    return Scaffold(
        appBar: const CustomAppBar(
          title: 'Pdf',
          leading: true,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await launchUrl(Uri.parse(src!));
            // await Share.shareXFiles([
            //   XFile(
            //     DownloadFile.savedPath.value ?? "",
            //   )
            // ], text: DownloadFile.savedPath.value.split('/').last);
            // Share.shareFiles(['${directory.path}/image1.jpg', '${directory.path}/image2.jpg']);
          },
          backgroundColor: AppColors.whiteColor,
          child: const Icon(
            Icons.download,
            color: AppColors.primaryColor,
          ),
        ),
        body: SfPdfViewer.network(src!));
  }
}
