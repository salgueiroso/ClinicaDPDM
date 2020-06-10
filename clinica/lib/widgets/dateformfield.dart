import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class _DateTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var cleared = newValue.text.replaceAll(r'[^\d]+', '');
    var regex =
        new RegExp(r'^(\d{1,2})((?<=\d{2})\d{1,2})?((?<=\d{4})\d{1,4})?$');
    var match = regex.firstMatch(cleared);

    var result = '';
    var dia = '';
    var mes = '';
    var ano = '';

    if (match != null) {
      dia = match.group(1) ?? "";
      if (dia.length > 0) result += dia;

      mes = match.group(2) ?? "";
      if (mes.length > 0) result += '/$mes';

      ano = match.group(3) ?? "";
      if (ano.length > 0) result += '/$ano';
    }

    if (!isValidDate(
        int.tryParse(dia) ?? 1,
        int.tryParse(mes == "0" ? "1" : mes) ?? 1,
        int.tryParse(ano) ?? 1)) result = oldValue.text;

    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }

  bool isValidDate(int dia, int mes, int ano) {
    var result = '';

    var _dia = dia.toString().padLeft(2, '0');
    result += _dia;

    var _mes = mes.toString().padLeft(2, '0');
    result += '/' + _mes;

    var _ano = ano.toString().padLeft(4, '0');
    result += '/' + _ano;

    var df = DateFormat('dd/MM/yyyy');
    var data = df.parse(result);
    var dd = data.day;
    var dm = data.month;
    var da = data.year;

    if (dia == dd && mes == dm && ano == da)
      return true;
    else
      return false;
  }
}

class DateFormField extends StatefulWidget {
  DateFormField(this.controller,
      {Key key,
      this.decoration,
      this.validator,
      this.initialDate,
      this.firstDate,
      this.lastDate})
      : super(key: key);

  final InputDecoration decoration;
  final FormFieldValidator<DateTime> validator;
  final TextEditingController controller;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  State<StatefulWidget> createState() => _DateFormField();
}

class _DateFormField extends State<DateFormField> {
  static const maxLength = 10;

  DateTime selectedDate;
  FormFieldValidator<String> _validator;

  @override
  void initState() {
    super.initState();

    _validator = (valueStr) {
      var df = DateFormat('dd/MM/yyyy');
      var data = df.parse(valueStr);
      return widget.validator?.call(data);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          TextFormField(
            controller: widget.controller,
            decoration: widget.decoration,
            validator: _validator,
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(maxLength),
              WhitelistingTextInputFormatter.digitsOnly,
              BlacklistingTextInputFormatter.singleLineFormatter,
              _DateTextInputFormatter()
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () => onPressedDateCallback(context),
              splashRadius: 25.0,
            ),
          )
        ],
      ),
    );
  }

  Future<VoidCallback> onPressedDateCallback(BuildContext context) async {
    var now = this.selectedDate ?? widget.initialDate ?? DateTime.now();
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: widget.firstDate ?? DateTime(now.year - 130),
        lastDate: now);

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
      this.widget.controller.fromDateTime = pickedDate;
    }
    return null;
  }
}

extension DateTextEditingControllerExtension on TextEditingController {
  static const fmt = 'dd/MM/yyyy';

  DateTime get asDateTime {
    var df = DateFormat(fmt);
    return df.parse(text);
  }

  set fromDateTime(DateTime dt) {
    var df = DateFormat(fmt);
    text = df.format(dt);
  }
}
