import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/image_strings.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget{
  const DashboardAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const Icon(Icons.notifications, color: Colors.black,),
      title: const Image(image: AssetImage(moLoginImage), height: 40.0),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 20.0, top: 7.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0), color: PCardBgColor),
          child: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        )
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(55.0);
}