import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final String? imageUrl;
  final String? buttonText;
  final Function()? onPressed;

  const InfoCard({
    Key? key,
    required this.title,
    required this.subtitle,
    this.icon,
    this.imageUrl,
    this.buttonText,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: (icon != null)
                ? Icon(icon)
                : null,
            title: Text(title),
            subtitle: Text(subtitle),
          ),
          (imageUrl != null)
              ? Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8),
            child: ClipOval(
              child: Image.network(
                imageUrl!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          )
              : Container(),
          (buttonText != null)
              ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onPressed,
                child: Text(buttonText!),
              ),
              const SizedBox(width: 8),
            ],
          )
              : Container(),
        ],
      ),
    );
  }
}
