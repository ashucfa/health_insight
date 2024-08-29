import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_insight/screens/add_exercise.dart';
import 'package:health_insight/screens/login_screen.dart';
import 'package:health_insight/screens/statics_screen.dart';

import '../widgets/exit_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Stopwatch stopwatch;
  Timer? timer;

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    user = auth.currentUser; // Initialize user
    stopwatch = Stopwatch(); // Initialize the stopwatch
  }

  String returnFormattedText() {
    var milli = stopwatch.elapsed.inMilliseconds;

    //String milliseconds = (milli % 1000).toString().padLeft(3, '0');
    String seconds = ((milli ~/ 1000) % 60).toString().padLeft(2, '0');
    String minutes = ((milli ~/ 1000) ~/ 60).toString().padLeft(2, '0');
    String hours = ((milli ~/ 1000) ~/ 3600).toString().padLeft(2, '0');

    return "$hours:$minutes:$seconds";
  }

  // Popup for Tracking Time
  void showTimerDialog(BuildContext context, String exerciseName) {
    stopwatch.reset();
    stopwatch.start();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            timer = Timer.periodic(
              const Duration(milliseconds: 30),
                  (Timer t) {
                setState(() {}); // Update the timer in the dialog
              },
            );

            return AlertDialog(
              title: Text("Timer for $exerciseName"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    returnFormattedText(),
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (stopwatch.isRunning) {
                        stopwatch.stop();
                      } else {
                        stopwatch.start();
                      }
                      setState(() {}); // Update button state
                    },
                    child: Text(stopwatch.isRunning ? 'Stop' : 'Start'),
                  ),
                  if (!stopwatch
                      .isRunning) // Show Add button only if timer is stopped
                    ElevatedButton(
                      onPressed: () async {
                        final recordedTime = returnFormattedText();
                        final currentDate = DateTime.now().toLocal();
                        final userDetails = user?.email ?? 'Unknown';

                        if (exerciseName.isNotEmpty &&
                            recordedTime.isNotEmpty &&
                            userDetails.isNotEmpty) {
                          // Reference to the Firestore collection 'statics'
                          CollectionReference statics =
                          FirebaseFirestore.instance.collection('statics');

                          // Query to check if a record exists for the same exercise and date
                          QuerySnapshot existingRecord = await statics
                              .where('exerciseName', isEqualTo: exerciseName)
                              .where('date', isEqualTo: DateTime(currentDate.year, currentDate.month, currentDate.day))
                              .get();

                          if (existingRecord.docs.isNotEmpty) {
                            // Update existing record
                            var docId = existingRecord.docs.first.id;
                            var existingData = existingRecord.docs.first.data() as Map<String, dynamic>;
                            var existingTime = existingData['recordedTime'] as String;
                            var updatedTime = addTimes(existingTime, recordedTime);

                            await statics.doc(docId).update({
                              'recordedTime': updatedTime,
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Recorded time updated successfully')),
                            );
                          } else {
                            // Add new record
                            await statics.add({
                              'exerciseName': exerciseName,
                              'recordedTime': recordedTime,
                              'user': userDetails,
                              'date': DateTime(currentDate.year, currentDate.month, currentDate.day),
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Recorded time added successfully')),
                            );
                          }
                        }

                        Navigator.of(context).pop();
                      },
                      child: const Text('Add'),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    stopwatch.reset(); // Reset timer when closing dialog
                    timer?.cancel(); // Cancel the timer
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      stopwatch.reset(); // Ensure the timer is reset if the dialog is dismissed
      timer?.cancel(); // Stop the timer
    });
  }

// Function to add two time strings
  String addTimes(String time1, String time2) {
    final format = RegExp(r'(\d{2}):(\d{2}):(\d{2})');
    final match1 = format.firstMatch(time1)!;
    final match2 = format.firstMatch(time2)!;

    final hours1 = int.parse(match1.group(1)!);
    final minutes1 = int.parse(match1.group(2)!);
    final seconds1 = int.parse(match1.group(3)!);

    final hours2 = int.parse(match2.group(1)!);
    final minutes2 = int.parse(match2.group(2)!);
    final seconds2 = int.parse(match2.group(3)!);

    final totalSeconds = (hours1 * 3600 + minutes1 * 60 + seconds1) +
        (hours2 * 3600 + minutes2 * 60 + seconds2);

    final newHours = totalSeconds ~/ 3600;
    final newMinutes = (totalSeconds % 3600) ~/ 60;
    final newSeconds = totalSeconds % 60;

    return '${newHours.toString().padLeft(2, '0')}:${newMinutes.toString().padLeft(2, '0')}:${newSeconds.toString().padLeft(2, '0')}';
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? result = await showExitDialog(context);
        return result ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('exercises')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  var exercises = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      var exercise = exercises[index];

                      return ListTile(
                        leading: CircleAvatar(
                          child: Text((index + 1).toString()),
                        ),
                        title: Text(exercise['name']),
                        subtitle: Text(exercise['category']),
                        trailing: ElevatedButton(
                          onPressed: () {
                            showTimerDialog(context, exercise['name']);
                          },
                          child: const Text('Start'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xff9DCEFF),
                    Color(0xff92A3FD),
                  ]),
                  borderRadius: BorderRadius.circular(100)),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                      Colors.transparent),
                  shadowColor: WidgetStateProperty.all<Color>(
                      Colors.transparent),
                ),
                onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return StaticsScreen();
                    },));
                },
                child: const Text(
                  'Statics',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: 'PoppinsBold',
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,)
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddExercise()),
            );
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<bool> showExitDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => const ExitDialog(),
    );
  }
}
