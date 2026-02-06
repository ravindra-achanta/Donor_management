import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:vikas_app/screeens/common/NoDataFound.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class DonationListPage extends StatelessWidget {
  final List<Map<String, dynamic>> donations = [
    {
      'id': '1',
      'receipt': 'REC-1001',
      'name': 'ARUN KUMAR',
      'jnId': 'JN-1001',
      'mobile': '9876543210',
      'amount': 5000.00,
      'date': DateTime(2024, 3, 1),
      'seva': 'Annadanam',
    },
    {
      'id': '2',
      'receipt': 'REC-1002',
      'name': 'MEENA PATEL',
      'jnId': 'JN-1002',
      'mobile': '8765432109',
      'amount': 2500.00,
      'date': DateTime(2024, 3, 5),
      'seva': 'Vastra Dan',
    },
    {
      'id': '3',
      'receipt': 'REC-1003',
      'name': 'RAJESH VERMA',
      'jnId': 'JN-1003',
      'mobile': '7654321098',
      'amount': 10000.00,
      'date': DateTime(2024, 3, 10),
      'seva': 'Go Dan',
    },

  ];

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    final dateFormat = DateFormat('dd MMM yyyy');

    return Layout(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with title and actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                icon: const Icon(Icons.arrow_back, size: 22),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
                  Text(
                    'Donation Records',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search, size: 20),
                        onPressed: () {
                          // Search functionality
                        },
                        tooltip: 'Search',
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_month, size: 20),
                        onPressed: () {
                          // Calendar filter functionality
                        },
                        tooltip: 'Filter by Date',
                      ),
                      const SizedBox(width: 8),
                      // ElevatedButton.icon(
                      //   onPressed: () {
                      //     // Add donation functionality
                      //   },
                      //   icon: const Icon(Icons.add, size: 18),
                      //   label: const Text('Add Donation'),
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: Colors.brown,
                      //     foregroundColor: Colors.white,
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Table
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      // Table Header - Fixed with LayoutBuilder
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                            width: constraints.maxWidth,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              border: Border(
                                bottom: BorderSide(color: Colors.grey.shade200),
                              ),
                            ),
                            child: const Row(
                              children: [
                                _TableHeader(title: '#', width: 50),
                                _TableHeader(title: 'NAME', width: 150),
                                _TableHeader(title: 'JN-ID', width: 80),
                                _TableHeader(title: 'MOBILE', width: 100),
                                _TableHeader(title: 'AMOUNT', width: 100),
                                _TableHeader(title: 'DATE', width: 100),
                                _TableHeader(title: 'SEVA', width: 120),
                                _TableHeader(title: 'ACTIONS', width: 60),
                              ],
                            ),
                          );
                        },
                      ),

                      // Table Body
                      Expanded(
                        child: donations.isEmpty
                            ? Center(
                                child: NoDataState(
                                  title: 'No Donations Found',
                                  subtitle: 'No donation records available',
                                ),
                              )
                            : _DonationTable(
                                donations: donations,
                                currencyFormat: currencyFormat,
                                dateFormat: dateFormat,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DonationTable extends StatelessWidget {
  final List<Map<String, dynamic>> donations;
  final NumberFormat currencyFormat;
  final DateFormat dateFormat;

  const _DonationTable({
    required this.donations,
    required this.currencyFormat,
    required this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: donations.length,
      itemBuilder: (context, index) {
        final donation = donations[index];
        return _DonationRow(
          index: index,
          donation: donation,
          currencyFormat: currencyFormat,
          dateFormat: dateFormat,
        );
      },
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String title;
  final double width;

  const _TableHeader({required this.title, this.width = 80});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: Colors.brown,
        ),
      ),
    );
  }
}

class _DonationRow extends StatefulWidget {
  final int index;
  final Map<String, dynamic> donation;
  final NumberFormat currencyFormat;
  final DateFormat dateFormat;

  const _DonationRow({
    required this.index,
    required this.donation,
    required this.currencyFormat,
    required this.dateFormat,
  });

  @override
  State<_DonationRow> createState() => _DonationRowState();
}

class _DonationRowState extends State<_DonationRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return MouseRegion(
          onEnter: (_) {
            if (constraints.maxWidth > 0 && constraints.maxHeight > 0) {
              setState(() => _hovered = true);
            }
          },
          onExit: (_) {
            if (constraints.maxWidth > 0 && constraints.maxHeight > 0) {
              setState(() => _hovered = false);
            }
          },
          child: Container(
            color: _hovered ? Colors.blue.shade50 : Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: SizedBox(
                height: 48, // Fixed height for each row
                child: Row(
                  children: [
                    // #
                    SizedBox(
                      width: 50,
                      child: Center(
                        child: Text(
                          '${widget.index + 1}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 108, 107, 107),
                          ),
                        ),
                      ),
                    ),

                    // NAME
                    SizedBox(
                      width: 150,
                      child: Text(
                        widget.donation['name'] ?? '',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // JN-ID
                    SizedBox(
                      width: 80,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.brown.shade50,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.brown.shade100),
                          ),
                          child: Text(
                            widget.donation['jnId'] ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.brown.shade700,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),

                    // MOBILE
                    SizedBox(
                      width: 100,
                      child: Text(
                        widget.donation['mobile'] ?? '',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color.fromARGB(255, 105, 104, 104),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // AMOUNT
                    SizedBox(
                      width: 100,
                      child: Text(
                        widget.currencyFormat.format(widget.donation['amount']),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 62, 151, 67),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // DATE
                    SizedBox(
                      width: 100,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.dateFormat.format(widget.donation['date']),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),

                    // SEVA
                    SizedBox(
                      width: 120,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getSevaColor(widget.donation['seva']),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.donation['seva'] ?? '',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),

                    // ACTIONS (Only View icon)
                    SizedBox(
                      width: 60,
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            _showDonationDetails(context, widget.donation);
                          },
                          icon: const Icon(
                            Icons.remove_red_eye_outlined,
                            size: 18,
                            color: Colors.blue,
                          ),
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(),
                          tooltip: 'View Details',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getSevaColor(String? seva) {
    switch (seva?.toLowerCase()) {
      case 'annadanam':
        return Colors.orange.shade50;
      case 'vastra dan':
        return Colors.purple.shade50;
      case 'go dan':
        return Colors.brown.shade50;
      case 'book distribution':
        return Colors.blue.shade50;
      default:
        return Colors.grey.shade100;
    }
  }

  void _showDonationDetails(BuildContext context, Map<String, dynamic> donation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Donation Details"),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow("Receipt Number", donation['receipt']),
                _buildDetailRow("Donor Name", donation['name']),
                _buildDetailRow("JN ID", donation['jnId']),
                _buildDetailRow("Mobile", donation['mobile']),
                _buildDetailRow("Amount", widget.currencyFormat.format(donation['amount'])),
                _buildDetailRow("Date", widget.dateFormat.format(donation['date'])),
                _buildDetailRow("Seva", donation['seva']),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Color.fromARGB(255, 104, 102, 102),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}