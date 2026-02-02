import 'package:flutter/material.dart';
import 'package:vikas_app/screeens/models/request/karyakartha.dart';
import 'package:vikas_app/views/layouts/layout.dart';
// import your Karyakartha model
// import 'package:vikas_app/features/karyakarthas/data/models/karyakartha.dart';

class KaryakarthaViewPage extends StatelessWidget {
  final Karyakartha karyakartha;

  const KaryakarthaViewPage({super.key, required this.karyakartha});

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'View Karyakartha',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Back"),
                )
              ],
            ),
            const SizedBox(height: 16),

            /// INFO LIST
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    InfoTile(title: 'K-ID', value: karyakartha.id),
                    InfoTile(title: 'Name', value: karyakartha.name),
                    InfoTile(title: 'Mobile', value: karyakartha.mobile),
                    InfoTile(title: 'Email', value: karyakartha.email),
                    InfoTile(title: 'Role', value: karyakartha.role),
                    InfoTile(title: 'Address', value: karyakartha.address),
                    InfoTile(title: 'DOB', value: karyakartha.dob),
                    InfoTile(title: 'Status', value: karyakartha.status),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String title;
  final String value;

  const InfoTile({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '$title:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
