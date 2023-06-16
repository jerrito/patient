import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project/widgets/MainButton.dart';
import 'package:project/constants/Size_of_screen.dart';
import 'package:project/widgets/bottomNavigation.dart';
import 'package:project/widgets/doctorSearch.dart';
import 'package:project/widgets/homeContainers.dart';
import 'package:project/main.dart';
import 'package:project/databases/mongo.dart';
import 'package:project/modules/user.dart';
import 'package:project/userProvider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserProvider? userProvider;
  int indexed = 0;
  bool search = false;
  bool searching = true;
  double searchWidth = 150;
  @override
  void initState() {
    Mongo.con();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(210, 230, 250, 0.2),
                  Color.fromRGBO(210, 230, 250, 0.2)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: h_s * 3.75),
                const Text(
                  "Find your",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 5.0),
                      child: Text(
                        "Specialist",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    //SizedBox( width: w_s*41.67,height: 40,),
                    IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          showSearch(
                              context: context, delegate: DoctorSearching());
                        }),
                  ],
                ),
                const SizedBox(height: 20),
                FutureBuilder(
                    future: Mongo.getDoctor(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        var doctors = snapshot.data.length;
                        return CarouselSlider.builder(
                            itemCount: doctors,
                            options: CarouselOptions(
                              height: h_s * 20.625,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 5),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.3,
                            ),
                            itemBuilder: (context, index, realIdx) {
                              return docInfo(
                                  Appointment.fromJson(snapshot.data[index]));
                            });
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: SizedBox(
                            width: w_s * 72.22,
                            height: h_s * 20.625,
                            child: const Center(
                                child: SpinKitFadingCube(
                              color: Colors.pink,
                              size: 50.0,
                            )),
                          ),
                        );
                      } else {
                        return Center(
                          child: SizedBox(
                            width: w_s * 72.22,
                            height: h_s * 20.625,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.wifi_off, color: Colors.pink),
                                const SizedBox(height: 20),
                                const Text("Network error",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                MainButton(
                                  onPressed: () async {
                                    setState(() {
                                      searching = false;
                                    });
                                    await Mongo.getDoctor().whenComplete(() =>
                                        Navigator
                                            .restorablePushReplacementNamed(
                                                context, "homepage"));
                                    setState(() {
                                      searching = true;
                                    });
                                    // await mongo.getDoctor();
                                  },
                                  color: Colors.pink,
                                  backgroundColor: Colors.pink,
                                  child: Visibility(
                                      visible: searching,
                                      replacement: const SpinKitFadingCube(
                                        color: Colors.pink,
                                        //size: 50.0,
                                      ),
                                      child: const Text("Refresh")),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    }),

                const SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Categories"),
                      Icon(Icons.arrow_back)
                    ]),

                const SizedBox(height: 10),
                Flexible(
                  child: ListView.builder(
                    reverse: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DoctorCategories(
                                icon: SvgPicture.asset(
                                    width: 24,
                                    height: 24,
                                    color: Colors.pink,
                                    "./assets/medical_icons/head-side-virus.svg"),
                                role: "Neurologist"),
                            const DoctorCategories(
                                icon: Icon(
                                  Icons.mood_outlined,
                                  color: Colors.pink,
                                ),
                                role: "Dentist"),
                            DoctorCategories(
                                icon: SvgPicture.asset(
                                    width: 24,
                                    height: 24,
                                    color: Colors.pink,
                                    "./assets/medical_icons/baby.svg"),
                                role: "Obstetrician"),
                            DoctorCategories(
                                icon: SvgPicture.asset(
                                    width: 24,
                                    height: 24,
                                    color: Colors.pink,
                                    "./assets/medical_icons/capsules.svg"),
                                role: "Gynecologist"),
                            DoctorCategories(
                                icon: SvgPicture.asset(
                                    width: 24,
                                    height: 24,
                                    color: Colors.pink,
                                    "./assets/medical_icons/lungs-virus.svg"),
                                role: "Radiologist"),
                            DoctorCategories(
                                icon: SvgPicture.asset(
                                    width: 24,
                                    height: 24,
                                    color:Colors.pink,
                                    "./assets/medical_icons/capsules.svg"),
                                role: "Anesthesiologist"),
                            DoctorCategories(
                                icon: SvgPicture.asset(
                                    width: 24,
                                    height: 24,
                                    color: Colors.pink,
                                    "./assets/medical_icons/hand-holding-medical.svg"),
                                role: "Family physician"),
                            DoctorCategories(
                                icon: SvgPicture.asset(
                                    width: 24,
                                    height: 24,
                                    color: Colors.pink,
                                    "./assets/medical_icons/lungs-virus.svg"),
                                role: "Internist"),
                            DoctorCategories(
                                icon: SvgPicture.asset(
                                    width: 24,
                                    height: 24,
                                    color: Colors.pink,
                                    "./assets/medical_icons/allergies.svg"),
                                role: "Dermatologist"),
                            DoctorCategories(
                                icon: SvgPicture.asset(
                                    width: 24,
                                    height: 24,
                                    color: Colors.pink,
                                    "./assets/medical_icons/baby.svg"),
                                role: "Pediatrician"),
                            DoctorCategories(
                                icon: SvgPicture.asset(
                                    width: 24,
                                    height: 24,
                                    color: Colors.pink,
                                    "./assets/medical_icons/dna.svg"),
                                role: "E.R doctor"),
                            DoctorCategories(
                                icon: SvgPicture.asset(
                                    width: 24,
                                    height: 24,
                                    color: Colors.pink,
                                    "./assets/medical_icons/head-side-virus.svg"),
                                role: "Psychiatrist"),
                            DoctorCategories(
                                icon: SvgPicture.asset(
                                  "./assets/svgs/eye.svg",
                                  color: Colors.pink,
                                ),
                                role: "Ophthalmologist"),
                          ]);
                    },
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Available Doctors"),
                      TextButton(child: const Text("See All"), onPressed: () {})
                    ]),
                // CarouselSlider(
                //     items: items,
                //     options: CarouselOptions(
                //       height: h_s*20.625,
                //       autoPlay: true,
                //       autoPlayInterval: Duration(seconds: 5),
                //       autoPlayCurve: Curves.fastOutSlowIn,
                //       enlargeCenterPage: true,
                //       enlargeFactor: 0.3,
                //     ),),

                FutureBuilder(
                    future: Mongo.getDoctorOnline(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        var doctors = snapshot.data.length;
                        return CarouselSlider.builder(
                            itemCount: doctors,
                            options: CarouselOptions(
                              height: h_s * 20.625,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 5),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.3,
                            ),
                            itemBuilder: (context, index, realIdx) {
                              return docPick(
                                  Appointment.fromJson(snapshot.data[index]));
                            });
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: SizedBox(
                            width: w_s * 72.22,
                            height: h_s * 23.125,
                            child: const Center(
                                child: SpinKitFadingCube(
                              color: Colors.pink,
                              size: 50.0,
                            )),
                          ),
                        );
                      } else {
                        return Center(
                          child: SizedBox(
                            width: w_s * 72.22,
                            height: h_s * 20.625,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.wifi_off, color: Colors.pink),
                                const SizedBox(height: 20),
                                const Text("Network error",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                MainButton(
                                  onPressed: () async {
                                    await Mongo.getDoctor().whenComplete(() =>
                                        Navigator
                                            .restorablePushReplacementNamed(
                                                context, "homepage"));
                                  },
                                  color: Colors.pink,
                                  backgroundColor: Colors.pink,
                                  child: const Text("Refresh"),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    }),
                // CarouselSlider(
                //     items: items_2,
                //     options: CarouselOptions(
                //       height: 185,
                //       autoPlay: false,
                //       autoPlayInterval: Duration(seconds: 2),
                //       autoPlayCurve: Curves.fastOutSlowIn,
                //       enlargeCenterPage: true,
                //       enlargeFactor: 0.3,
                //     )
                // ),
              ],
            )),
        bottomNavigationBar: BottomNavBar(
          idx: 0,
        ));
  }

  Widget docInfo(Appointment user) {
    return DoctorInfo(
      name: "${user.fullName}",
      speciality: "${user.speciality}",
      email: "${user.email}",
      location: "${user.location}",
      picture: "${user.image}",
      experience: '${user.experience}',
      patients: '${user.patients}',
      number: '${user.number}',
    );
  }

