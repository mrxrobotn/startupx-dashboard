import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:startupx/authentication/screens/home/organization_screen.dart';
import '../../../constants.dart';
import '../authentication/components/rounded_button.dart';

class Tasks extends StatelessWidget {
  Tasks({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController taskNameController = TextEditingController();

  final TextEditingController taskPriceController = TextEditingController();

  final TextEditingController taskDurController = TextEditingController();

  final TextEditingController taskRevDurController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: Icon(Icons.add_task, size: 120)),
            const SizedBox(
              height: 30,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: taskNameController,
                    keyboardType: TextInputType.name,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                        hintText: "Activity Name",
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: const BorderSide(
                                width: 0, style: BorderStyle.none)),
                        filled: true,
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        fillColor: Colors.grey[300]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: taskPriceController,
                    keyboardType: TextInputType.number,
                    autofocus: false,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                        hintText: "Activity Price",
                        prefixIcon: const Icon(Icons.price_change_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: const BorderSide(
                                width: 0, style: BorderStyle.none)),
                        filled: true,
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        fillColor: Colors.grey[300]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: taskDurController,
                    keyboardType: const TextInputType.numberWithOptions(),
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                        hintText: "Activity Duration",
                        prefixIcon: const Icon(Icons.timelapse),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: const BorderSide(
                                width: 0, style: BorderStyle.none)),
                        filled: true,
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        fillColor: Colors.grey[300]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: taskRevDurController,
                    keyboardType: const TextInputType.numberWithOptions(),
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                        hintText: "Activity Revenue Duration",
                        prefixIcon: const Icon(Icons.timer),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: const BorderSide(
                                width: 0, style: BorderStyle.none)),
                        filled: true,
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        fillColor: Colors.grey[300]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RoundedButton(
                      label: "Add",
                      onPressed: () {
                        if (taskNameController.text.isNotEmpty &&
                            taskRevDurController.text.isNotEmpty &&
                            taskDurController.text.isNotEmpty &&
                            taskPriceController.text.isNotEmpty) {
                          String name = taskNameController.text;
                          double price = double.parse(taskPriceController.text);
                          double duration =
                              double.parse(taskDurController.text);
                          double rev_duration =
                              double.parse(taskRevDurController.text);
                          bool isChecked = false;
                          addTask(
                              name, price, duration, rev_duration, isChecked);

                          taskNameController.text = '';
                          taskRevDurController.text = '';
                          taskDurController.text = '';
                          taskPriceController.text = '';

                          Navigator.of(context).pop();
                        }
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  RoundedButton(
                    label: 'Close',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future addTask(String name, double price, double duration,
      double rev_duration, bool isChecked) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String? userId = user?.uid;

    CollectionReference tasksCollection =
        orgCollRef.doc(userId).collection('tasks');

    await tasksCollection.add({
      'name': name,
      'price': price,
      'duration': duration,
      'revenue_duration': rev_duration,
      'isChecked': isChecked
    });
  }
}

class TasksList extends StatefulWidget {
  const TasksList({Key? key}) : super(key: key);

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  final TextEditingController taskNameController = TextEditingController();

  final TextEditingController taskPriceController = TextEditingController();

  final TextEditingController taskDurController = TextEditingController();

  final TextEditingController taskRevDurController = TextEditingController();

  final CollectionReference _tasksCollection =
      orgCollRef.doc(userId).collection('tasks');

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      color: Constants.purpleLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: double.infinity,
        height: 800,
        decoration: const BoxDecoration(),
        child: StreamBuilder(
          stream: _tasksCollection.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.all(5),
                    color: Constants.listileColor,
                    child: ListTile(
                      textColor: Constants.blackColor,
                      title: Row(
                        children: [
                          const Icon(Icons.task),
                          const Text('Name: '),
                          Text(documentSnapshot['name']),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          const Icon(Icons.monetization_on_outlined),
                          const Text('Price: '),
                          Text('\$${documentSnapshot['price']}'),
                        ],
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                color: Constants.blackColor,
                                icon: const Icon(Icons.edit),
                                onPressed: () => _update(documentSnapshot)),
                            IconButton(
                                color: Constants.blackColor,
                                icon: const Icon(Icons.delete),
                                onPressed: () => _delete(documentSnapshot.id)),
                          ],
                        ),
                      ),
                      onTap: () {},
                      leading: Checkbox(
                          checkColor: Constants.blackColor,
                          value: documentSnapshot['isChecked'],
                          onChanged: (bool? value) {
                            documentSnapshot.reference
                                .update({'isChecked': value});
                          },
                          shape: const CircleBorder(),
                          fillColor:
                              MaterialStateProperty.resolveWith((Set states) {
                            if (states.contains(MaterialState.disabled)) {
                              return Colors.orange.withOpacity(.32);
                            }
                            return const Color(0xff06bbfb);
                          })),
                    ),
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      taskNameController.text = documentSnapshot['name'];
      taskPriceController.text = documentSnapshot['price'].toString();
      taskDurController.text = documentSnapshot['duration'].toString();
      taskRevDurController.text =
          documentSnapshot['revenue_duration'].toString();
    }

    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Update details'),
        content: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: Icon(Icons.edit_note, size: 120)),
                Column(
                  children: [
                    TextField(
                      keyboardType: TextInputType.name,
                      controller: taskNameController,
                      decoration:
                          const InputDecoration(labelText: 'Activity Name'),
                    ),
                    TextField(
                      keyboardType: const TextInputType.numberWithOptions(),
                      controller: taskPriceController,
                      decoration:
                          const InputDecoration(labelText: 'Activity Price'),
                    ),
                    TextField(
                      keyboardType: const TextInputType.numberWithOptions(),
                      controller: taskDurController,
                      decoration: const InputDecoration(
                        labelText: 'Activity Duration',
                      ),
                    ),
                    TextField(
                      controller: taskRevDurController,
                      keyboardType: const TextInputType.numberWithOptions(),
                      decoration: const InputDecoration(
                        labelText: 'Activity Revenue Duration',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        TextButton(
                          child: const Text('Update'),
                          onPressed: () async {
                            final String name = taskNameController.text;
                            final double price =
                                double.parse(taskPriceController.text);
                            final double duration =
                                double.parse(taskDurController.text);
                            final double revDuration =
                                double.parse(taskRevDurController.text);
                            await _tasksCollection
                                .doc(documentSnapshot!.id)
                                .update({
                              'name': name,
                              'price': price,
                              'duration': duration,
                              'revenue_duration': revDuration,
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                        const Spacer(),
                        TextButton(
                          child: const Text('Close'),
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _delete(String taskId) async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete Activity?'),
        content: const Text('Are you sure you want to delete this Activity?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'No'),
            child: const Text('NO'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Yes');
              _tasksCollection.doc(taskId).delete();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('You have successfully deleted an Activity')));
            },
            child: const Text('YES'),
          ),
        ],
      ),
    );
  }
}

class Investors extends StatefulWidget {
  const Investors({Key? key}) : super(key: key);

  @override
  State<Investors> createState() => _InvestorsState();
}

class _InvestorsState extends State<Investors> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController investorNameController = TextEditingController();

  final TextEditingController investorDescController = TextEditingController();

  final TextEditingController amountMinController = TextEditingController();

  final TextEditingController amountMaxController = TextEditingController();

  var items = [
    'Friends & Family',
    'Angel Investor',
    'Small Venture Capital',
  ];

  // Initial Selected Value
  String dropdownvalue = 'Friends & Family';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                "assets/images/signup.png",
                width: 150,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: investorNameController,
                    keyboardType: TextInputType.name,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                        hintText: "Name",
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: const BorderSide(
                                width: 0, style: BorderStyle.none)),
                        filled: true,
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        fillColor: Colors.grey[300]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: investorDescController,
                    keyboardType: TextInputType.multiline,
                    autofocus: false,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                        hintText: "Description",
                        prefixIcon: const Icon(Icons.description),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: const BorderSide(
                                width: 0, style: BorderStyle.none)),
                        filled: true,
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        fillColor: Colors.grey[300]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Amount',
                    style: TextStyle(
                        color: Constants.blackColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: amountMinController,
                    keyboardType: TextInputType.name,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                        hintText: "min",
                        prefixIcon: const Icon(Icons.numbers),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: const BorderSide(
                                width: 0, style: BorderStyle.none)),
                        filled: true,
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        fillColor: Colors.grey[300]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: amountMaxController,
                    keyboardType: TextInputType.name,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                        hintText: "max",
                        prefixIcon: const Icon(Icons.numbers),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: const BorderSide(
                                width: 0, style: BorderStyle.none)),
                        filled: true,
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        fillColor: Colors.grey[300]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      const Text(
                        'Select your Type:',
                        style: TextStyle(color: Constants.blackColor),
                      ),
                      DropdownButton(
                        // Initial Value
                        value: dropdownvalue,

                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),

                        // Array list of items
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(
                              items,
                              style:
                                  const TextStyle(color: Constants.blackColor),
                            ),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RoundedButton(
                      label: "Add",
                      onPressed: () {
                        if (investorNameController.text.isNotEmpty &&
                            investorDescController.text.isNotEmpty &&
                            amountMinController.text.isNotEmpty &&
                            amountMaxController.text.isNotEmpty) {
                          String name = investorNameController.text;
                          String desc = investorDescController.text;
                          List<double> amount = [
                            double.parse(amountMinController.text),
                            double.parse(amountMaxController.text)
                          ];
                          String type = dropdownvalue;
                          bool isChecked = false;
                          addInvestor(name, desc, amount, type, isChecked);
                        }
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  RoundedButton(
                    label: 'Close',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future addInvestor(String name, String desc, List amount, String type,
      bool isChecked) async {
    int? typeID = -1;

    if (type == 'Friends & Family') {
      typeID = 0;
    }
    if (type == 'Angel Investor') {
      typeID = 1;
    }
    if (type == 'Small Venture Capital') {
      typeID = 2;
    }

    CollectionReference investorsCollection =
        orgCollRef.doc(userId).collection('investors');

    await investorsCollection.add({
      'name': name,
      'description': desc,
      'amount': amount,
      'type': type,
      'typeID': typeID,
      'isChecked': isChecked
    });
  }
}

class InvestorsList extends StatefulWidget {
  const InvestorsList({Key? key}) : super(key: key);

  @override
  State<InvestorsList> createState() => _InvestorsListState();
}

class _InvestorsListState extends State<InvestorsList> {
  final CollectionReference _investorsCollection =
      orgCollRef.doc(userId).collection('investors');

  final TextEditingController investorNameController = TextEditingController();
  final TextEditingController investorDescController = TextEditingController();
  final TextEditingController amountMinController = TextEditingController();
  final TextEditingController amountMaxController = TextEditingController();

  // List of the Investor Type
  var items = [
    'Friends & Family',
    'Angel Investor',
    'Small Venture Capital',
  ];

  // Initial Selected Value
  String dropdownvalue = 'Friends & Family';

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      color: Constants.purpleLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: double.infinity,
        height: 800,
        decoration: const BoxDecoration(),
        child: StreamBuilder(
          stream: _investorsCollection.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  int selectedCount = streamSnapshot.data!.docs
                      .where((doc) =>
                          doc['type'] == documentSnapshot['type'] &&
                          doc['isChecked'])
                      .length;
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.all(5),
                    color: Constants.listileColor,
                    child: ListTile(
                      textColor: Constants.blackColor,
                      title: Row(
                        children: [
                          const Icon(Icons.person),
                          const Text('Name: '),
                          Text(documentSnapshot['name']),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          const Icon(Icons.account_tree),
                          const Text('Type: '),
                          Text(documentSnapshot['type']),
                        ],
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                color: Constants.blackColor,
                                icon: const Icon(Icons.edit),
                                onPressed: () => _update(documentSnapshot)),
                            IconButton(
                                color: Constants.blackColor,
                                icon: const Icon(Icons.delete),
                                onPressed: () => _delete(documentSnapshot.id)),
                          ],
                        ),
                      ),
                      leading: Checkbox(
                          checkColor: Constants.blackColor,
                          value: documentSnapshot['isChecked'],
                          onChanged: selectedCount < 3
                              ? (bool? value) {
                                  documentSnapshot.reference
                                      .update({'isChecked': value});
                                }
                              : null,
                          shape: const CircleBorder(),
                          fillColor:
                              MaterialStateProperty.resolveWith((Set states) {
                            if (states.contains(MaterialState.disabled)) {
                              return Colors.orange.withOpacity(.32);
                            }
                            return const Color(0xff06bbfb);
                          })),
                    ),
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      investorNameController.text = documentSnapshot['name'];
      investorDescController.text = documentSnapshot['description'];
      amountMinController.text = documentSnapshot['amount'][0].toString();
      amountMaxController.text = documentSnapshot['amount'][1].toString();
      dropdownvalue = documentSnapshot['type'];
    }

    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
          title: const Text('Update details'),
          content: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(child: Icon(Icons.edit_note, size: 120)),
                  Column(
                    children: [
                      TextField(
                        keyboardType: TextInputType.name,
                        controller: investorNameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                      ),
                      TextField(
                        keyboardType: TextInputType.multiline,
                        controller: investorDescController,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                      ),
                      TextField(
                        keyboardType: const TextInputType.numberWithOptions(),
                        controller: amountMinController,
                        decoration: const InputDecoration(
                          labelText: 'Amount Min',
                        ),
                      ),
                      TextField(
                        controller: amountMaxController,
                        keyboardType: const TextInputType.numberWithOptions(),
                        decoration: const InputDecoration(
                          labelText: 'Amount Max',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          const Text(
                            'Select your Type:',
                            style: TextStyle(color: Colors.black),
                          ),
                          DropdownButton(
                            // Initial Value
                            value: dropdownvalue,

                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down),

                            // Array list of items
                            items: items.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(
                                  items,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownvalue = newValue!;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          TextButton(
                            child: const Text('Update'),
                            onPressed: () async {
                              final String name = investorNameController.text;
                              final String desc = investorDescController.text;
                              List<double> amount = [
                                double.parse(amountMinController.text),
                                double.parse(amountMaxController.text)
                              ];
                              final String type = dropdownvalue;

                              int? typeID = -1;

                              if (type == 'Friends & Family') {
                                typeID = 0;
                              }
                              if (type == 'Angel Investor') {
                                typeID = 1;
                              }
                              if (type == 'Small Venture Capital') {
                                typeID = 2;
                              }

                              await _investorsCollection
                                  .doc(documentSnapshot!.id)
                                  .update({
                                "name": name,
                                "description": desc,
                                "amount": amount,
                                "type": type,
                                "typeID": typeID,
                                "isChecked": false
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                          const Spacer(),
                          TextButton(
                            child: const Text('Close'),
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Future<void> _delete(String investorId) async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete Investor?'),
        content: const Text('Are you sure you want to delete this Investor?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'No'),
            child: const Text('NO'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Yes');
              _investorsCollection.doc(investorId).delete();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('You have successfully deleted an Investor')));
            },
            child: const Text('YES'),
          ),
        ],
      ),
    );
  }
}

class MembersList extends StatefulWidget {
  const MembersList({Key? key}) : super(key: key);

  @override
  State<MembersList> createState() => _MembersListState();
}

class _MembersListState extends State<MembersList> {

  final Stream<QuerySnapshot> stream =
      orgCollRef.doc(userId).collection('users').snapshots();

  late Widget _usersList;


  @override
  void initState() {
    super.initState();
    _usersList = StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            DocumentSnapshot user = snapshot.data!.docs[index];

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.all(5),
              color: Constants.listileColor,
              child: ListTile(
                textColor: Constants.blackColor,
                title: Row(
                  children: const [
                    Icon(Icons.email),
                    Text('  Email:'),
                  ],
                ),
                subtitle: Text(user['email']),
                leading: Checkbox(
                  checkColor: Constants.blackColor,
                  value: user['isActive'],
                  onChanged: (bool? value) {
                    user.reference.update({'isActive': value});
                  },
                  shape: const CircleBorder(),
                  fillColor: MaterialStateProperty.resolveWith((Set states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.orange.withOpacity(.32);
                    }
                    return const Color(0xff06bbfb);
                  }),
                ),
                trailing: IconButton(
                    color: Constants.blackColor,
                    icon: const Icon(Icons.arrow_forward_ios_sharp),
                    onPressed: () {
                      setState(() {
                        _usersList = ConstrainedBox(
                            constraints: const BoxConstraints(),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.arrow_back_ios),
                                        onPressed: (){
                                          setState(() {
                                            Navigator.of(orgKey.currentContext!).push(
                                                MaterialPageRoute(
                                                    builder: (BuildContext context){
                                                      return const OrganizationScreen();
                                                    }
                                                )
                                            );
                                          });
                                        },
                                      ),
                                      const Text('Sessions List:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                      const Spacer(),
                                      const Text('Average:'),
                                      IconButton(
                                          icon: const Icon(Icons.bar_chart),
                                          onPressed: (){

                                            showDialog(
                                              context: orgKey.currentContext!,
                                              builder: (context) =>
                                                  AlertDialog(
                                                    backgroundColor:
                                                    Constants.purpleLight,
                                                    title: Row(
                                                      children: [
                                                        const Icon(Icons.list_alt,
                                                            size: 50),
                                                        const Text(
                                                          'Session Average:',
                                                          style: TextStyle(
                                                              color: Constants
                                                                  .blackColor,
                                                              fontSize: 50),
                                                        ),
                                                        const Spacer(),
                                                        IconButton(
                                                          icon: const Icon(
                                                              Icons.close),
                                                          color: Colors.red,
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                    content: SessionAverage(
                                                      userUID: user['uid']
                                                    ),
                                                  ),
                                            );
                                          }
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 730,
                                  child: FutureBuilder<QuerySnapshot>(
                                      future: usersCollRef
                                          .doc(user['uid'])
                                          .collection('sessions')
                                          .orderBy('SessionNum', descending: true)
                                          .get(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot> snapshot) {
                                        if (!snapshot.hasData) {
                                          return const Center(
                                              child: CircularProgressIndicator());
                                        }
                                        return ListView.builder(
                                            itemCount: snapshot.data!.docs.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              DocumentSnapshot session = snapshot.data!.docs[index];
                                              String sessionUID = snapshot.data!.docs[index].id;

                                              return Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(20),
                                                ),
                                                margin: const EdgeInsets.all(5),
                                                color: Constants.listileColor,
                                                child: ListTile(
                                                  textColor: Constants.blackColor,
                                                  title: Row(
                                                      children: [
                                                        const Text('Session N°: '),
                                                        Text(session['SessionNum'].toString()
                                                        ),
                                                      ]
                                                  ),
                                                  subtitle: Row(
                                                    children: [
                                                      const Text('Date: '),
                                                      Text(session['Date']),
                                                    ],
                                                  ),
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                            backgroundColor:
                                                            Constants.purpleLight,
                                                            title: Row(
                                                              children: [
                                                                const Icon(Icons.list_alt,
                                                                    size: 50),
                                                                const Text(
                                                                  'Session Details:',
                                                                  style: TextStyle(
                                                                      color: Constants
                                                                          .blackColor,
                                                                      fontSize: 50),
                                                                ),
                                                                const Spacer(),
                                                                IconButton(
                                                                  icon: const Icon(
                                                                      Icons.close),
                                                                  color: Colors.red,
                                                                  onPressed: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                )
                                                              ],
                                                            ),
                                                            content: SessionDetails(
                                                              sessionNum:
                                                              session['SessionNum']
                                                                  .toString(),
                                                              sessionDate:
                                                              session['Date'],
                                                              userUID: user['uid'],
                                                              sessionUID: sessionUID,
                                                            ),
                                                          ),
                                                    );
                                                  },
                                                ),
                                              );
                                            }
                                        );
                                      }),
                                )
                              ],
                            ),
                          );

                      });
                    }),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(10),
        color: Constants.purpleLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: double.infinity,
          height: 800,
          decoration: const BoxDecoration(),
          child: _usersList,
        )
    );
  }
}

