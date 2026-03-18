import 'package:{{project_name}}/utils/import.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.signal_wifi_off, size: 100, color: Colors.grey),
            sb(20),
            TitleTextView(
              'No Internet Connection',
              fontSize: FontSize.s18,
              fontWeight: MyFontWeights.bold,
            ),
            sb(10),
            TitleTextView(
              'Please check your internet connection and try again.',
              fontSize: FontSize.s14,
              color: greyColor,
              textAlign: TextAlign.center,
            ),
            sb(30),
            SizedBox(
              width: 200,
              child: Button(
                strTitle: 'Retry',
                ontap: () => pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
