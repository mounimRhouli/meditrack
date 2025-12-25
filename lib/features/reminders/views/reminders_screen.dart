import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/reminders_viewmodel.dart';

class RemindersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RemindersViewModel>();

    // Dégradé inspiré du logo "M"
    final mainGradient = LinearGradient(
      colors: [Color(0xFF42A5F5), Color(0xFF66BB6A)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mes Rappels",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: mainGradient),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: vm.reminders.length,
        itemBuilder: (context, index) {
          final reminder = vm.reminders[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            child: ListTile(
              leading: Icon(Icons.alarm, color: Color(0xFF42A5F5)),
              title: Text(
                reminder.time,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              subtitle: Text("Statut : ${reminder.status.name}"),
              trailing: Icon(
                Icons.check_circle_outline,
                color: Color(0xFF66BB6A),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF66BB6A),
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () => vm.addNewReminder("08:00"),
      ),
    );
  }
}