//   List<Widget> items=[
//     DoctorInfo(Name: "Stephen Atta", Speciality: "Orthopedic",
//       location: "Korle Bu", picture:"doctor_1.jpg", Experience: '2.7 Years',
//       Patients: '4.63K', number: '',),
//     DoctorInfo(Name: "Jerry Boateng", Speciality: "Pediatrician", location: "UCC Hospital",
//         picture:"doctor_2.jpg", Experience: '4.3 Years', Patients: '954K',number: ''),
// DoctorInfo(Name: "John Ametepe", Speciality: "Nuerologist", location: "KATH",
//     picture:"doctor_2.jpg", Experience: '3.5 Years', Patients: '795',number: ''),
// DoctorInfo(Name: "Mannasseh Tsikata", Speciality: "Cardiologist", location: "UCC Hospital",
//     picture:"doctor_1.jpg", Experience: '4 Years', Patients: '1.31K',number: ''),
// DoctorInfo(Name: "Dora Aidoo", Speciality: "Psychiatric doctor", location: "Ridge Hospital",
//     picture:"doctor_2.jpg", Experience: '2 Years', Patients: '3.21K',number: ''),
//
//   ];
  Widget docPick(Appointment user) {
    return DoctorPick(
      name: "${user.fullName}",
      speciality: "${user.speciality}",
      location: "${user.location}",
      picture: "${user.image}",
      experience: '${user.experience}',
      patients: '${user.patients}',
      rating: user.ratings!,
      number: '${user.number}',
      email: "${user.email}",
    );
  }

  // List<Widget> items_2=[
  //  DoctorPick(Name: "Esther Obuobi", Speciality: "Cardiologist", picture: "doctor_1.jpg",
  //    Experience: "6 Years", Patients: "890", rating: 4, location: 'Korle Bu',),
  //  DoctorPick(Name: "Daniel Amissah", Speciality: "Psychiatric Doctor", picture: "doctor_2.jpg",
  //    Experience: "6 Years", Patients: "1.21K",rating: 3, location: 'KATH',),
  //  DoctorPick(Name: "Freda Otu", Speciality: "Cardiologist", picture: "doctor_1.jpg",
  //    Experience: "2 Years", Patients: "3.21K",rating: 5, location: 'UCC Hospital', ),
  //  DoctorPick(Name: "Peter Atsu", Speciality: "Medicine Specialist", picture: "doctor_2.jpg",
  //      Experience: "12 Years", Patients: "1.92K",rating:2.8, location: 'KATH', ),
  //  DoctorPick(Name: "Priscilla Segbefia", Speciality: "Nuerologist", picture: "doctor_1.jpg",
  //    Experience: "9 Years", Patients: "3.91K",rating: 4.5, location: 'St. Helena Clinic', ),
  //  DoctorPick(Name: "Isaac Abanga", Speciality: "Pediatrician", picture: "doctor_2.jpg",
  //    Experience: "1 Year", Patients: "932",rating: 3.7, location: 'Ridge Hospital', ),
  //
  //   ];
}

