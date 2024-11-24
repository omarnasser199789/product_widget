import 'package:flutter/material.dart';

/// A custom PlayButton widget that displays a play icon and an optional loading indicator.
class PlayButton extends StatelessWidget {
  /// Callback to handle tap events on the button.
  final VoidCallback onTap;

  /// Indicates whether a loading indicator should be displayed.
  final bool isLoading;

  /// Constructor for [PlayButton].
  const PlayButton({
    Key? key,
    required this.onTap,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Circular button background with border and play icon.
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5), // Semi-transparent black background.
                borderRadius: BorderRadius.circular(10000), // Creates a perfect circle.
                border: Border.all(
                  color: Theme.of(context).primaryColor, // Border color matches theme's primary color.
                  width: 3.0, // Border width.
                ),
              ),
              padding: const EdgeInsets.all(8), // Padding around the play icon.
              child: Icon(
                Icons.play_arrow,
                size: 20,
                color: Theme.of(context).primaryColor, // Play icon color matches theme's primary color.
              ),
            ),

            // Loading indicator displayed on top of the play button when `isLoading` is true.
            if (isLoading)
              CircularProgressIndicator(
                color: Theme.of(context).splashColor, // Progress indicator color matches theme's splash color.
                strokeWidth: 3.0, // Thickness of the progress indicator.
              ),
          ],
        ),
      ),
    );
  }
}
