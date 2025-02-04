import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class ShowDialogWindow {
  final Widget child;
  String? dialogueTitle;

  ShowDialogWindow({
    this.dialogueTitle,
    required this.child,
  });

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
            dialogueTitle ?? 'Untitled*',
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
                    'Закрыть*',
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

  void showCustomDialogue(BuildContext context){
    showDialog(context: context, builder: (BuildContext context){
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 0, // Тень
        backgroundColor: Colors.white,
        child: contentBox(context),
      );
    });
  }
}
// ignore: must_be_immutable
class MtOpenDialogButton extends StatelessWidget {
  MtOpenDialogButton({
    super.key,
    this.child,
    this.buttonTitle,
    this.dialogueTitle,
  });
  final Widget? child;
  String? dialogueTitle;
  String? buttonTitle;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: const ButtonStyle(
        backgroundColor: WidgetStatePropertyAll<Color>(Colors.blue),
        // textStyle: WidgetStatePropertyAll<TextStyle>(TextStyle(color: Colors.white))
      ),
      onPressed: () {
        _showCustomDialog(context);
      },
      child: Text(
        buttonTitle ?? 'Untitled*',
        style: GoogleFonts.comfortaa(
          color: Colors.white
        ),
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
            borderRadius: BorderRadius.circular(15.0),
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
            dialogueTitle ?? 'Untitled*',
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
                    'Закрыть*',
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
