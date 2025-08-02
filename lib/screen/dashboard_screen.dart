import 'package:etranslate/ult/drawer.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../services/TranslationProvider.dart';

class Dashboard extends StatelessWidget {
  final _textController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TranslationProvider>(
      builder: (context, provider, child) {
        _textController.addListener(() {
          provider.updateInputText(_textController.text);
        });
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('Language Translator'),
            actionsPadding: EdgeInsets.only(right: 10),
            elevation: 2,
            foregroundColor: Colors.white,
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
            actions: [
              InkWell(
                onTap: () {
                  _scaffoldKey.currentState!.openEndDrawer();
                },
                child: Lottie.asset(
                  'assets/animations/Translate.json',
                  width: 50,
                  height: 50,
                ),
              ),
            ],
          ),
          endDrawer: endDrawer(context),

          body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                //Language Switcher
                Container(
                  height: 80,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade500,
                        offset: Offset(-2, 2),
                        blurRadius: 2,
                      ),
                      BoxShadow(
                        color: Colors.grey.shade500,
                        offset: Offset(2, -2),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: Image.asset(
                              provider.sourceLang == 'en'
                                  ? 'assets/images/usa.png'
                                  : 'assets/images/ngn.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            provider.sourceLang == 'en'
                                ? 'English'
                                : 'Yoruba',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: provider.switchLanguages,
                        icon: Icon(Icons.compare_arrows_sharp),
                      ),
                      Row(
                        children: [
                          Text(
                            provider.targetLang == 'yo'
                                ? 'Yoruba'
                                : 'English',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey,
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: Image.asset(
                              provider.targetLang == 'yo'
                                  ? 'assets/images/ngn.png'
                                  : 'assets/images/usa.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // input container and text field
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade500,
                        offset: Offset(-2, 2),
                        blurRadius: 2,
                      ),
                      BoxShadow(
                        color: Colors.grey.shade500,
                        offset: Offset(2, -2),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.sourceLang == 'en' ? 'English' : 'Yoruba',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _textController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter text here',
                          hintStyle: TextStyle(
                            fontSize: 22,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton.icon(
                          onPressed:
                              provider.inputText.trim().isEmpty
                                  ? null
                                  : () => provider.translateText(context),
                          label: Text('Translate'),
                          style: ButtonStyle(
                            textStyle: WidgetStatePropertyAll(
                              TextStyle(fontSize: 20),
                            ),
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.green,
                            ),
                            foregroundColor: WidgetStatePropertyAll(
                              Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // output container and text
                if (provider.isOutputVisible)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 15,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade500,
                          offset: Offset(-2, 2),
                          blurRadius: 2,
                        ),
                        BoxShadow(
                          color: Colors.grey.shade500,
                          offset: Offset(2, -2),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider.targetLang == 'yo' ? 'Yoruba' : 'English',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          provider.translatedText,
                          style: TextStyle(fontSize: 22),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.copy),
                              onPressed:
                                  () => provider.copyToClipboard(context),
                              tooltip: 'Copy',
                            ),
                            IconButton(
                              icon: Icon(Icons.share),
                              onPressed: () => provider.shareText(),
                              tooltip: 'Share',
                            ),
                            IconButton(
                              icon: Icon(Icons.favorite_border),
                              onPressed:
                                  () => provider.saveToFavorites(context),
                              tooltip: 'Favorite',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
