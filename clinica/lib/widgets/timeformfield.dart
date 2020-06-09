import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

const timeExpression = r'^(\d{1,2})((?<=\d{2})\d{1,2})?$';
const timeFmt = 'HH:mm';

class _TimeTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var cleared = newValue.text.replaceAll(r'[^\d]+', '');
    var regex = new RegExp(timeExpression);
    var match = regex.firstMatch(cleared);

    var result = '';

    if (match != null) {
      var hora = match.group(1) ?? "";
      if (hora.length > 0) result += hora;

      var minuto = match.group(2) ?? "";
      if (minuto.length > 0) result += ':$minuto';

      if (!isValidTime(int.tryParse(hora) ?? 0, int.tryParse(minuto) ?? 0))
        result = oldValue.text;
    }

    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }

  bool isValidTime(int hora, int minuto) {
    if (hora >= 0 && hora <= 23 && minuto >= 0 && minuto <= 59)
      return true;
    else
      return false;
  }
}

class TimeFormField extends StatefulWidget {
  TimeFormField(this.controller, {Key key, this.decoration, this.validator})
      : super(key: key);

  final InputDecoration decoration;
  final FormFieldValidator<String> validator;
  final TextEditingController controller;

  @override
  State<StatefulWidget> createState() => _TimeFormField();
}

class _TimeFormField extends State<TimeFormField> {
  TimeOfDay selectedTime;

  FocusNode focus;

  static const maxLength = 5;

  @override
  void initState() {
    super.initState();

    this.focus = new FocusNode();
    this.focus.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (!focus.hasFocus) {
      final selTime = widget.controller.asTimeOfDay;
      if(selTime==null) return;
      widget.controller.fromTimeOfDay = selTime;
      setState(() {
        selectedTime = selTime;
      });
    }
  }

  @override
  void dispose() {
    focus.removeListener(_handleFocusChange);
    focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          TextFormField(
            focusNode: focus,
            controller: widget.controller,
            decoration: widget.decoration,
            validator: widget.validator,
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(maxLength),
              WhitelistingTextInputFormatter.digitsOnly,
              BlacklistingTextInputFormatter.singleLineFormatter,
              _TimeTextInputFormatter()
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(Icons.timer),
              onPressed: () => onPressedDateCallback(context),
              splashRadius: 25.0,
            ),
          )
        ],
      ),
    );
  }

  Future<VoidCallback> onPressedDateCallback(BuildContext context) async {
    var now = this.selectedTime ?? TimeOfDay.fromDateTime(DateTime.now());
    final TimeOfDay pickedTime = await showTimePicker(
      context: context,
      initialTime: now,
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = selectedTime;
      });
      this.widget.controller.fromTimeOfDay = pickedTime;
    }

    return null;
  }
}

extension TimeTextEditingControllerExtension on TextEditingController {


  TimeOfDay get asTimeOfDay {
    var df = DateFormat(timeFmt);

    var matcher = RegExp(timeExpression);
    var match = matcher.firstMatch(text.replaceAll(r'[^\d]+', ''));

    var _text = '';

    if (match != null) {
      var hora = match.group(1) ?? "";
      if (hora.length > 0) _text += hora.toString().padLeft(2, '0');

      var minuto = match.group(2) ?? "00";
      if (minuto.length > 0) _text += ':' + minuto.toString().padLeft(2, '0');
    }

    if (_text.length > 0)
      return TimeOfDay.fromDateTime(df.parse(_text));
    else
      return null;
  }

  set fromTimeOfDay(TimeOfDay hr) {
    var df = DateFormat(timeFmt);
    text = df.format(DateTime(0, 0, 0, hr.hour, hr.minute));
  }
}
