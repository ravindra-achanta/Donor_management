import 'package:flutter/material.dart';

class NoticePopup {
  static void show({
    required BuildContext context,
    required String imageUrl,
    required String title,
    required String description,
    String cancelText = "OK",
    VoidCallback? onClosed,
  }) {
    bool isClosedCalled = false;

    void handleClose() {
      if (isClosedCalled) return; // ✅ prevent multiple calls
      isClosedCalled = true;
      onClosed?.call();
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              constraints: const BoxConstraints(maxWidth: 380),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 25,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// 🔥 SMALL IMAGE (OPTIONAL)
                    if (imageUrl.isNotEmpty)
                      Stack(
                        children: [
                          Image.network(
                            imageUrl,
                            height: 120, // ✅ smaller
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),

                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(dialogContext),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                    /// 🔥 CONTENT
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// HEADER
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.notifications,
                                  size: 16,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 8),

                             
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "Title: ",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color:Colors.brown,
                                        ),
                                      ),
                                      TextSpan(
                                        text: title,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              if (imageUrl.isEmpty)
                                GestureDetector(
                                  onTap: () => Navigator.pop(dialogContext),
                                  child: const Icon(Icons.close, size: 18),
                                ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          /// DESCRIPTION
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Notice: ",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.brown,
                                  ),
                                ),
                                TextSpan(
                                  text: description,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// ACTIONS
                          Row(
                            children: [
                              // TextButton(
                              //   onPressed: () => Navigator.pop(dialogContext),
                              //   child: const Text("Dismiss"),
                              // ),
                              const Spacer(),
                              
                              ElevatedButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade600,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  cancelText,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).then((_) {
      handleClose();
    });
  }
}
