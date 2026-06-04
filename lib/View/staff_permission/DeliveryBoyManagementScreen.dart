import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DeliveryBoyManagementScreen extends StatelessWidget {
  const DeliveryBoyManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  elevation: 0,
  centerTitle: true,
  title: const Text(
    "Delivery Partners",
    style: TextStyle(
      fontWeight: FontWeight.bold,
    ),
  ),
),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('staff')
            .where('role', isEqualTo: 'delivery_boy')
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {

              final data =
                  docs[index].data() as Map<String, dynamic>;

              final uid = docs[index].id;

              return Container(
  margin: const EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 6,
  ),
  child: Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [

          Row(
            children: [

              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.green.shade100,
                child: Text(
                  (data['name'] ?? 'D')
                      .toString()
                      .substring(0, 1)
                      .toUpperCase(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      data['name'] ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      data['mobile'] ?? '',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                    Text(
                      data['email'] ?? '',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: data['status'] == 'approved'
                      ? Colors.green.shade100
                      : data['status'] == 'blocked'
                          ? Colors.red.shade100
                          : Colors.orange.shade100,
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Text(
                  data['status'] ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: data['status'] == 'approved'
                        ? Colors.green
                        : data['status'] == 'blocked'
                            ? Colors.red
                            : Colors.orange,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            children: [

              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('staff')
                        .doc(uid)
                        .update({
                      'status': 'approved',
                    });
                  },
                  icon: const Icon(Icons.check),
                  label: const Text("Approve"),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('staff')
                        .doc(uid)
                        .update({
                      'status': 'blocked',
                    });
                  },
                  icon: const Icon(Icons.block),
                  label: const Text("Block"),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  ),
);
            },
          );
        },
      ),
    );
  }
}