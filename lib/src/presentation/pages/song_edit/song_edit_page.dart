import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

import '../../../utils/colors.dart';
import '../../../utils/constant.dart';
import '../../../utils/fonts.dart';
import '../../widgets/form_content.dart';

class SongEditPage extends StatefulWidget {
  static const routeNamed = '/song-edit-page';
  const SongEditPage({Key? key}) : super(key: key);

  @override
  State<SongEditPage> createState() => _SongEditPageState();
}

class _SongEditPageState extends State<SongEditPage> {
  late TextEditingController titleController;
  late TextEditingController artistController;
  late TextEditingController albumController;
  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    artistController = TextEditingController();
    albumController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    artistController.dispose();
    albumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: monochromatic,
        centerTitle: true,
        title: Text(
          'Edit Boku no Sensou',
          style: firaSansWhite.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: sizes.height(context) / 3,
                    child: Image.asset(
                      assetLogoPath,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FormContent(
                          title: 'Judul',
                          child: TextFormFieldCustom(
                            controller: titleController,
                            disableOutlineBorder: false,
                            hintText: 'Judul lagu',
                          ),
                        ),
                        const SizedBox(height: 20),
                        FormContent(
                          title: 'Artists',
                          child: TextFormFieldCustom(
                            controller: titleController,
                            disableOutlineBorder: false,
                            hintText: 'Artist',
                          ),
                        ),
                        const SizedBox(height: 20),
                        FormContent(
                          title: 'Album',
                          child: TextFormFieldCustom(
                            controller: titleController,
                            disableOutlineBorder: false,
                            hintText: 'Album',
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                primary: successColor,
              ),
              child: Text(
                'Submit',
                style: amiko.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
