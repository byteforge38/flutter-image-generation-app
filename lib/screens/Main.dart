import 'dart:typed_data';

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Uint8List?> gallery = [];

  void _callback(List<Uint8List?> images) {
    setState(() {
      gallery.addAll(images);
    });
  }

  _saveImage(Uint8List byteData) async {
    ImageGallerySaverPlus.saveImage(byteData,
        quality: 60, name: DateTime.now().millisecondsSinceEpoch.toString());
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 20;

    return Scaffold(
      backgroundColor: Color(0xFF010101),
      appBar: AppBar(
        backgroundColor: Color(0xFF010101),
        leadingWidth: 50,
        centerTitle: true,
        title: Text(
          "Hi, Human 👋",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: SizedBox(
              width: 40,
              height: 40,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF560FAB), width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Container(
                  padding: EdgeInsets.all(2),
                  child: ClipOval(
                    child: Image(
                      image: AssetImage("assets/avatar.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        leading: Padding(
          padding: EdgeInsets.only(left: 10),
          child: SizedBox(
            height: 40,
            width: 40,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF272727),
              ),
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: Column(
          children: [
            Text(
              "How can I help you today?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  flex: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0xFF560FAB),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      image: DecorationImage(
                        image: AssetImage("assets/splash.png"),
                        opacity: 0.3,
                      ),
                    ),
                    child: SizedBox(
                      height: 230,
                      child: TextButton(
                        onPressed: () => Navigator.pushNamed(context, "/chat",
                            arguments: {"callback": _callback}),
                        style: ButtonStyle(
                          padding: WidgetStatePropertyAll(EdgeInsets.all(20)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Generate Images",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        color: Colors.white24,
                                        shape: BoxShape.circle),
                                    child: Center(
                                      child: Image(
                                        image: AssetImage("assets/icon_1.png"),
                                      ),
                                    ),
                                  ),
                                ),
                                Icon(
                                  size: 30,
                                  Icons.arrow_outward,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Gallery",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                Text(
                  " (${gallery.length})",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            if (gallery.isNotEmpty)
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: gallery.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) => SizedBox(
                    height: width / 2 - 5,
                    width: width / 2 - 5,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF560FAB), width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(2),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: GestureDetector(
                                onTap: () => showImageViewer(context,
                                    Image.memory(gallery[index]!).image),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18)),
                                  child: Image.memory(
                                    gallery[index]!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment(0.9, 0.9),
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Color(0xFF010101),
                                    shape: BoxShape.circle,
                                  ),
                                  child: TextButton(
                                    onPressed: () =>
                                        _saveImage(gallery[index]!),
                                    child: Center(
                                      child: Icon(
                                        Icons.download,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (gallery.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    "Gallery is empty. \nGenerate some images and they will appear here.",
                    style: TextStyle(
                      color: Colors.white24,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
