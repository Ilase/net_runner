import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';
import 'package:net_runner/core/presentation/widgets/mt_add_button.dart';

// ignore: must_be_immutable
class MtOpenDialogButton extends StatelessWidget {
  MtOpenDialogButton({
    super.key,
    required this.buttonTitle,
    required this.eventMethod,
    this.child,
    this.dialogueTitle,
  });
  VoidCallback eventMethod;
  final Widget? child;
  String? dialogueTitle;
  String buttonTitle;


  @override
  Widget build(BuildContext context) {
    return MtAddButton(
      onPressed: () {
        _showCustomDialog(context);
      },
      child: contentBox(context)
    );
  }

  void _showCustomDialog(BuildContext context) { //open dialog window
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
        Container( //title of dialog window
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
              color: Color.fromRGBO(33, 150, 243, 1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          child: AutoSizeText(
            dialogueTitle ?? 'Untitled',
            minFontSize: 36,
            maxFontSize: 48,
            style: GoogleFonts.comfortaa(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            //spacing: 10,
            children: [
              if (child != null) child!, //!!!!! this one
             // const SizedBox(height: 24),
              Container(
                //color: Colors.red,
                alignment: Alignment.bottomRight,
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 15,
                  children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        fixedSize: WidgetStateProperty.all(
                            Size(140, 30)
                        )
                    ),
                    onPressed: eventMethod,
                    child:  Text(
                      buttonTitle,
                      style: AppTheme.lightTheme.textTheme.labelSmall,
                    ),
                  ),
                  ElevatedButton(
                  style: ButtonStyle(
                      fixedSize: WidgetStateProperty.all(
                          Size(140, 30)
                      )
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    },
                  child:  Text(
                    'Закрыть',
                    style: AppTheme.lightTheme.textTheme.labelSmall,
                  ),
              ),
            ],
                )
              )
            ],
          ),
        ),
      ],
    );
  }
}
