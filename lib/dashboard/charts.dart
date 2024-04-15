import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../../constants.dart';

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = Colors.white70,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}

class InvestorsList extends StatefulWidget {
  const InvestorsList({Key? key}) : super(key: key);
  @override
  State<InvestorsList> createState() => _InvestorsListState();
}

class _InvestorsListState extends State<InvestorsList> {
  final TextEditingController investorNameController = TextEditingController();
  final TextEditingController investorDescController = TextEditingController();
  final TextEditingController amountMinController = TextEditingController();
  final TextEditingController amountMaxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      color: Constants.purpleLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          width: double.infinity,
          height: 400,
          decoration: const BoxDecoration(),
          child: StreamBuilder<QuerySnapshot>(
            stream: orgCollRef.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              // Loop through all documents in the "organizations" collection
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var organization = snapshot.data!.docs[index];

                  // Get the "tasks" subcollection for the current organization
                  var investorsCollection =
                      organization.reference.collection('investors');

                  return StreamBuilder<QuerySnapshot>(
                    stream: investorsCollection.snapshots(),
                    builder: (context, subsnapshot) {
                      if (!subsnapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.account_balance_rounded,
                                      size: 40),
                                  Row(
                                    children: [
                                      const Text('Organization: ',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Text(organization['name'],
                                          style: const TextStyle(fontSize: 18)),
                                    ],
                                  ),
                                ],
                              ), // Dis
                              ...subsnapshot.data!.docs.map(
                                (investor) => Card(
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
                                        Text(investor['name']),
                                      ],
                                    ),
                                    subtitle: Row(
                                      children: [
                                        const Icon(Icons.account_tree),
                                        const Text('Type: '),
                                        Text(investor['type']),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class CountryTable extends StatefulWidget {
  const CountryTable({Key? key}) : super(key: key);

  @override
  State<CountryTable> createState() => _CountryTableState();
}

class _CountryTableState extends State<CountryTable> {
  final CollectionReference _Countries = countriesCollRef;

  String _searchTerm = '';

  int? sortColumnIndex;
  bool isAscending = false;

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
        height: 350,
        decoration: const BoxDecoration(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  color: Constants.purpleDark,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchTerm = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(color: Constants.blackColor),
                    hintText: 'Search for a country',
                    suffixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(20),
                  ),
                  style: const TextStyle(color: Constants.blackColor),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _Countries.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  var data = snapshot.data!.docs
                      .where((document) => document['name']
                          .toLowerCase()
                          .contains(_searchTerm.toLowerCase()))
                      .toList();

                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      sortColumnIndex:
                          sortColumnIndex, // specify the column to be sorted
                      sortAscending: isAscending, // specify the sort order
                      columns: [
                        DataColumn(
                          label: const Text('Country',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Constants.blackColor)),
                          onSort: (int columnIndex, bool ascending) {
                            setState(() {
                              sortColumnIndex = columnIndex;
                              isAscending = ascending;

                              print('test');
                            });
                          },
                        ),
                        DataColumn(
                          label: const Text('Total Users',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Constants.blackColor)),
                          onSort: (int columnIndex, bool ascending) {
                            setState(() {
                              sortColumnIndex = columnIndex;
                              isAscending = ascending;

                              print('test');
                            });
                          },
                        ),
                      ],
                      rows: data.map((document) {
                        return DataRow(
                          cells: [
                            DataCell(Text(document['name'],
                                style: const TextStyle(
                                    color: Constants.blackColor))),
                            DataCell(Text(document['users'].length.toString(),
                                style: const TextStyle(
                                    color: Constants.blackColor))),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class GenderPieChart extends StatefulWidget {
  const GenderPieChart({Key? key}) : super(key: key);

  @override
  State<GenderPieChart> createState() => _GenderPieChartState();
}

class _GenderPieChartState extends State<GenderPieChart> {
  int touchedIndex = -1;

  CollectionReference usersCollection = usersCollRef;

  // Map to store the gender data for the pie chart
  Map<String, double> genderData = {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: Constants.kPadding / 2,
          bottom: Constants.kPadding,
          right: Constants.kPadding / 2),
      child: Card(
        color: Constants.purpleLight,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: <Widget>[
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: AspectRatio(
                  aspectRatio: 1,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: usersCollection.snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Text('Loading...');
                        }

                        // Clear the gender data
                        genderData.clear();

                        // Iterate over the documents and count the number of each gender
                        int numMales = 0;
                        int numFemales = 0;
                        int numOthers = 0;
                        for (DocumentSnapshot document in snapshot.data!.docs) {
                          if (document['gender'] == 'male') {
                            numMales++;
                          } else if (document['gender'] == 'female') {
                            numFemales++;
                          } else {
                            numOthers++;
                          }
                        }

                        // Calculate the percentages and add them to the gender data
                        double malePercentage =
                            (numMales / snapshot.data!.docs.length) * 100;
                        double femalePercentage =
                            (numFemales / snapshot.data!.docs.length) * 100;
                        double otherPercentage =
                            (numOthers / snapshot.data!.docs.length) * 100;

                        genderData['Males'] = malePercentage;
                        genderData['Females'] = femalePercentage;
                        genderData['Others'] = otherPercentage;

                        int mPercentage = malePercentage.toInt();
                        int fPercentage = femalePercentage.toInt();
                        int oPercentage = otherPercentage.toInt();

                        return PieChart(
                          PieChartData(
                            pieTouchData:
                                PieTouchData(touchCallback: (pieTouchResponse) {
                              setState(() {
                                final desiredTouch = pieTouchResponse.touchInput
                                        is! PointerExitEvent &&
                                    pieTouchResponse.touchInput
                                        is! PointerUpEvent;
                                if (desiredTouch &&
                                    pieTouchResponse.touchedSection != null) {
                                  touchedIndex = pieTouchResponse
                                      .touchedSection!.touchedSectionIndex;
                                } else {
                                  touchedIndex = -1;
                                }
                              });
                            }),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 0,
                            centerSpaceRadius: 40,
                            sections: List.generate(3, (i) {
                              final isTouched = i == touchedIndex;
                              final fontSize = isTouched ? 25.0 : 16.0;
                              final radius = isTouched ? 60.0 : 50.0;
                              switch (i) {
                                case 0:
                                  return PieChartSectionData(
                                    color: const Color(0xff0293ee),
                                    value: malePercentage,
                                    title: '$mPercentage%',
                                    radius: radius,
                                    titleStyle: TextStyle(
                                        fontSize: fontSize,
                                        fontWeight: FontWeight.bold,
                                        color: Constants.blackColor),
                                  );
                                case 1:
                                  return PieChartSectionData(
                                    color: const Color(0xffff5182),
                                    value: femalePercentage,
                                    title: '$fPercentage%',
                                    radius: radius,
                                    titleStyle: TextStyle(
                                        fontSize: fontSize,
                                        fontWeight: FontWeight.bold,
                                        color: Constants.blackColor),
                                  );
                                case 2:
                                  return PieChartSectionData(
                                    color: const Color(0xff13d38e),
                                    value: otherPercentage,
                                    title: '$oPercentage%',
                                    radius: radius,
                                    titleStyle: TextStyle(
                                        fontSize: fontSize,
                                        fontWeight: FontWeight.bold,
                                        color: Constants.blackColor),
                                  );
                                default:
                                  throw Error();
                              }
                            }),
                          ),
                        );
                      })),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Indicator(
                  textColor: Constants.blackColor,
                  color: Color(0xff0293ee),
                  text: 'Male',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  textColor: Constants.blackColor,
                  color: Color(0xffff5182),
                  text: 'Female',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  textColor: Constants.blackColor,
                  color: Color(0xff13d38e),
                  text: 'Other',
                  isSquare: true,
                ),
                SizedBox(
                  height: 18,
                ),
              ],
            ),
            const SizedBox(
              width: 28,
            ),
          ],
        ),
      ),
    );
  }
}

