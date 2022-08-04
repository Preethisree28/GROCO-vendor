import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:grocery_vendor/firebase_services.dart';
import 'package:grocery_vendor/providers/auth_provider.dart';
import 'package:grocery_vendor/screens/landing_screen.dart';
import 'package:grocery_vendor/utils/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);
  static const String id = 'registration-screen';

  @override

  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseService _services = FirebaseService();
  final AuthProvider authData = AuthProvider();
  final _formKey = GlobalKey<FormState>();
  final _storeName = TextEditingController();
  final _contactNumber = TextEditingController();
  final _email = TextEditingController();
  final _gstNumber = TextEditingController();
  final _storeDialog = TextEditingController();
  final _address = TextEditingController();

  String? _strName;
  String? _taxStatus;
  XFile? _storeImage;
  XFile? _logo;
  String? countryValue;
  String? stateValue;
  String? cityValue;
  String? _storeImageUrl;
  String? _logoUrl;
  String? address;
  double? latitude;
  double? longitude;



  final ImagePicker _picker = ImagePicker();

  Widget _formField(
      {TextEditingController? controller,
      String? label,
      TextInputType? type,
      IconData? icon,
        IconButton? iconButton,
         int? maxLines,
      String? Function(String?)? validator}) {
    return TextFormField(
      maxLines: maxLines,
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        icon: iconButton,
        prefixIcon: Icon(icon,size: 23),
        labelText: label,
        prefixText: controller == _contactNumber ? '+91' : null,
      ),
      validator: validator,
      onChanged: (value) {
        if (controller == _storeName) {
          setState(() {
            _strName = value;
          });
        }
      },
    );
  }

  Future<XFile?> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  _scaffold(message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            ScaffoldMessenger.of(context).clearSnackBars();
          },
        ),
      ),
    );
  }

  _saveToDB() {

    if (_storeImage == null) {
      _scaffold('Store Image not selected');
      return;
    }
    if (_logo == null) {
      _scaffold('Logo not selected');
      return;
    }

    if (_formKey.currentState!.validate()) {
      if (countryValue == null ||
          stateValue == null ||
          cityValue == null) {
        _scaffold('Location field incomplete');
        return;
      }
      EasyLoading.show(status: 'Please wait...');
      _services.uploadImage(_storeImage, 'vendors/${_services.user!.uid}/storeImage.jpg').then((String? url){
        if(url==null){
          setState(() {
            _storeImageUrl = url;
          });
        }
      }).then((value){
        _services.uploadImage(_logo, 'vendors/${_services.user!.uid}/logo.jpg').then((url) {
          setState(() {
            _logoUrl = url;
          });
        }).then((value) {
          _services.addVendor(
              data: {
                'storeImage' :_storeImageUrl,
                'logo' : _logoUrl,
                'shopName' : _storeName.text,
                'mobile' :'+91${_contactNumber.text}',
                'email' : _email.text,
                'taxRegistered' : _taxStatus,
                'gstNumber' : _gstNumber.text.isEmpty ? null : _gstNumber.text,
                'country' :countryValue,
                'state' : stateValue,
                'city' :cityValue,
                'approved':false,
                'shopOpen':true,
                'rating':0.00,
                'totalRating' : 0,
                'latitude' : latitude,
                'longitude': longitude,
                'location' : GeoPoint(latitude!, longitude!),
                'uid' : _services.user!.uid,
                'time':DateTime.now(),
                'description':_storeDialog.text,
                'topPicked':true,
                'address': _address.text,
              }
          ).then((value){
            EasyLoading.dismiss();
            return Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => const LandingScreen(),
              ),
            );
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<AuthProvider>(context);
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 210,
                child: Stack(
                  children: [
                    _storeImage == null
                        ? Container(
                            color: lightGreen,
                            height: 240,
                            child: TextButton(
                              onPressed: () {
                                _pickImage().then((value) {
                                  setState(() {
                                    _storeImage = value;
                                  });
                                });
                              },
                              child: Center(
                                child: Text(
                                  "Tap to add image of store",
                                  style:
                                      TextStyle(color: Colors.grey.shade800),
                                ),
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              _pickImage().then((value) {
                                setState(() {
                                  _storeImage = value;
                                });
                              });
                            },
                            child: Container(
                              height: 240,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  opacity: 90,
                                  image: FileImage(
                                    File(_storeImage!.path),
                                  ),
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.low,
                                ),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 80,
                      child: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        actions: [
                          IconButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                            },
                            icon: const Icon(Icons.exit_to_app,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                _pickImage().then((value) {
                                  setState(() {
                                    _logo = value;
                                  });
                                });
                              },
                              child: Card(
                                elevation: 5,
                                child: _logo == null
                                    ? const SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: Center(
                                          child: Text("+"),
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(5),
                                        child: SizedBox(
                                          height: 60,
                                          width: 60,
                                          child: Image.file(
                                            File(_logo!.path),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              _strName == null ? " " : _strName!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 8, 30, 8),
                child: Column(
                  children: [
                    _formField(
                        controller: _storeName,
                        label: "Store name",
                        icon: Icons.add_business,
                        type: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter name of the store";
                          }
                        }),
                    _formField(
                        controller: _contactNumber,
                        label: "Contact number",
                        icon: Icons.phone,
                        type: TextInputType.phone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Contact number";
                          }
                        }),
                    _formField(
                      controller: _email,
                      label: 'Email ',
                      icon: Icons.email,
                      type: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your Email address";
                        }
                        bool _isValid = (EmailValidator.validate(value));
                        if (_isValid == false) {
                          return 'Invalid Email address';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text('Tax Registered : '),
                        Expanded(
                          child: DropdownButtonFormField(
                              value: _taxStatus,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Select Tax status';
                                }
                              },
                              hint: const Text('Select'),
                              items: <String>[
                                'Yes',
                                'No'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _taxStatus = value;
                                });
                              }),
                        ),
                      ],
                    ),
                    if (_taxStatus == 'Yes')
                      _formField(
                        controller: _gstNumber,
                        label: 'GST Number ',
                        icon: Icons.pin,
                        type: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter GST Number";
                          }
                        },
                      ),
                    const SizedBox(height: 15),
                    CSCPicker(
                      ///Enable disable state dropdown [OPTIONAL PARAMETER]
                      showStates: true,

                      /// Enable disable city drop down [OPTIONAL PARAMETER]
                      showCities: true,

                      ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                      flagState: CountryFlag.DISABLE,

                      ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                      dropdownDecoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                          border: Border.all(
                              color: Colors.grey.shade300, width: 1)),

                      ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                      disabledDropdownDecoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey.shade300, width: 1)),

                      ///placeholders for dropdown search field
                      countrySearchPlaceholder: "Country",
                      stateSearchPlaceholder: "State",
                      citySearchPlaceholder: "City",

                      ///labels for dropdown
                      countryDropdownLabel: "*Country",
                      stateDropdownLabel: "*State",
                      cityDropdownLabel: "*City",

                      ///Default Country
                      defaultCountry: DefaultCountry.India,

                      ///Disable country dropdown (Note: use it with default country)
                      //disableCountry: true,

                      ///selected item style [OPTIONAL PARAMETER]
                      selectedItemStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),

                      ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                      dropdownHeadingStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),

                      ///DropdownDialog Item style [OPTIONAL PARAMETER]
                      dropdownItemStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),

                      ///Dialog box radius [OPTIONAL PARAMETER]
                      dropdownDialogRadius: 10.0,

                      ///Search bar radius [OPTIONAL PARAMETER]
                      searchBarRadius: 10.0,

                      ///triggers once country selected in dropdown
                      onCountryChanged: (value) {
                        setState(() {
                          ///store value in country variable
                          countryValue = value;
                        });
                      },

                      ///triggers once state selected in dropdown
                      onStateChanged: (value) {
                        setState(() {
                          ///store value in state variable
                          stateValue = value;
                        });
                      },

                      ///triggers once city selected in dropdown
                      onCityChanged: (value) {
                        setState(() {
                          ///store value in city variable
                          cityValue = value;
                        });
                      },
                    ),
                    const SizedBox(height: 3,),
                    _formField(
                      iconButton: IconButton(
                          color: lightGreen,
                          onPressed:(){
                        _address.text = 'Locating...\n Please wait';
                        authData.getCurrentAddress().then((address){
                          if(address != null){
                             latitude = authData.shopLatitude;
                             longitude = authData.shopLongitude;
                            setState(() {
                              _address.text = '${authData.shopAddress}';

                            });
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not find location.. Try again')));
                          }
                        });
                      },
                          icon:const Icon(Icons.my_location)),
                      controller: _address,
                      maxLines: 5,
                      label: 'Address',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please press navigation Button";
                        }
                        if(authData.shopLatitude == null){
                          return "Please press navigation Button";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 8,),
                    _formField(
                      maxLines: 2,
                      controller: _storeDialog,
                      label: 'Description..',
                      icon: Icons.message,
                      type: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Tell us about your store";
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        persistentFooterButtons: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _saveToDB,
                    child: const Text(
                      'Register',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