class DoctorSearching extends SearchDelegate<DoctorSearch> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
    throw UnimplementedError();
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          close(
              context,
              const DoctorSearch(
                cardvalue: '',
              ));
        });
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
        future: Mongo.getDoctorBySearch(query),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var doctors = snapshot.data.length;
            return ListView.builder(
                itemCount: doctors,
                itemBuilder: (context, index) {
                  return docSeek(Appointment.fromJson(snapshot.data[index]));
                });
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                width: w_s * 72.22,
                height: h_s * 20.625,
                child: const Center(
                    child: SpinKitFadingCube(
                  color: Colors.pink,
                  size: 50.0,
                )),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(
                child: Text("No results match your search",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
          } else {
            return Center(
              child: SizedBox(
                width: w_s * 72.22,
                height: h_s * 20.625,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.wifi_off,
                      color: Colors.pink,
                      size: 30,
                    ),
                    SizedBox(height: 30),
                    Text("Network error",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          }
        });
    //throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
        future: Mongo.getDoctorBySearch(query),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var doctors = snapshot.data.length;
            return ListView.builder(
                itemCount: doctors,
                itemBuilder: (context, index) {
                  return docSeek(Appointment.fromJson(snapshot.data[index]));
                });
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                width: w_s * 72.22,
                height: h_s * 20.625,
                child: const Center(
                    child: SpinKitFadingCube(
                  color: Colors.pink,
                  size: 50.0,
                )),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(
                child: Text("No results match your search",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
          } else {
            return Center(
              child: SizedBox(
                width: w_s * 72.22,
                height: h_s * 20.625,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.wifi_off,
                      color: Colors.pink,
                      size: 30,
                    ),
                    SizedBox(height: 30),
                    Text("Network error",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          }
        });
    throw UnimplementedError();
  }

  Widget docSeek(Appointment user) {
    return DoctorSearcher(
      name: "${user.fullName}",
      speciality: "${user.speciality}",
      location: "${user.location}",
      number: '${user.number}',
      image: '${user.image}',
      email: "${user.email}",
    );
  }
}