class TaskList extends StatefulWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskPriceController = TextEditingController();
  final TextEditingController taskDurController = TextEditingController();
  final TextEditingController taskRevDurController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      color: Constants.purpleLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          width: double.infinity,
          height: 400,
          decoration: const BoxDecoration(),
          child: StreamBuilder<QuerySnapshot>(
            stream: orgCollRef.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              // Loop through all documents in the "organizations" collection
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var organization = snapshot.data!.docs[index];

                  // Get the "tasks" subcollection for the current organization
                  var tasksCollection =
                      organization.reference.collection('tasks');

                  return StreamBuilder<QuerySnapshot>(
                    stream: tasksCollection.snapshots(),
                    builder: (context, subsnapshot) {
                      if (!subsnapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // Display the tasks for the current organization
                      return Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.account_balance_rounded,
                                      size: 40),
                                  Row(
                                    children: [
                                      const Text('Organization: ',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Text(organization['name'],
                                          style: const TextStyle(fontSize: 18)),
                                    ],
                                  ),
                                ],
                              ), // Dis
                              ...subsnapshot.data!.docs.map(
                                (task) => Card(
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
                                        Text(task['name']),
                                      ],
                                    ),
                                    subtitle: Row(
                                      children: [
                                        const Icon(
                                            Icons.monetization_on_outlined),
                                        const Text('Price: '),
                                        Text('\$${task['price']}'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class UsersList extends StatefulWidget {
  const UsersList({Key? key}) : super(key: key);

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  final CollectionReference _users = usersCollRef;

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
        height: 400,
        decoration: const BoxDecoration(),
        child: StreamBuilder(
          stream: _users.where('role', isEqualTo: 'player').snapshots(),
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
                          const Icon(Icons.person),
                          const Text('Name: '),
                          Text(documentSnapshot['name'])
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          const Icon(Icons.email),
                          const Text('Email: '),
                          Text(documentSnapshot['email'])
                        ],
                      ),
                      onTap: () {},
                      leading: Checkbox(
                          checkColor: Constants.blackColor,
                          value: documentSnapshot['isActive'],
                          onChanged: (bool? value) {
                            documentSnapshot.reference
                                .update({'isActive': value});
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
}

class OrgsList extends StatefulWidget {
  const OrgsList({Key? key}) : super(key: key);

  @override
  State<OrgsList> createState() => _OrgsListState();
}

class _OrgsListState extends State<OrgsList> {
  final CollectionReference _orgs = orgCollRef;

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
          height: 400,
          decoration: const BoxDecoration(),
          child: StreamBuilder(
            stream: _orgs.snapshots(),
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
                            const Icon(Icons.account_balance_sharp),
                            const Text('Name: '),
                            Text(documentSnapshot['name']),
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            const Icon(Icons.email_outlined),
                            const Text('Email: '),
                            Text(documentSnapshot['email']),
                          ],
                        ),
                        onTap: () {},
                        leading: Checkbox(
                            checkColor: Constants.blackColor,
                            value: documentSnapshot['isActive'],
                            onChanged: (bool? value) {
                              documentSnapshot.reference
                                  .update({'isActive': value});
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
        ));
  }
}
