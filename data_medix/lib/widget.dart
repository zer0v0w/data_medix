
import 'package:flutter/material.dart';
//fading text

class FadingText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const FadingText(this.text, {super.key, required this.style});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.black,

            const Color.fromARGB(0, 0, 0, 0), // Fades out
          ],
          stops: [0.8, 1.0], // Adjust for fade length
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.clip, // Ensures text stays within bounds
          style: style,
        ),
      ),
    );
  }
}