import 'package:flutter/material.dart';
import 'package:potato_apps/theme.dart';

class BlowerCard extends StatefulWidget {
  BlowerCard({
    super.key,
    required this.thumbIcon,
    required this.blowerValue,
    required this.blowerIndicator,
    required this.onToggle,
  });

  final MaterialStateProperty<Icon?> thumbIcon;
  final String blowerIndicator;
  final bool blowerValue;
  final ValueChanged<bool> onToggle;

  @override
  State<BlowerCard> createState() => _BlowerCardState();
}

class _BlowerCardState extends State<BlowerCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Image.asset(
            'assets/icon_fan.png',
            height: 36,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Blower',
                      style: blackTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: medium,
                      ),
                      overflow: TextOverflow.ellipsis),
                  Text(widget.blowerIndicator,
                      style: blackTextStyle.copyWith(
                          fontSize: 14, fontWeight: medium)),
                ],
              ),
            ),
          )
        ]),
        Spacer(),
        Switch(
            thumbIcon: widget.thumbIcon,
            value: widget.blowerValue,
            onChanged: widget.onToggle),
      ],
    );
  }
}