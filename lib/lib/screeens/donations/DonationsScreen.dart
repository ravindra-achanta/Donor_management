import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class DonationsScreen extends StatelessWidget {
  const DonationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= HEADER =================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Donations",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _showAddDonationDialog(context);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add Donation"),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// ================= SUMMARY CARDS =================
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildSummaryCard(
                    title: 'TOTAL DONATIONS',
                    value: '₹1,24,500',
                    subtitle: 'LAST 30 DAYS',
                    icon: Icons.account_balance_wallet,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 16),
                  _buildSummaryCard(
                    title: "TODAY'S COLLECTION",
                    value: '₹12,400',
                    subtitle: 'UPDATED JUST NOW',
                    icon: Icons.today,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 16),
                  _buildSummaryCard(
                    title: 'SEVA BOOKINGS',
                    value: '45',
                    subtitle: 'ACTIVE BOOKINGS',
                    icon: Icons.book_online,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 16),
                  _buildSummaryCard(
                    title: 'ONLINE PAYMENTS',
                    value: '₹84,000',
                    subtitle: 'LAST 30 DAYS',
                    icon: Icons.payment,
                    color: Colors.purple,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            /// ================= SEARCH AND FILTER =================
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search donations...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      _showFilterOptions(context);
                    },
                    icon: const Icon(Icons.filter_list),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            /// ================= TABLE SECTION =================
            // Remove Expanded and use Container with fixed/calculated height
            Container(
              height: MediaQuery.of(context).size.height - 400, // Adjust based on your needs
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: _buildTable(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= SUMMARY CARD WIDGET =================
  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= DATA TABLE =================
  Widget _buildTable() {
    // Sample Data
    final donations = [
      {
        'sno': 1,
        'receipt': 'REC-1001',
        'name': 'ARUN KUMAR',
        'jnId': 'JN-1001',
        'mobile': '9876543210',
        'amount': '₹5000',
        'date': '2024-03-01',
        'category': 'GENERAL',
        'seva': '-',
        'type': 'OFFLINE',
        'mode': 'CASH',
      },
      {
        'sno': 2,
        'receipt': 'REC-1002',
        'name': 'MEENA PATEL',
        'jnId': 'JN-1002',
        'mobile': '8765432109',
        'amount': '₹2500',
        'date': '2024-03-05',
        'category': 'SEVA',
        'seva': 'Annasantharpana',
        'type': 'ONLINE',
        'mode': 'UPI',
      },
      {
        'sno': 3,
        'receipt': 'REC-1003',
        'name': 'RAJESH SHARMA',
        'jnId': 'JN-1003',
        'mobile': '7654321098',
        'amount': '₹10000',
        'date': '2024-03-10',
        'category': 'GENERAL',
        'seva': '-',
        'type': 'ONLINE',
        'mode': 'CARD',
      },
      {
        'sno': 4,
        'receipt': 'REC-1004',
        'name': 'PRIYA SINGH',
        'jnId': 'JN-1004',
        'mobile': '6543210987',
        'amount': '₹3500',
        'date': '2024-03-12',
        'category': 'SEVA',
        'seva': 'Archana',
        'type': 'OFFLINE',
        'mode': 'CASH',
      },
      {
        'sno': 5,
        'receipt': 'REC-1005',
        'name': 'VIJAY KUMAR',
        'jnId': 'JN-1005',
        'mobile': '9432109876',
        'amount': '₹7500',
        'date': '2024-03-15',
        'category': 'GENERAL',
        'seva': '-',
        'type': 'ONLINE',
        'mode': 'UPI',
      },
    ];

    return Column(
      children: [
        // Table header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Row(
            children: [
              SizedBox(width: 60, child: Text('SNO', style: TextStyle(fontWeight: FontWeight.bold))),
              SizedBox(width: 100, child: Text('RECEIPT', style: TextStyle(fontWeight: FontWeight.bold))),
              SizedBox(width: 150, child: Text('NAME', style: TextStyle(fontWeight: FontWeight.bold))),
              SizedBox(width: 100, child: Text('AMOUNT', style: TextStyle(fontWeight: FontWeight.bold))),
              SizedBox(width: 120, child: Text('DATE', style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(child: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
            ],
          ),
        ),
        
        // Table rows
        Expanded(
          child: ListView.builder(
            itemCount: donations.length,
            itemBuilder: (context, index) {
              final donation = donations[index];
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 60, child: Text('${donation['sno']}')),
                    SizedBox(
                      width: 100,
                      child: Text(
                        donation['receipt']as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(donation['name']as String),
                          const SizedBox(height: 2),
                          Text(
                            donation['jnId'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Text(
                        donation['amount']as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: donation['type'] == 'ONLINE'
                              ? Colors.green.shade50
                              : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          donation['date'] as String,
                          style: TextStyle(
                            color: donation['type'] == 'ONLINE'
                                ? Colors.green.shade700
                                : Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            tooltip: 'View',
                            icon: const Icon(
                              Icons.visibility,
                              color: Colors.blue,
                              size: 20,
                            ),
                            onPressed: () {
                              _showDonationDetails(donation);
                            },
                          ),
                          IconButton(
                            tooltip: 'Edit',
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.orange,
                              size: 20,
                            ),
                            onPressed: () {
                              _editDonation(donation);
                            },
                          ),
                          IconButton(
                            tooltip: 'Delete',
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 20,
                            ),
                            onPressed: () => _confirmDelete(donation),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// ================= ADD DONATION DIALOG =================
  void _showAddDonationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Donation'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Mobile Number',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Donation added successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  /// ================= FILTER OPTIONS =================
  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Options',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildFilterOption('Today', Icons.today),
              _buildFilterOption('Last 7 Days', Icons.calendar_today),
              _buildFilterOption('Last 30 Days', Icons.date_range),
              _buildFilterOption('All Time', Icons.all_inclusive),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Apply Filter'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Handle filter selection
      },
    );
  }

  /// ================= DONATION DETAILS =================
  void _showDonationDetails(Map<String, dynamic> donation) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Donation Details - ${donation['receipt']}'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Name:', donation['name']!),
                _buildDetailRow('JN-ID:', donation['jnId']!),
                _buildDetailRow('Mobile:', donation['mobile']!),
                _buildDetailRow('Amount:', donation['amount']!),
                _buildDetailRow('Date:', donation['date']!),
                _buildDetailRow('Category:', donation['category']!),
                _buildDetailRow('Seva:', donation['seva']!),
                _buildDetailRow('Type:', donation['type']!),
                _buildDetailRow('Mode:', donation['mode']!),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF555555),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= EDIT DONATION =================
  void _editDonation(Map<String, dynamic> donation) {
    Get.snackbar(
      'Edit Donation',
      'Editing ${donation['receipt']}',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  /// ================= DELETE CONFIRM =================
  void _confirmDelete(Map<String, dynamic> donation) {
    Get.defaultDialog(
      title: "Delete Donation",
      middleText:
          "Are you sure you want to delete donation ${donation['receipt']}?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        Get.snackbar(
          'Deleted',
          'Donation ${donation['receipt']} deleted successfully',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        // TODO: call delete API
      },
    );
  }
}