import 'file:///C:/Projetos/Unit/clinica/clinica/lib/pages/especialidades/especialidades.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class FloatButtonItem{
  final Icon icon;
  final String label;
  final VoidCallback onTap;

  FloatButtonItem({this.icon, this.label, this.onTap});
}

class FloatingButtons extends StatelessWidget {

  List<FloatButtonItem> actions = [];

  FloatingButtons({this.actions});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      visible: true,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      shape: CircleBorder(),
      children: actions.map((e) => SpeedDialChild(child: e.icon, label: e.label, onTap: e.onTap)).toList()
    );
  }
}