class SessionDetails extends StatelessWidget {
  String sessionNum;
  String sessionDate;
  String userUID;
  String sessionUID;

  SessionDetails(
      {Key? key,
      required this.sessionNum,
      required this.sessionDate,
      required this.userUID,
      required this.sessionUID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Text('Session N°:  ',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4b66d9))),
              Text(sessionNum),
              const Spacer(),
              const Text('Date:  ',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4b66d9))),
              Text(sessionDate),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Card(
                  color: Constants.purpleDark,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SizedBox(
                      width: 500,
                      height: 500,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 10, right: 10, bottom: 10),
                          child: Column(
                            children: [
                              const Text(
                                "EMPLOYEES",
                                style: TextStyle(
                                  fontSize: 24.0,
                                  color: Color(0xFFdb3f4d),
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              StreamBuilder<QuerySnapshot>(
                                  stream: usersCollRef
                                      .doc(userUID)
                                      .collection('sessions')
                                      .doc(sessionUID)
                                      .collection('employees')
                                      .orderBy("Num", descending: true)
                                      .limit(1)
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    DocumentSnapshot employee =
                                        snapshot.data!.docs[0];
                                    Map Employees = employee['Employees'];
                                    Map EmployeesValue =
                                        employee['Employees\$'];
                                    Map EmployeesPercentage =
                                        employee['Employees%'];

                                    return Column(
                                      children: [
                                        Row(
                                          children: const [
                                            Text('               Infos:',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        Constants.smallTitles,
                                                    fontSize: 20)),
                                            Spacer(),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width: 150,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            10, 10, 10, 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        const Text(
                                                            'Co Founder: ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                          '${Employees['CoFounder']}',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: 150,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            10, 10, 10, 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        const Text(
                                                            'Family & Friends:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                          '${Employees['Family&Friends']}',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width: 150,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      shape:
                                                          BoxShape.rectangle),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            10, 10, 10, 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        const Text('Job Fair: ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                            '${Employees['JobFair']}'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: 150,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            10, 10, 10, 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        const Text(
                                                            'Job Listing:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                          '${Employees['JobListing']}',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: const [
                                            Text('                 Costs:',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        Constants.smallTitles,
                                                    fontSize: 18)),
                                            Spacer(),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width: 150,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            10, 10, 10, 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        const Text(
                                                            'Co Founder:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                            '\$${EmployeesValue['CoFounder']}'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: 150,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            10, 10, 10, 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        const Text(
                                                            'Family & Friends:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                          '\$${EmployeesValue['Family&Friends']}',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width: 150,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            10, 10, 10, 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        const Text('Job Fair:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                          '\$${EmployeesValue['JobFair']}',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: 150,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            10, 10, 10, 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        const Text(
                                                            'Job Listing:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                          '\$${EmployeesValue['JobListing']}',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: const [
                                            Text(
                                                '                 Percentages:',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        Constants.smallTitles,
                                                    fontSize: 18)),
                                            Spacer(),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width: 150,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            10, 10, 10, 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        const Text(
                                                            'Co Founder:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                          '%${EmployeesPercentage['CoFounder']}',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: 150,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            10, 10, 10, 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        const Text(
                                                            'Family & Friends:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                            '%${EmployeesPercentage['Family&Friends']}'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width: 150,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            10, 10, 10, 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        const Text('Job Fair:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                            '%${EmployeesPercentage['JobFair']}'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: 150,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            10, 10, 10, 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        const Text(
                                                            'Job Listing:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                            '%${EmployeesPercentage['JobListing']}'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                            'Total Employees: ${employee['Total']}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    );
                                  }
                              ),
                            ],
                          ),
                        ),
                      )
                  )
              ),
              Card(
                  color: Constants.purpleDark,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SizedBox(
                      width: 500,
                      height: 500,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 10, right: 10, bottom: 10),
                          child: Column(
                            children: [
                              const Text(
                                "BUSINESS",
                                style: TextStyle(
                                  fontSize: 24.0,
                                  color: Color(0xFFdb3f4d),
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              StreamBuilder<QuerySnapshot>(
                                  stream: usersCollRef
                                      .doc(userUID)
                                      .collection('sessions')
                                      .doc(sessionUID)
                                      .collection('business')
                                      .orderBy("Num", descending: true)
                                      .limit(1)
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    DocumentSnapshot business =
                                        snapshot.data!.docs[0];
                                    Map Notes = business['notes'];

                                    return Column(
                                      children: [
                                        Row(
                                          children: const [
                                            Text('Notes:',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        Constants.smallTitles,
                                                    fontSize: 18)),
                                            Spacer(),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width: 150,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            10, 10, 10, 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        const Text('Country:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                            '${Notes['country']}'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: 150,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            10, 10, 10, 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        const Text('Customer:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                            '${Notes['customer']}'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: 150,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            10, 10, 10, 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        const Text('Price:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                            '${Notes['price']}'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width: 150,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            10, 10, 10, 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        const Text('Product:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                            '${Notes['product']}'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: 150,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            10, 10, 10, 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        const Text('Sector:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                            '${Notes['sector']}'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: 150,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            10, 10, 10, 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        const Text(
                                                            'Technology:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                            '${Notes['technology']}'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const Text('Type:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Constants.smallTitles,
                                                fontSize: 18)),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ...Notes['type']
                                            .map((type) => Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Container(
                                                          width: 150,
                                                          height: 60,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            shape: BoxShape
                                                                .rectangle,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                    10,
                                                                    10,
                                                                    10,
                                                                    10),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Text(type,
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ))
                                            .toList(),
                                      ],
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ))),
              Card(
                  color: Constants.purpleDark,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SizedBox(
                      width: 500,
                      height: 500,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 10, right: 10, bottom: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "SERVICES",
                                style: TextStyle(
                                  fontSize: 24.0,
                                  color: Color(0xFFdb3f4d),
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              StreamBuilder<QuerySnapshot>(
                                  stream: usersCollRef
                                      .doc(userUID)
                                      .collection('sessions')
                                      .doc(sessionUID)
                                      .collection('services')
                                      .orderBy("Num", descending: true)
                                      .limit(1)
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    DocumentSnapshot service =
                                        snapshot.data!.docs[0];
                                    Map Service = service['Services'];
                                    Map ServiceValue = service['Services\$'];
                                    Map ServicePercentage =
                                        service['Services%'];

                                    return Column(
                                      children: [
                                        Row(
                                          children: const [
                                            Text('Infos:',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        Constants.smallTitles,
                                                    fontSize: 18)),
                                            Spacer(),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    width: 150,
                                                    height: 60,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      shape: BoxShape.rectangle,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                              10, 10, 10, 10),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          const Text(
                                                              'Accounting Services:',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          Text(
                                                              '${Service['AccountingServices']}'),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: 150,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            10, 10, 10, 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        const Text(
                                                            'Administration:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                            '${Service['Adminstration']}'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: 150,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            10, 10, 10, 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        const Text('HR:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                            '${Service['HR']}'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width: 150,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            10, 10, 10, 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        const Text(
                                                            'It Administration:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                            '${Service['ItAdminstration']}'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: 150,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            10, 10, 10, 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        const Text(
                                                            'It Dev Computer:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                            '${Service['ItDevComputer']}'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: const [
                                            Text('Costs:',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        Constants.smallTitles,
                                                    fontSize: 18)),
                                            Spacer(),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    width: 150,
                                                    height: 60,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      shape: BoxShape.rectangle,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                              10, 10, 10, 10),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          const Text(
                                                              'Accounting Services:',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          Text(
                                                              '\$${ServiceValue['AccountingServices']}'),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: 150,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            10, 10, 10, 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        const Text(
                                                            'Administration:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                            '\$${ServiceValue['Adminstration']}'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: 150,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            10, 10, 10, 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        const Text('HR:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                            '\$${ServiceValue['HR']}'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width: 150,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            10, 10, 10, 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        const Text(
                                                            'It Administration:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                            '\$${ServiceValue['ItAdminstration']}'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: 150,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            10, 10, 10, 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        const Text(
                                                            'It Dev Computer:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                            '\$${ServiceValue['ItDevComputer']}'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: const [
                                            Text('Percentages:',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        Constants.smallTitles,
                                                    fontSize: 18)),
                                            Spacer(),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    width: 150,
                                                    height: 60,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      shape: BoxShape.rectangle,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                              10, 10, 10, 10),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          const Text(
                                                              'Accounting Services:',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          Text(
                                                              '%${ServicePercentage['AccountingServices']}'),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: 150,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            10, 10, 10, 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        const Text(
                                                            'Administration:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                            '%${ServicePercentage['Adminstration']}'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: 150,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            10, 10, 10, 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        const Text('HR:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                            '%${ServicePercentage['HR']}'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width: 150,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            10, 10, 10, 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        const Text(
                                                            'It Administration:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                            '%${ServicePercentage['ItAdminstration']}'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: 150,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            10, 10, 10, 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        const Text(
                                                            'It Dev Computer:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                            '%${ServicePercentage['ItDevComputer']}'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    );
                                  })
                            ],
                          ),
                        ),
                      )
                  )
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                children: [
                  Card(
                      color: Constants.purpleDark,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SizedBox(
                        width: 500,
                        height: 245,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "TOTAL REVENUE",
                                style: TextStyle(
                                  fontSize: 24.0,
                                  color: Color(0xFFdb3f4d),
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              StreamBuilder<QuerySnapshot>(
                                  stream: usersCollRef
                                      .doc(userUID)
                                      .collection('sessions')
                                      .doc(sessionUID)
                                      .collection('totalRevenue')
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    DocumentSnapshot revenue =
                                        snapshot.data!.docs[0];
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          width: 150,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            shape: BoxShape.rectangle,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(10, 10, 10, 10),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                const Text('Total Months: ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  revenue['TotalMonths']
                                                      .toString(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Container(
                                          width: 150,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            shape: BoxShape.rectangle,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(10, 10, 10, 10),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                const Text('Total Revenue: ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  revenue['TotalRevenue']
                                                      .toString(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  })
                            ],
                          ),
                        ),
                      )
                  ),
                  Card(
                      color: Constants.purpleDark,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SizedBox(
                        width: 500,
                        height: 245,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "BREAK EVEN",
                                style: TextStyle(
                                  fontSize: 24.0,
                                  color: Color(0xFFdb3f4d),
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              StreamBuilder<QuerySnapshot>(
                                  stream: usersCollRef
                                      .doc(userUID)
                                      .collection('sessions')
                                      .doc(sessionUID)
                                      .collection('breakEven')
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    DocumentSnapshot breakeven =
                                        snapshot.data!.docs[0];
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                            child: Container(
                                          width: 150,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            shape: BoxShape.rectangle,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(10, 10, 10, 10),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                const Text(
                                                    'Money Recieved Before: ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  breakeven[
                                                          'MoneyRecievedBefore']
                                                      .toString(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                            child: Container(
                                          width: 150,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            shape: BoxShape.rectangle,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(10, 10, 10, 10),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                const Text(
                                                    'Months Before Break Even: ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  breakeven[
                                                          'MonthsBeforeBreakEven']
                                                      .toString(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                      ],
                                    );
                                  })
                            ],
                          ),
                        ),
                      )),
                ],
              ),
              Card(
                  color: Constants.purpleDark,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: 500,
                      height: 500,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "INVESTORS",
                              style: TextStyle(
                                fontSize: 24.0,
                                color: Color(0xFFdb3f4d),
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            StreamBuilder<QuerySnapshot>(
                                stream: usersCollRef
                                    .doc(userUID)
                                    .collection('sessions')
                                    .doc(sessionUID)
                                    .collection('investors')
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  return Card(
                                      margin: const EdgeInsets.all(10),
                                      color: Constants.purpleLight,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        height: 400,
                                        decoration: const BoxDecoration(),
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                                snapshot.data!.docs.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              DocumentSnapshot investor =
                                                  snapshot.data!.docs[index];
                                              return Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                margin: const EdgeInsets.all(5),
                                                color: Constants.listileColor,
                                                child: ListTile(
                                                  textColor:
                                                      Constants.blackColor,
                                                  title: Row(
                                                    children: [
                                                      const Icon(Icons.person),
                                                      const Text('Name: '),
                                                      Text(investor['Name'])
                                                    ],
                                                  ),
                                                  subtitle: Row(
                                                    children: [
                                                      const Icon(Icons.email),
                                                      const Text('Type: '),
                                                      Text(investor['Type'])
                                                    ],
                                                  ),
                                                  trailing: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Text(
                                                          'Money Invested',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(
                                                          '\$${investor['TotalInvested']}'),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                      ));
                                })
                          ],
                        ),
                      ),
                    ),
                  )
              ),
              Card(
                  color: Constants.purpleDark,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: 500,
                      height: 500,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: const [
                            Text(
                              "ACTIVITIES",
                              style: TextStyle(
                                fontSize: 24.0,
                                color: Color(0xFFdb3f4d),
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text('UNDER CONSTRUCTION'),
                          ],
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class SessionAverage extends StatelessWidget {
  SessionAverage({Key? key, required this.userUID}) : super(key: key);

  String userUID;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        children: [
          Card(
              color: Constants.purpleDark,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: SizedBox(
                  width: 500,
                  height: 600,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
                      child: Column(
                        children: [
                          const Text("EMPLOYEES",
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Color(0xFFdb3f4d),
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: [
                              Row(
                                children: const [
                                  Text('               Infos:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                          Constants.smallTitles,
                                          fontSize: 20)),
                                  Spacer(),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: 150,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(
                                              10),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsetsDirectional
                                              .fromSTEB(
                                              10, 10, 10, 10),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            mainAxisSize:
                                            MainAxisSize.max,
                                            children: [
                                              const Text(
                                                  'Co Founder: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold)),
                                              Text(
                                                avgEmplCoFounder.toStringAsFixed(2),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 150,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(
                                              10),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsetsDirectional
                                              .fromSTEB(
                                              10, 10, 10, 10),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            mainAxisSize:
                                            MainAxisSize.max,
                                            children: [
                                              const Text(
                                                  'Family & Friends:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold)),
                                              Text(
                                                avgEmplFamilyFriends.toStringAsFixed(2),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: 150,
                                        height: 60,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(
                                                10),
                                            shape:
                                            BoxShape.rectangle),
                                        child: Padding(
                                          padding:
                                          const EdgeInsetsDirectional
                                              .fromSTEB(
                                              10, 10, 10, 10),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            mainAxisSize:
                                            MainAxisSize.max,
                                            children: [
                                              const Text('Job Fair: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold)),
                                              Text(
                                                avgEmplJobFair.toStringAsFixed(2),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 150,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(
                                              10),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsetsDirectional
                                              .fromSTEB(
                                              10, 10, 10, 10),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            mainAxisSize:
                                            MainAxisSize.max,
                                            children: [
                                              const Text(
                                                  'Job Listing:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold)),
                                              Text(
                                                avgEmplJobListing.toStringAsFixed(2),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: const [
                                  Text('                 Costs:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                          Constants.smallTitles,
                                          fontSize: 18)),
                                  Spacer(),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: 150,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(
                                              10),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsetsDirectional
                                              .fromSTEB(
                                              10, 10, 10, 10),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            mainAxisSize:
                                            MainAxisSize.max,
                                            children: [
                                              const Text(
                                                  'Co Founder:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold)),
                                              Text(
                                                  avgEmplCostCoFounder.toStringAsFixed(2)
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 150,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(
                                              10),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsetsDirectional
                                              .fromSTEB(
                                              10, 10, 10, 10),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            mainAxisSize:
                                            MainAxisSize.max,
                                            children: [
                                              const Text(
                                                  'Family & Friends:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold)),
                                              Text(
                                                avgEmplCostFamilyFriends.toStringAsFixed(2),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: 150,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(
                                              10),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsetsDirectional
                                              .fromSTEB(
                                              10, 10, 10, 10),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            mainAxisSize:
                                            MainAxisSize.max,
                                            children: [
                                              const Text('Job Fair:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold)),
                                              Text(
                                                avgEmplCostJobFair.toStringAsFixed(2),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 150,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(
                                              10),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsetsDirectional
                                              .fromSTEB(
                                              10, 10, 10, 10),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            mainAxisSize:
                                            MainAxisSize.max,
                                            children: [
                                              const Text(
                                                  'Job Listing:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold)),
                                              Text(
                                                avgEmplCostJobListing.toStringAsFixed(2),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: const [
                                  Text(
                                      '                 Percentages:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                          Constants.smallTitles,
                                          fontSize: 18)),
                                  Spacer(),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: 150,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(
                                              10),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsetsDirectional
                                              .fromSTEB(
                                              10, 10, 10, 10),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            mainAxisSize:
                                            MainAxisSize.max,
                                            children: [
                                              const Text(
                                                  'Co Founder:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold)),
                                              Text(
                                                avgEmplPercCoFounder.toStringAsFixed(2),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 150,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(
                                              10),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsetsDirectional
                                              .fromSTEB(
                                              10, 10, 10, 10),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            mainAxisSize:
                                            MainAxisSize.max,
                                            children: [
                                              const Text(
                                                  'Family & Friends:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold)),
                                              Text(
                                                  avgEmplPercFamilyFriends.toStringAsFixed(2)
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: 150,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(
                                              10),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsetsDirectional
                                              .fromSTEB(
                                              10, 10, 10, 10),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            mainAxisSize:
                                            MainAxisSize.max,
                                            children: [
                                              const Text('Job Fair:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold)),
                                              Text(
                                                  avgEmplPercJobFair.toStringAsFixed(2)
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 150,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(
                                              10),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsetsDirectional
                                              .fromSTEB(
                                              10, 10, 10, 10),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            mainAxisSize:
                                            MainAxisSize.max,
                                            children: [
                                              const Text(
                                                  'Job Listing:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold)),
                                              Text(
                                                  avgEmplPercJobListing.toStringAsFixed(2)
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
              )
          ),
          Card(
              color: Constants.purpleDark,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: SizedBox(
                  width: 500,
                  height: 600,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 10, right: 10, bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "SERVICES",
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Color(0xFFdb3f4d),
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: [
                              Row(
                                children: const [
                                  Text('Infos:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                          Constants.smallTitles,
                                          fontSize: 18)),
                                  Spacer(),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width: 150,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(
                                                10),
                                            shape: BoxShape.rectangle,
                                          ),
                                          child: Padding(
                                            padding:
                                            const EdgeInsetsDirectional
                                                .fromSTEB(
                                                10, 10, 10, 10),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                              mainAxisSize:
                                              MainAxisSize.max,
                                              children: [
                                                const Text(
                                                    'Accounting Services:',
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold)),
                                                Text(
                                                    avgServAccountingServices.toStringAsFixed(2)
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 150,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(
                                              10),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsetsDirectional
                                              .fromSTEB(
                                              10, 10, 10, 10),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            mainAxisSize:
                                            MainAxisSize.max,
                                            children: [
                                              const Text(
                                                  'Administration:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold)),
                                              Text(
                                                  avgServAdminstration.toStringAsFixed(2)
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 150,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(
                                              10),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsetsDirectional
                                              .fromSTEB(
                                              10, 10, 10, 10),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            mainAxisSize:
                                            MainAxisSize.max,
                                            children: [
                                              const Text('HR:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold)),
                                              Text(
                                                  avgServHR.toStringAsFixed(2)
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: 150,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(
                                              10),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsetsDirectional
                                              .fromSTEB(
                                              10, 10, 10, 10),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            mainAxisSize:
                                            MainAxisSize.max,
                                            children: [
                                              const Text(
                                                  'It Administration:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold)),
                                              Text(
                                                  avgServItAdminstration.toStringAsFixed(2)
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 150,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(
                                              10),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsetsDirectional
                                              .fromSTEB(
                                              10, 10, 10, 10),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            mainAxisSize:
                                            MainAxisSize.max,
                                            children: [
                                              const Text(
                                                  'It Dev Computer:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold)),
                                              Text(
                                                  avgServItDevComputer.toStringAsFixed(2)
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: const [
                                  Text('Costs:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                          Constants.smallTitles,
                                          fontSize: 18)),
                                  Spacer(),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width: 150,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(
                                                10),
                                            shape: BoxShape.rectangle,
                                          ),
                                          child: Padding(
                                            padding:
                                            const EdgeInsetsDirectional
                                                .fromSTEB(
                                                10, 10, 10, 10),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                              mainAxisSize:
                                              MainAxisSize.max,
                                              children: [
                                                const Text(
                                                    'Accounting Services:',
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold)),
                                                Text(
                                                    avgServCostAccountingServices.toStringAsFixed(2)
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 150,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(
                                              10),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsetsDirectional
                                              .fromSTEB(
                                              10, 10, 10, 10),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            mainAxisSize:
                                            MainAxisSize.max,
                                            children: [
                                              const Text(
                                                  'Administration:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold)),
                                              Text(
                                                  avgServCostAdminstration.toStringAsFixed(2)
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 150,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(
                                              10),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsetsDirectional
                                              .fromSTEB(
                                              10, 10, 10, 10),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            mainAxisSize:
                                            MainAxisSize.max,
                                            children: [
                                              const Text('HR:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold)),
                                              Text(
                                                  avgServCostHR.toStringAsFixed(2)
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: 150,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(
                                              10),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsetsDirectional
                                              .fromSTEB(
                                              10, 10, 10, 10),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            mainAxisSize:
                                            MainAxisSize.max,
                                            children: [
                                              const Text(
                                                  'It Administration:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold)),
                                              Text(
                                                  avgServCostItAdminstration.toStringAsFixed(2)
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 150,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(
                                              10),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsetsDirectional
                                              .fromSTEB(
                                              10, 10, 10, 10),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            mainAxisSize:
                                            MainAxisSize.max,
                                            children: [
                                              const Text(
                                                  'It Dev Computer:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold)),
                                              Text(
                                                  avgServCostItDevComputer.toStringAsFixed(2)
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: const [
                                  Text('Percentages:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                          Constants.smallTitles,
                                          fontSize: 18)),
                                  Spacer(),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width: 150,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(
                                                10),
                                            shape: BoxShape.rectangle,
                                          ),
                                          child: Padding(
                                            padding:
                                            const EdgeInsetsDirectional
                                                .fromSTEB(
                                                10, 10, 10, 10),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                              mainAxisSize:
                                              MainAxisSize.max,
                                              children: [
                                                const Text(
                                                    'Accounting Services:',
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold)),
                                                Text(
                                                    avgServPercAccountingServices.toStringAsFixed(2)
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 150,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(
                                              10),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsetsDirectional
                                              .fromSTEB(
                                              10, 10, 10, 10),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            mainAxisSize:
                                            MainAxisSize.max,
                                            children: [
                                              const Text(
                                                  'Administration:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold)),
                                              Text(
                                                  avgServPercAdminstration.toStringAsFixed(2)
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 150,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(
                                              10),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsetsDirectional
                                              .fromSTEB(
                                              10, 10, 10, 10),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            mainAxisSize:
                                            MainAxisSize.max,
                                            children: [
                                              const Text('HR:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold)),
                                              Text(
                                                  avgServPercHR.toStringAsFixed(2)
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: 150,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(
                                              10),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsetsDirectional
                                              .fromSTEB(
                                              10, 10, 10, 10),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            mainAxisSize:
                                            MainAxisSize.max,
                                            children: [
                                              const Text(
                                                  'It Administration:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold)),
                                              Text(
                                                  avgServPercItAdminstration.toStringAsFixed(2)
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 150,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(
                                              10),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsetsDirectional
                                              .fromSTEB(
                                              10, 10, 10, 10),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            mainAxisSize:
                                            MainAxisSize.max,
                                            children: [
                                              const Text(
                                                  'It Dev Computer:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold)),
                                              Text(
                                                  avgServPercItDevComputer.toStringAsFixed(2)
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
              )
          ),
          Column(
            children: [
              Card(
                  color: Constants.purpleDark,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SizedBox(
                    width: 500,
                    height: 245,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "TOTAL REVENUE",
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Color(0xFFdb3f4d),
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  shape: BoxShape.rectangle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional
                                      .fromSTEB(10, 10, 10, 10),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Text('Total Months: ',
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold)),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                          avgTrMonths.toStringAsFixed(2)
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  shape: BoxShape.rectangle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional
                                      .fromSTEB(10, 10, 10, 10),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Text('Total Revenue: ',
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold)),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                          avgTrRevenue.toStringAsFixed(2)
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
              ),
              Card(
                  color: Constants.purpleDark,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SizedBox(
                    width: 500,
                    height: 245,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "BREAK EVEN",
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Color(0xFFdb3f4d),
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                  child: Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      shape: BoxShape.rectangle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional
                                          .fromSTEB(10, 10, 10, 10),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          const Text(
                                              'Money Recieved Before: ',
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold)),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                              avgBeMoney.toStringAsFixed(2)
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                  child: Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      shape: BoxShape.rectangle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional
                                          .fromSTEB(10, 10, 10, 10),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          const Text(
                                              'Months Before Break Even: ',
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold)),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                              avgBeMonths.toStringAsFixed(2)
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void ResetAll() {

  emplFamilyFriends = 0;
  avgEmplFamilyFriends = 0.0;

  emplCoFounder = 0;
  avgEmplCoFounder = 0.0;

  emplJobFair = 0;
  avgEmplJobFair = 0.0;

  emplJobListing = 0;
  avgEmplJobListing = 0.0;

  emplCostCoFounder = 0;
  avgEmplCostCoFounder = 0.0;

  emplCostFamilyFriends = 0;
  avgEmplCostFamilyFriends = 0.0;

  emplCostJobFair = 0;
  avgEmplCostJobFair = 0.0;

  emplCostJobListing = 0;
  avgEmplCostJobListing = 0.0;

  emplPercCoFounder = 0;
  avgEmplPercCoFounder = 0.0;

  emplPercFamilyFriends = 0;
  avgEmplPercFamilyFriends = 0.0;

  emplPercJobFair = 0;
  avgEmplPercJobFair = 0.0;

  emplPercJobListing = 0;
  avgEmplPercJobListing = 0.0;
}

void LoopThroughSessions(userUID) async{
  ResetAll();
  QuerySnapshot sessionsQuerySnapshot = await usersCollRef
      .doc(userUID)
      .collection('sessions')
      .get();

  if (sessionsQuerySnapshot.docs.isEmpty) {
    print('No sessions found.');
    return;
  }

  for (QueryDocumentSnapshot session in sessionsQuerySnapshot.docs) {
    String sessionUID = session.id;
    ShowEmplData(userUID, sessionUID, sessionsQuerySnapshot.size);
    ShowServiceData(userUID, sessionUID, sessionsQuerySnapshot.size);
    ShowTotalRevenueData(userUID, sessionUID, sessionsQuerySnapshot.size);
    ShowBreakEvenData(userUID, sessionUID, sessionsQuerySnapshot.size);
    ShowInvestorsData(userUID, sessionUID, sessionsQuerySnapshot.size);

  }
}

void ShowEmplData(String userUID, String sessionUID, int SessionsNumber) async{
  try {
    QuerySnapshot querySnapshot = await usersCollRef
        .doc(userUID)
        .collection('sessions')
        .doc(sessionUID)
        .collection('employees')
        .orderBy("Num", descending: true)
        .limit(1)
        .get();
    if (querySnapshot.size == 0) {
      // No data found
      return;
    }

    QueryDocumentSnapshot lastEmployeeDoc = querySnapshot.docs.first;
    Map<String, dynamic> lastEmployeeData = lastEmployeeDoc.data() as Map<String, dynamic>;

    CalculEmplAvg('Employees', 'CoFounder', SessionsNumber, lastEmployeeData);
    CalculEmplAvg('Employees', 'Family&Friends', SessionsNumber, lastEmployeeData);
    CalculEmplAvg('Employees', 'JobFair', SessionsNumber, lastEmployeeData);
    CalculEmplAvg('Employees', 'JobListing', SessionsNumber, lastEmployeeData);
    CalculEmplAvg('Employees\$', 'CoFounder', SessionsNumber, lastEmployeeData);
    CalculEmplAvg('Employees\$', 'Family&Friends', SessionsNumber, lastEmployeeData);
    CalculEmplAvg('Employees\$', 'JobFair', SessionsNumber, lastEmployeeData);
    CalculEmplAvg('Employees\$', 'JobListing', SessionsNumber, lastEmployeeData);
    CalculEmplAvg('Employees%', 'CoFounder', SessionsNumber, lastEmployeeData);
    CalculEmplAvg('Employees%', 'Family&Friends', SessionsNumber, lastEmployeeData);
    CalculEmplAvg('Employees%', 'JobFair', SessionsNumber, lastEmployeeData);
    CalculEmplAvg('Employees%', 'JobListing', SessionsNumber, lastEmployeeData);

  } catch (e) {
    print('Error: $e');
  }
}

void CalculEmplAvg (String Field, String Value, int SessionsNumber, Map<String, dynamic> lastEmployeeData) {
  int lastEmployeeTotal = lastEmployeeData[Field][Value];

  if(SessionsNumber > 0) {
    switch (Field) {
      case 'Employees': {
        switch (Value) {
          case 'CoFounder': {
            emplCoFounder+=lastEmployeeTotal;
            avgEmplCoFounder = (emplCoFounder/SessionsNumber);
          }
          break;
          case 'Family&Friends': {
            emplFamilyFriends+=lastEmployeeTotal;
            avgEmplFamilyFriends = (emplFamilyFriends/SessionsNumber);
          }
          break;
          case 'JobFair': {
            emplJobFair+=lastEmployeeTotal;
            avgEmplJobFair = (emplJobFair/SessionsNumber);
          }
          break;
          case 'JobListing': {
            emplJobListing+=lastEmployeeTotal;
            avgEmplJobListing = (emplJobListing/SessionsNumber);
          }
          break;
        }
        break;
      }
      case 'Employees\$': {
        switch (Value) {
          case 'CoFounder': {
            emplCostCoFounder+=lastEmployeeTotal;
            avgEmplCostCoFounder = (emplCostCoFounder/SessionsNumber);
          }
          break;
          case 'Family&Friends': {
            emplCostFamilyFriends+=lastEmployeeTotal;
            avgEmplCostFamilyFriends = (emplCostFamilyFriends/SessionsNumber);
          }
          break;
          case 'JobFair': {
            emplCostJobFair+=lastEmployeeTotal;
            avgEmplCostJobFair = (emplCostJobFair/SessionsNumber);
          }
          break;
          case 'JobListing': {
            emplCostJobListing+=lastEmployeeTotal;
            avgEmplCostJobListing = (emplCostJobListing/SessionsNumber);
          }
          break;
        }
        break;
      }
      case 'Employees%': {
        switch (Value) {
          case 'CoFounder': {
            emplPercCoFounder+=lastEmployeeTotal;
            avgEmplPercCoFounder = (emplPercCoFounder/SessionsNumber);
          }
          break;
          case 'Family&Friends': {
            emplPercFamilyFriends+=lastEmployeeTotal;
            avgEmplPercFamilyFriends = (emplPercFamilyFriends/SessionsNumber);
          }
          break;
          case 'JobFair': {
            emplPercJobFair+=lastEmployeeTotal;
            avgEmplPercJobFair = (emplPercJobFair/SessionsNumber);
          }
          break;
          case 'JobListing': {
            emplPercJobListing+=lastEmployeeTotal;
            avgEmplPercJobListing = (emplPercJobListing/SessionsNumber);
          }
          break;
        }
        break;
      }
    }
  }

}

void ShowServiceData(String userUID, String sessionUID, int SessionsNumber) async{
  try {
    QuerySnapshot querySnapshot = await usersCollRef
        .doc(userUID)
        .collection('sessions')
        .doc(sessionUID)
        .collection('services')
        .orderBy("Num", descending: true)
        .limit(1)
        .get();
    if (querySnapshot.size == 0) {
      // No data found
      return;
    }

    QueryDocumentSnapshot ServicesDoc = querySnapshot.docs.first;
    Map<String, dynamic> ServiceData = ServicesDoc.data() as Map<String, dynamic>;

    CalculServiceAvg('Services', 'AccountingServices', SessionsNumber, ServiceData);
    CalculServiceAvg('Services', 'Adminstration', SessionsNumber, ServiceData);
    CalculServiceAvg('Services', 'HR', SessionsNumber, ServiceData);
    CalculServiceAvg('Services', 'ItAdminstration', SessionsNumber, ServiceData);
    CalculServiceAvg('Services', 'ItDevComputer', SessionsNumber, ServiceData);
    CalculServiceAvg('Services\$', 'AccountingServices', SessionsNumber, ServiceData);
    CalculServiceAvg('Services\$', 'Adminstration', SessionsNumber, ServiceData);
    CalculServiceAvg('Services\$', 'HR', SessionsNumber, ServiceData);
    CalculServiceAvg('Services\$', 'ItAdminstration', SessionsNumber, ServiceData);
    CalculServiceAvg('Services\$', 'ItDevComputer', SessionsNumber, ServiceData);
    CalculServiceAvg('Services%', 'AccountingServices', SessionsNumber, ServiceData);
    CalculServiceAvg('Services%', 'Adminstration', SessionsNumber, ServiceData);
    CalculServiceAvg('Services%', 'HR', SessionsNumber, ServiceData);
    CalculServiceAvg('Services%', 'ItAdminstration', SessionsNumber, ServiceData);
    CalculServiceAvg('Services%', 'ItDevComputer', SessionsNumber, ServiceData);

  } catch (e) {
    print('Error: $e');
  }
}

void CalculServiceAvg (String Field, String Value, int SessionsNumber, Map<String, dynamic> ServiceData) {
  int ServiceTotal = ServiceData[Field][Value];

  if(SessionsNumber > 0) {
    switch (Field) {
      case 'Services': {
        switch (Value) {
          case 'AccountingServices': {
            servAccountingServices+=ServiceTotal;
            avgServAccountingServices = (servAccountingServices/SessionsNumber);
          }
          break;
          case 'Adminstration': {
            servAdminstration+=ServiceTotal;
            avgServAdminstration = (servAdminstration/SessionsNumber);
          }
          break;
          case 'HR': {
            servHR+=ServiceTotal;
            avgServHR = (servHR/SessionsNumber);
          }
          break;
          case 'ItAdminstration': {
            servItAdminstration+=ServiceTotal;
            avgServItAdminstration = (servItAdminstration/SessionsNumber);
          }
          break;
          case 'ItDevComputer': {
            servItDevComputer+=ServiceTotal;
            avgServItDevComputer = (servItDevComputer/SessionsNumber);
          }
          break;
        }
        break;
      }
      case 'Services\$': {
        switch (Value) {
          case 'AccountingServices': {
            servCostAccountingServices+=ServiceTotal;
            avgServCostAccountingServices = (servCostAccountingServices/SessionsNumber);
          }
          break;
          case 'Adminstration': {
            servCostAdminstration+=ServiceTotal;
            avgServCostAdminstration = (servCostAdminstration/SessionsNumber);
          }
          break;
          case 'HR': {
            servCostHR+=ServiceTotal;
            avgServCostHR = (servCostHR/SessionsNumber);
          }
          break;
          case 'ItAdminstration': {
            servCostItAdminstration+=ServiceTotal;
            avgServCostItAdminstration = (servCostItAdminstration/SessionsNumber);
          }
          break;
          case 'ItDevComputer': {
            servItDevComputer+=ServiceTotal;
            avgServItDevComputer = (servItDevComputer/SessionsNumber);
          }
          break;
        }
        break;
      }
      case 'Services%': {
        switch (Value) {
          case 'AccountingServices': {
            servPercAccountingServices+=ServiceTotal;
            avgServPercAccountingServices = (servPercAccountingServices/SessionsNumber);
          }
          break;
          case 'Adminstration': {
            servPercAdminstration+=ServiceTotal;
            avgServPercAdminstration = (servPercAdminstration/SessionsNumber);
          }
          break;
          case 'HR': {
            servPercHR+=ServiceTotal;
            avgServPercHR = (servPercHR/SessionsNumber);
          }
          break;
          case 'ItAdminstration': {
            servPercItAdminstration+=ServiceTotal;
            avgServPercItAdminstration = (servPercItAdminstration/SessionsNumber);
          }
          break;
          case 'ItDevComputer': {
            servPercItDevComputer+=ServiceTotal;
            avgServPercItDevComputer = (servPercItDevComputer/SessionsNumber);
          }
          break;
        }
        break;
      }
    }
  }

}

void ShowTotalRevenueData(String userUID, String sessionUID, int SessionsNumber) async{
  try {
    QuerySnapshot querySnapshot = await usersCollRef
        .doc(userUID)
        .collection('sessions')
        .doc(sessionUID)
        .collection('totalRevenue')
        .get();
    if (querySnapshot.size == 0) {
      // No data found
      return;
    }

    QueryDocumentSnapshot totalRevenueDoc = querySnapshot.docs.first;
    Map<String, dynamic> TotalRevenueData = totalRevenueDoc.data() as Map<String, dynamic>;

    CalculTotalRevenueAvg('TotalRevenue', SessionsNumber, TotalRevenueData);
    CalculTotalRevenueAvg('TotalMonths', SessionsNumber, TotalRevenueData);

  } catch (e) {
    print('Error: $e');
  }
}

void CalculTotalRevenueAvg (String totalrevenue, int SessionsNumber, Map<String, dynamic> TotalRevenueData) {

  int TotalRevenueTotal = TotalRevenueData[totalrevenue];

  if(SessionsNumber > 0) {
    switch (totalrevenue) {
      case 'TotalRevenue': {
        trRevenue+=TotalRevenueTotal;
        avgTrRevenue = (trRevenue/SessionsNumber);
      }
      break;
      case 'TotalMonths': {
        trMonths+=TotalRevenueTotal;
        avgTrMonths = (trMonths/SessionsNumber);
      }
      break;
    }
  }

}

void ShowBreakEvenData(String userUID, String sessionUID, int SessionsNumber) async{
  try {
    QuerySnapshot querySnapshot = await usersCollRef
        .doc(userUID)
        .collection('sessions')
        .doc(sessionUID)
        .collection('breakEven')
        .get();
    if (querySnapshot.size == 0) {
      // No data found
      return;
    }

    QueryDocumentSnapshot breakEvenDoc = querySnapshot.docs.first;
    Map<String, dynamic> BreakEvenData = breakEvenDoc.data() as Map<String, dynamic>;

    CalculBreakEvenAvg('MoneyRecievedBefore', SessionsNumber, BreakEvenData);
    CalculBreakEvenAvg('MonthsBeforeBreakEven', SessionsNumber, BreakEvenData);

  } catch (e) {
    print('Error: $e');
  }
}

void CalculBreakEvenAvg (String breakeven, int SessionsNumber, Map<String, dynamic> BreakEvenData) {

  int BreakEvenTotal = BreakEvenData[breakeven];

  if(SessionsNumber > 0) {
    switch (breakeven) {
      case 'MoneyRecievedBefore': {
        beMoney+=BreakEvenTotal;
        avgBeMoney = (beMoney/SessionsNumber);
      }
      break;
      case 'MonthsBeforeBreakEven': {
        beMonths+=BreakEvenTotal;
        avgBeMonths = (beMonths/SessionsNumber);
      }
      break;
    }
  }

}

void ShowInvestorsData(String userUID, String sessionUID, int SessionsNumber) async{
  try {
    QuerySnapshot querySnapshot = await usersCollRef
        .doc(userUID)
        .collection('sessions')
        .doc(sessionUID)
        .collection('investors')
        .orderBy("Num", descending: true)
        .limit(1)
        .get();
    if (querySnapshot.size == 0) {
      // No data found
      return;
    }

    QueryDocumentSnapshot investorsDoc = querySnapshot.docs.first;
    Map<String, dynamic> InvestorsData = investorsDoc.data() as Map<String, dynamic>;

    int InvestorsTotal = InvestorsData['TotalInvested'];

    investors+=InvestorsTotal;
    avgInvestors = (investors/SessionsNumber);

  } catch (e) {
    print('Error: $e');
  }
}

void LoopThroughUsers() async{
  ResetAll();
  QuerySnapshot usersQuerySnapshot = await orgCollRef.doc(userId).collection('users').get();

  if (usersQuerySnapshot.docs.isEmpty) {
    print('No user found.');
    return;
  }

  for (QueryDocumentSnapshot user in usersQuerySnapshot.docs) {
    String userUID = user.id;
    LoopThroughSessions(userUID);

  }
}