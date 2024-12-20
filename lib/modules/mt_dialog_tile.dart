import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class MTOpenDialogButton extends StatelessWidget {
  MTOpenDialogButton({super.key, this.child, this.dialogueTitle});
  final Widget? child;
  String? dialogueTitle = 'Untitled';

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll<Color>(Colors.blue)),
      onPressed: () {
        _showCustomDialog(context);
      },
      child: Text(
        'Открыть окно',
        style: GoogleFonts.comfortaa(),
      ),
    );
  }

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),

          elevation: 0, // Тень
          backgroundColor: Colors.white,
          child: contentBox(context),
        );
      },
    );
  }

  Widget contentBox(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
              color: Color.fromRGBO(33, 150, 243, 1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          child: AutoSizeText(
            'Заголовок окна',
            minFontSize: 36,
            maxFontSize: 48,
            style: GoogleFonts.comfortaa(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (child != null) child!, //!!!!! this one
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Закрыть',
                    style: GoogleFonts.comfortaa(color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
