import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_runner/core/data/menu_item_data.dart';
import 'package:net_runner/core/data/pair.dart';
import 'package:net_runner/core/presentation/widgets/mt_dialog_tile.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';
import 'package:net_runner/core/presentation/mt_headpage.dart' as headpage;

// ignore: must_be_immutable
class MtDropMenu extends StatelessWidget {
  final List<MenuItemData> popupMenuItems;
  // Pair
  MtDropMenu(
      {super.key,
      this.title,
      required this.popupMenuItems,
      required this.actionsTitle});
  String? title;
  String actionsTitle;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuItemData>(
      onSelected: (MenuItemData value) {
        MtShowDialog(child: value.child, dialogueTitle: value.title)
            .showCustomDialogue(context);
      },
      itemBuilder: (context) => popupMenuItems
          .map((item) => PopupMenuItem<MenuItemData>(
                child: DropMenuItemWidget(menuItemData: item),
                value: item
              ))
          .toList(),
      child: Container(
        alignment: Alignment.center,
        height: 40,
        //width: 80,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 1, color: Colors.white)),
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title!,
          style: AppTheme.lightTheme.textTheme.displaySmall,
        ),
      ),
    );
  }
}


class DropMenuItemWidget extends StatelessWidget {
  final MenuItemData menuItemData;
  const DropMenuItemWidget({super.key, required this.menuItemData});

  @override
  Widget build(BuildContext context) {
    return PopupMenuItem(
      value: menuItemData.child,
      child: Row(
        children: [
          Icon(Icons.ac_unit, color: AppTheme.lightTheme.colorScheme.onSurface),
          const SizedBox(
            width: 8,
          ),
          Text(menuItemData.title,
              style: AppTheme.lightTheme.textTheme.bodySmall)
        ],
      ),
    );
  }
}
