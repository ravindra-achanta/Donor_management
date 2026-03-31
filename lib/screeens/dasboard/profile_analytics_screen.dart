// import 'package:flutter/material.dart';
// import 'package:vikas_app/views/layouts/layout.dart';

// class ProfileAnalyticsScreen extends StatefulWidget {
//   const ProfileAnalyticsScreen({super.key});

//   @override
//   State<ProfileAnalyticsScreen> createState() =>
//       _ProfileAnalyticsScreenState();
// }

// class _ProfileAnalyticsScreenState extends State<ProfileAnalyticsScreen> {
//   String selectedRange = "This Month";
//   String sortBy = "Changes";

//   @override
//   Widget build(BuildContext context) {
//     return Layout(
//       child: Center(
//         child: Container(
//           constraints: const BoxConstraints(maxWidth: 1100),
//           padding: const EdgeInsets.all(24),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // ===== HEADER =====
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: const [
//                       Icon(Icons.trending_up, color: Colors.orange),
//                       SizedBox(width: 10),
//                       Text(
//                         "Profile Change Analytics",
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.close),
//                     onPressed: () => Navigator.pop(context),
//                   )
//                 ],
//               ),

//               const SizedBox(height: 20),

//               // ===== RANGE SELECTOR =====
//               Row(
//                 children: ["This Week", "This Month", "This Year"].map((e) {
//                   final isSelected = selectedRange == e;
//                   return Padding(
//                     padding: const EdgeInsets.only(right: 8),
//                     child: ChoiceChip(
//                       label: Text(e),
//                       selected: isSelected,
//                       onSelected: (_) =>
//                           setState(() => selectedRange = e),
//                     ),
//                   );
//                 }).toList(),
//               ),

//               const SizedBox(height: 24),

//               // ===== STATS CARDS =====
//               Row(
//                 children: [
//                   _statCard(
//                     title: "PROFILES CHANGED",
//                     value: "34",
//                     subtitle: "out of 45 total",
//                   ),
//                   const SizedBox(width: 16),
//                   _statCard(
//                     title: "CHANGE RATE",
//                     value: "75.6%",
//                     subtitle: "↑ 12.4% vs last period",
//                     valueColor: Colors.green,
//                   ),
//                   const SizedBox(width: 16),
//                   _progressCard(),
//                 ],
//               ),

//               const SizedBox(height: 28),

//               // ===== LIST HEADER + DROPDOWN =====
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     "Member-wise Profile Changes",
//                     style:
//                         TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   DropdownButton<String>(
//                     value: sortBy,
//                     borderRadius: BorderRadius.circular(12),
//                     items: const [
//                       DropdownMenuItem(
//                           value: "Changes", child: Text("Changes Wise")),
//                       DropdownMenuItem(
//                           value: "Percentage",
//                           child: Text("Percentage Wise")),
//                     ],
//                     onChanged: (v) => setState(() => sortBy = v!),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 12),

//               // ===== MEMBER LIST =====
//               ListView(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 children: const [
//                   _MemberTile("Arun Kumar", "2 days ago", 8),
//                   _MemberTile("Meena Patel", "1 week ago", 5),
//                   _MemberTile("Ravi Shankar", "Yesterday", 12),
//                   _MemberTile("Priya Verma", "3 days ago", 3),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ================= STAT CARD =================
//   Widget _statCard({
//     required String title,
//     required String value,
//     required String subtitle,
//     Color valueColor = Colors.black,
//   }) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: const Color(0xFFF8FAFF),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(title,
//                 style:
//                     TextStyle(fontSize: 12, color: Colors.grey.shade600)),
//             const SizedBox(height: 10),
//             Text(
//               value,
//               style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                   color: valueColor),
//             ),
//             const SizedBox(height: 6),
//             Text(subtitle,
//                 style:
//                     TextStyle(fontSize: 13, color: Colors.grey.shade600)),
//           ],
//         ),
//       ),
//     );
//   }

//   // ================= PROGRESS CARD =================
//   Widget _progressCard() {
//     return Container(
//       width: 200,
//       height: 130,
//       decoration: BoxDecoration(
//         color: const Color(0xFFF8FAFF),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Center(
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             CircularProgressIndicator(
//               value: 0.756,
//               strokeWidth: 8,
//               color: Colors.orange,
//               backgroundColor: Colors.orange.withOpacity(0.2),
//             ),
//             const Text(
//               "75.6%",
//               style:
//                   TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ================= MEMBER TILE =================
// class _MemberTile extends StatelessWidget {
//   final String name;
//   final String lastChange;
//   final int count;

//   const _MemberTile(this.name, this.lastChange, this.count);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF9FBFF),
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundColor: Colors.blue.shade100,
//             child: Text(name[0]),
//           ),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(name,
//                     style:
//                         const TextStyle(fontWeight: FontWeight.w600)),
//                 const SizedBox(height: 4),
//                 Text(
//                   "Last change: $lastChange",
//                   style: TextStyle(
//                       fontSize: 12, color: Colors.grey.shade600),
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             children: [
//               Text(
//                 "$count",
//                 style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue),
//               ),
//               const Text("CHANGES",
//                   style: TextStyle(fontSize: 10, color: Colors.grey)),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
