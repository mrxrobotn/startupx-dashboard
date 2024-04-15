import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../components/rounded_button.dart';
import '../../services/auth_response.dart';
import '../../services/authentication_service.dart';
import '../../utils/util.dart';
import '../signin/signin_screen.dart';

class SignUpForm extends StatefulWidget {
  SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  // text fields' controllers
  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController pwdEditingController = TextEditingController();
  final TextEditingController cfrnPwdEditingController =
      TextEditingController();
  final TextEditingController ageEditingController = TextEditingController();
  final TextEditingController stpnameEditingController =
      TextEditingController();

  String _selectedGender = '';

  String country = '';

  String organization = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            "Sign Up",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 30,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameEditingController,
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
                      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      fillColor: Colors.grey[300]),
                  //Lets apply validation
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: emailEditingController,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none)),
                      filled: true,
                      isDense: true,
                      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      fillColor: Colors.grey[300]),
                  //Lets apply validation
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: pwdEditingController,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none)),
                      filled: true,
                      isDense: true,
                      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      fillColor: Colors.grey[300]),
                  //Lets apply validation
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: cfrnPwdEditingController,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "Confirm Password",
                      prefixIcon: const Icon(Icons.key),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none)),
                      filled: true,
                      isDense: true,
                      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      fillColor: Colors.grey[300]),
                  //Lets apply validation
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Confirm Password is required";
                    } else if (value != pwdEditingController.text) {
                      return "Password & Confirm Password should match";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: ageEditingController,
                  decoration: InputDecoration(
                      hintText: "Age",
                      prefixIcon: const Icon(Icons.numbers),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none)),
                      filled: true,
                      isDense: true,
                      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      fillColor: Colors.grey[300]),
                  //Lets apply validation
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Age is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text('Organization:'),
                    StreamBuilder<QuerySnapshot>(
                      stream: orgCollRef.snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        List<DocumentSnapshot> documents = snapshot.data!.docs;
                        return DropdownButton<String>(
                          items: documents.map((document) {
                            return DropdownMenuItem<String>(
                              value: document.id,
                              child: Text(document['name']),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            // Handle changes to the selected value
                            setState(() {
                              organization = newValue!;
                            });
                          },
                        );
                      },
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: const [
                        Text('Select your gender:'),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          value: 'male',
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value.toString();
                            });
                          },
                        ),
                        const Text('Male'),
                        Radio(
                          value: 'female',
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value.toString();
                            });
                          },
                        ),
                        const Text('Female'),
                        Radio(
                          value: 'other',
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value.toString();
                            });
                          },
                        ),
                        const Text('Other'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: stpnameEditingController,
                  decoration: InputDecoration(
                      hintText: "StartUp Name",
                      prefixIcon: const Icon(Icons.badge),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none)),
                      filled: true,
                      isDense: true,
                      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      fillColor: Colors.grey[300]),
                  //Lets apply validation
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "StartUp Name is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Select your country: '),
                    IconButton(
                      onPressed: () {
                        showCountryPicker(
                            context: context,
                            onSelect: (Country value) {
                              country = value.name;
                            });
                      },
                      icon: const Icon(Icons.arrow_drop_down_rounded),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                RoundedButton(
                    label: "SIGN UP",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        AuthenticationService()
                            .signUpWithEmail(
                                name: nameEditingController.text,
                                email: emailEditingController.text,
                                password: pwdEditingController.text)
                            .then((authResponse) {
                          bool isActive = false;
                          String role = 'player';
                          if (authResponse.authStatus == AuthStatus.success) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignInScreen()),
                                (route) => false);
                            addUserDetails(
                              nameEditingController.text,
                              emailEditingController.text,
                              int.parse(ageEditingController.text),
                              _selectedGender,
                              stpnameEditingController.text,
                              country,
                              isActive,
                              role,
                              organization,
                            );
                          } else {
                            Util.showErrorMessage(
                                context, authResponse.message);
                          }
                        });
                      }
                    }),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account? "),
              InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()),
                      (route) => false);
                },
                child: const Text("Sign In",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold)),
              )
            ],
          )
        ],
      ),
    );
  }

  Future addUserDetails(
      String name,
      String email,
      int age,
      String gender,
      String stpName,
      String country,
      bool isActive,
      String role,
      String organization) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String? userId = user?.uid;
    String? userEmail = user?.email;

    await usersCollRef.doc(userId).set({
      'name': name,
      'email': email,
      'age': age,
      'gender': gender,
      'startup_name': stpName,
      'country': country,
      'isActive': isActive,
      'role': role,
      'organization': organization
    });

    // Get a reference to the document you want to read
    DocumentReference docRef = usersCollRef.doc(userId);

    // Read the document
    docRef.get().then((value) {
      print(country);
      print(userId);
    });

    addCountry(country, userId!);
    addUserToOrg(organization, userEmail!, userId, isActive);
  }

  Future addCountry(String country, String userId) async {
    List<String> arrayUsers = [userId];
    bool isAdded = false;

    countriesCollRef.get().then((snapshot) {
      if (snapshot.size == 0) {
        countriesCollRef.add({'name': country, 'users': arrayUsers});
        print('Collection created with success');
      } else {
        countriesCollRef.get().then((snapshot) {
          snapshot.docs.forEach((document) {
            String name = document['name'];
            if (name == country) {
              countriesCollRef
                  .doc(document.id)
                  .update({'users': FieldValue.arrayUnion(arrayUsers)});
              print('Collection exists');
              isAdded = true;
            }
          });
          if (!isAdded) {
            countriesCollRef.add({'name': country, 'users': arrayUsers});
          }
        });
      }
    });
  }

  Future addUserToOrg(String organization, String userEmail, String userId,
      bool isActive) async {
    String email = userEmail;
    String uid = userId;
    bool availabilty = isActive;
    orgCollRef.get().then((snapshot) {
      snapshot.docs.forEach((document) {
        String name = document.id;
        if (name == organization) {
          orgCollRef
              .doc(document.id)
              .collection('users')
              .doc(uid)
              .set({'uid': uid, 'email': email, 'isActive': availabilty});
        }
      });
    });
  }
}
