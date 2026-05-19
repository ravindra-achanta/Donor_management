import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vikas_app/bloc_management/department/department_bloc.dart';
import 'package:vikas_app/bloc_management/department/department_event.dart';
import 'package:vikas_app/screeens/models/request/DepartmentRequest.dart';
import 'package:vikas_app/screeens/models/response/DepartmentResponse.dart';

class EditDepartmentPage extends StatefulWidget {
  final DepartmentResponse dept;

  const EditDepartmentPage({super.key, required this.dept});

  @override
  State<EditDepartmentPage> createState() => _EditDepartmentPageState();
}

class _EditDepartmentPageState extends State<EditDepartmentPage> {
  late TextEditingController nameController;
  late TextEditingController descController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.dept.departmentName);
    descController = TextEditingController(text: widget.dept.description);
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }

  void _updateDepartment() {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Department name is required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Pass String ID directly (UUID from backend)
    context.read<DepartmentBloc>().add(
      UpdateDepartmentEvent(
        widget.dept.id ?? '',  // ✅ String UUID
        DepartmentRequest(
          departmentName: nameController.text.trim(),
          description: descController.text.trim(),
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Department"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Department Name - Editable
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Department Name",
                border: OutlineInputBorder(),
                hintText: "Enter department name",
              ),
            ),

            const SizedBox(height: 16),

            // Description - Editable
            TextField(
              controller: descController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
                hintText: "Enter description",
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _updateDepartment,
                child: const Text("Update Department"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}