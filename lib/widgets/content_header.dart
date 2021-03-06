import 'package:flutter/material.dart';
import 'package:weather_application/widgets/empty_widget.dart';

class ContentHeader extends StatelessWidget {
  final String label;
  final String value;
  final IconData iconData;

  ContentHeader(this.label, this.value, {this.iconData});

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          this.label,
          style: TextStyle(
              color: _theme
                  .accentColor),
        ),
        SizedBox(
          height: 5,
        ),
        this.iconData != null
            ? Icon(
                iconData,
                color: _theme.accentColor,
                size: 20,
              )
            : EmptyWidget(),
        SizedBox(
          height: 10,
        ),
        Text(
          this.value,
          style:
              TextStyle(color: _theme.accentColor),
        ),
      ],
    );
  }
}
