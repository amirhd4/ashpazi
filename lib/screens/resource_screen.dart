import 'package:ashpazi/common/app.dart';
import 'package:ashpazi/widgets/appbar.dart';
import 'package:ashpazi/widgets/snackbar.dart';
import 'package:ashpazi/widgets/text.dart';
import "package:flutter/material.dart";
import 'package:url_launcher/url_launcher_string.dart';

class ResourceScreen extends StatefulWidget {
  const ResourceScreen({Key? key}) : super(key: key);

  @override
  State<ResourceScreen> createState() => _ResourceScreenState();
}

class _ResourceScreenState extends State<ResourceScreen> {
  late List<String> webSites;

  @override
  void initState() {
    webSites = [
      "khabaronline.ir",
      "namnak.com",
      "foodculture.ir",
      "www.kojaro.com",
      "seeiran.ir",
      "sepanja.com",
      "jazebeha.com",
      "namnamak.com",
      "dana.ir",
      "otaghak.com",
      "alibaba.ir",
      "rismoun.com",
      "eligasht.com",
      "karnaval.ir",
      "samtik.com",
      "irandehyar.com",
      "1touchfood.com",
      "raheeno.com",
      "irna.ir",
      "fararu.com",
      "shmi.ir",
      "beytoote.com",
      "irantrawell.com",
      "flightio.com",
      "top-travel.ir",
      "safarzon.com",
      "7ganj.ir",
      "shiraznovinnews.ir",
      "parsiday.com",
      "zarinbano.com",
      "chishi.ir",
      "panamag.ir",
      "atawich.com",
      "foodotto.com",
      "persianv.com",
      "arga-mag.com",
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.appBar(
        "منابع",
        context,
        Colors.white,
      ),
      body: ListView.builder(
        itemCount: webSites.length,
        itemBuilder: (BuildContext context, int i) {
          return Card(
            margin: const EdgeInsets.all(15.0),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Container(
                        width: GetSizes.getWidth(80.0, context),
                        height: GetSizes.getHeight(25.0, context),
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Align(
                              alignment: Alignment.topRight,
                              child: Icon(
                                Icons.warning,
                                color: Colors.red,
                              ),
                            ),
                            TextWidget.textBold(
                                "میخواهید این پیوند را باز کنید؟"),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(
                                    Icons.backspace,
                                    color: Colors.redAccent,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    String url = "http://${webSites[i]}";
                                    if (await canLaunchUrlString(url)) {
                                      await launchUrlString(url);
                                    } else {
                                      SnackBarWidget.snackBar(
                                        "شوربختانه خطایی غیر منتظره رخ داد!",
                                        context,
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.verified_rounded,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextWidget.textItem(webSites[i]),
              ),
            ),
          );
        },
      ),
    );
  }
}
