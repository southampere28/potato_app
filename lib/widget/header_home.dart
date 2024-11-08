import 'package:flutter/material.dart';
import 'package:potato_apps/theme.dart';
import 'package:intl/intl.dart';

class HeaderHomeWidget extends StatelessWidget {
  const HeaderHomeWidget({super.key, required this.fullname, this.profileURL});

  final String fullname;
  final String? profileURL;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('dd MMMM, yyyy').format(now);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          color: primaryColor,
          boxShadow: [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: const Offset(0, 8))
          ]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat Datang',
                style: whiteTextStyle,
              ),
              Text(
                fullname,
                style: whiteTextStyle.copyWith(
                    fontSize: 24,
                    fontWeight: bold,
                    overflow: TextOverflow.ellipsis),
              ),
              Text(
                formattedDate,
                style: whiteTextStyle,
              ),
            ],
          )),
          ClipOval(
            child: profileURL != ''
                ? Image.network(
                    profileURL!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/icon_profile.png',
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
          )
        ],
      ),
    );
  }
}
