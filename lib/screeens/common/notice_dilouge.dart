import 'package:flutter/material.dart';

class NoticePopup {
  NoticePopup._();

  static void show({
    required BuildContext context,
    required String imageUrl,
    required String title,
    required String description,
    String cancelText = "Close",
    VoidCallback? onClosed,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Notice",
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(seconds: 2),
      pageBuilder: (_, __, ___) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, animation, _, __) {
        final curvedValue = Curves.easeOutBack.transform(animation.value);
        return Opacity(
          opacity: animation.value,
          child: Transform.scale(
            scale: curvedValue,
            child: Center(
              child: _NoticeDialogContent(
                imageUrl: imageUrl,
                title: title,
                description: description,
                cancelText: cancelText,
              ),
            ),
          ),
        );
      },
    ).then((_) {
      onClosed?.call();
    });
  }
}

class _NoticeDialogContent extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String cancelText;

  const _NoticeDialogContent({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.cancelText,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Material(
      color: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: screenWidth < 600 ? screenWidth * 0.9 : 480,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
          
              Positioned(
                right: 8,
                top: 8,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  splashRadius: 18,
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
            
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      imageUrl,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 180,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image, size: 60),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                    child: Column(
                      children: [
                      
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 12),

                    
                        Text(
                          description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 22),

                      
                        SizedBox(
                          width: 120,
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(cancelText),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}