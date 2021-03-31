import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:path/path.dart';

import '../../../network/my_network.dart';
import '../../../provider/my_provider.dart';

class FormEditSong extends StatefulWidget {
  final MusicModel music;

  const FormEditSong({
    Key? key,
    required this.music,
  }) : super(key: key);
  @override
  _FormEditSongState createState() => _FormEditSongState();
}

class _FormEditSongState extends State<FormEditSong> {
  final _formKey = GlobalKey<FormState>();

  String title = '';
  String artists = '';
  String album = '';
  String genre = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: sizes.height(context) / 3,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormFieldCustom(
                    prefixIcon: null,
                    initialValue: widget.music.tag?.title?.isEmpty ?? false
                        ? basenameWithoutExtension(widget.music.pathFile!)
                        : widget.music.tag!.title,
                    hintText: 'Lost in Paradise...',
                    labelText: 'Title ',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Provided Title';
                      }
                      return null;
                    },
                    onSaved: (value) => title = value!,
                  ),
                  const SizedBox(height: 10),
                  TextFormFieldCustom(
                    prefixIcon: null,
                    initialValue: widget.music.tag?.artist,
                    hintText: 'Eve...',
                    labelText: 'Artist',
                    onSaved: (value) => artists = value!,
                  ),
                  const SizedBox(height: 10),
                  TextFormFieldCustom(
                    prefixIcon: null,
                    initialValue: widget.music.tag?.album,
                    hintText: 'Insert Album...',
                    labelText: 'Album',
                    onSaved: (value) => album = value!,
                  ),
                  const SizedBox(height: 10),
                  TextFormFieldCustom(
                    prefixIcon: null,
                    initialValue: widget.music.tag?.genre,
                    hintText: 'POP / ROCK / ETC',
                    labelText: 'Genre',
                    onSaved: (value) => genre = value!,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(12.0),
            primary: Colors.blue,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () {
            final isValidate = _formKey.currentState!.validate();
            if (isValidate) {
              _formKey.currentState!.save();
              final tag = TagMetaDataModel(
                title: title,
                album: album,
                artist: artists,
                genre: genre,
              );

              final map = {'tag': tag, 'music': widget.music};
              context
                  .refresh(editSong(map))
                  .then(
                    (_) => GlobalFunction.showSnackBar(
                      context,
                      content: const Text('Sucess update song'),
                      snackBarType: SnackBarType.success,
                    ),
                  )
                  .catchError((error) => GlobalFunction.showSnackBar(
                        context,
                        content: Text(error.toString()),
                        snackBarType: SnackBarType.error,
                      ));
              Navigator.of(context).pop();
            }
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}
