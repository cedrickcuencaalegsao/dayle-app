import 'package:flutter/material.dart';

class AddPlan extends StatefulWidget {
  const AddPlan({super.key});

  @override
  AddPlanState createState() => AddPlanState();
}

class AddPlanState extends State<AddPlan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Plan"),
      ),
      body: const Center(
        child: Text("Add Plan"),
      ),
    );
  }
}
