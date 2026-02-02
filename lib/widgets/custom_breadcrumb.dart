// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class CustomBreadcrumb extends StatelessWidget {
//   final List<BreadcrumbItem> items;

//   const CustomBreadcrumb({Key? key, required this.items}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: List.generate(items.length, (index) {
//         final item = items[index];
//         final isLast = index == items.length - 1;

//         return Row(
//           children: [
//             GestureDetector(
//               onTap: item.route != null && !isLast
//                   ? () => Get.toNamed(item.route!)
//                   : null,
//               child: Text(
//                 item.name,
//                 style: TextStyle(
//                   fontWeight: isLast ? FontWeight.w600 : FontWeight.bold,
//                   color: isLast ? Colors.black : Colors.blue,
//                   decoration: isLast ? null : TextDecoration.underline,
//                 ),
//               ),
//             ),
//             if (!isLast)
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 6.0),
//                 child: Icon(Icons.chevron_right, size: 18, color: Colors.grey),
//               ),
//           ],
//         );
//       }),
//     );
//   }
// }

// class BreadcrumbItem {
//   final String name;
//   final String? route;

//   BreadcrumbItem({required this.name, this.route});
// }
