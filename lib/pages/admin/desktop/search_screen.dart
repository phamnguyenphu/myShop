import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myshop/pages/search_tab.dart';

import '../../../config/strings.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appName),
      ),
      body: const SearchTab(),
    );
  }
}
