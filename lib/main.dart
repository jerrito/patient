import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/widgets/MainButton.dart';
import 'package:project/constants/Size_of_screen.dart';
import 'package:project/appointments.dart';
import 'package:project/widgets/doctorSearch.dart';
import 'package:project/doctors.dart';
import 'package:project/firebase_options.dart';
import 'package:project/homePage.dart';
import 'package:project/login_signup/login.dart';
import 'package:project/profile.dart';
import 'package:project/login_signup/signUp.dart';
import 'package:project/login_signup/splash.dart';
import 'package:project/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_manager/theme_manager.dart';

int indexed = 0;
double w = SizeConfig.W;
double w_s = SizeConfig.SH;
double h = SizeConfig.H;
double h_s = SizeConfig.SV;
// ThemeData _buildTheme(brightness) {
//   var baseTheme = ThemeData(
//       brightness: brightness,
//       primaryIconTheme: IconThemeData(color: Colors.black),
//       primarySwatch: Colors.pink,
//       primaryColor: Colors.black);
//
//   return baseTheme.copyWith(
//     textTheme: GoogleFonts.notoSansGeorgianTextTheme(baseTheme.textTheme),
//   );
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const AppPage());
}

class AppPage extends StatelessWidget {
  final Widget? child;
  const AppPage({Key? key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            color: Colors.white,
          );}
        return ThemeManager(
            defaultBrightnessPreference: BrightnessPreference.light,
            data: (Brightness brightness) => ThemeData(
                  iconTheme: const IconThemeData(color: Colors.black),
                  primaryColor: Colors.black,
                  primarySwatch: Colors.pink,
                  textTheme: GoogleFonts.notoSansGeorgianTextTheme(
                      ThemeData().textTheme),
                  //accentColor: Colors.lightBlue,
                  brightness: Brightness.light,
                ),
            loadBrightnessOnStart: true,
            themedWidgetBuilder: (BuildContext context, ThemeData theme) {
              return MultiProvider(
                  providers: [
                    ListenableProvider(
                      create: (_) => UserProvider(preferences: snapshot.data),
                    ),
                    // ListenableProvider(
                    //     create: (_) =>
                    //         MedicalProvider(preferences: snapshot.data)),
                  ],
                  child: MaterialApp(
                    supportedLocales: const [
                      Locale("af"),
                      Locale("am"),
                      Locale("ar"),
                      Locale("az"),
                      Locale("be"),
                      Locale("bg"),
                      Locale("bn"),
                      Locale("bs"),
                      Locale("ca"),
                      Locale("cs"),
                      Locale("da"),
                      Locale("de"),
                      Locale("el"),
                      Locale("en"),
                      Locale("es"),
                      Locale("et"),
                      Locale("fa"),
                      Locale("fi"),
                      Locale("fr"),
                      Locale("gl"),
                      Locale("ha"),
                      Locale("he"),
                      Locale("hi"),
                      Locale("hr"),
                      Locale("hu"),
                      Locale("hy"),
                      Locale("id"),
                      Locale("is"),
                      Locale("it"),
                      Locale("ja"),
                      Locale("ka"),
                      Locale("kk"),
                      Locale("km"),
                      Locale("ko"),
                      Locale("ku"),
                      Locale("ky"),
                      Locale("lt"),
                      Locale("lv"),
                      Locale("mk"),
                      Locale("ml"),
                      Locale("mn"),
                      Locale("ms"),
                      Locale("nb"),
                      Locale("nl"),
                      Locale("nn"),
                      Locale("no"),
                      Locale("pl"),
                      Locale("ps"),
                      Locale("pt"),
                      Locale("ro"),
                      Locale("ru"),
                      Locale("sd"),
                      Locale("sk"),
                      Locale("sl"),
                      Locale("so"),
                      Locale("sq"),
                      Locale("sr"),
                      Locale("sv"),
                      Locale("ta"),
                      Locale("tg"),
                      Locale("th"),
                      Locale("tk"),
                      Locale("tr"),
                      Locale("tt"),
                      Locale("uk"),
                      Locale("ug"),
                      Locale("ur"),
                      Locale("uz"),
                      Locale("vi"),
                      Locale("zh")
                    ],
                    localizationsDelegates: const [
                      CountryLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                    ],
                    debugShowCheckedModeBanner: false,
                    theme: theme,
                    initialRoute: "splash",
                    routes: {
                      "homeScreen": (context) => const HomeScreen(),
                      "login": (context) => const LoginSignUp(),
                      "splash": (context) => const Splashscreen(),
                      "signup": (context) => const SignUpPage(),
                      "homepage": (context) => const HomePage(),
                      "doctorSearch": (context) => const DoctorSearch(
                            cardvalue: "Family physician",
                          ),
                      "profile": (context) => Profile(
                            profileUpdate:
                                ProfileUpdate(imagePath: "", check: "see"),
                          ),
                      "doctorsAvailable": (context) => const DoctorsAvailable(),
                      //"doctorAppointment": (context)=>DoctorAppointment(),
                      "appoinments": (context) => Appointments(
                            date: DateTime.now(),
                            time: '12:00 pm',
                            doctorName: 'Jerrito',
                            speciality: 'Gynaecologist',
                            location: "UCC Hospital",
                          ),
                      //"appoinmentList": (context)=>AppointmentList(date: null, time: '',),
                      // "doctorOptions": (context)=>DoctorOptions(),
                    },
                  ));
            });
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(210, 230, 250, 0.2),
          ),
          padding: const EdgeInsets.all(10),

          // margin: const EdgeInsets.only(left: 150),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: ListView(children: [
                const Center(
                    child: Text(
                  "ONLINE HEALTH CARE",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                )),
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: h_s * 18.75,
                    backgroundImage: Image.asset(
                      "./assets/images/doctor_1.jpg",
                      height: h / 3,
                      width: w,
                    ).image,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Center(
                    child: Text(
                  "Good Day Dear",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )),
                const Center(
                    child: Text(
                  "Welcome To Quality Online HealthCare ",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                )),
                const Center(
                    child: Text(
                  "Here your health is our priority",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                )),
              ]),
            ),
            SecondaryButton(
              onPressed: () {
                Navigator.pushNamed(context, "login");
              },
              foregroundColor: Colors.white,
              backgroundColor: Colors.pink,
              color: Colors.pink,
              child: const Text("Login",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            SecondaryButton(
              backgroundColor: Colors.white,
              foregroundColor: Colors.pink,
              onPressed: () {
                Navigator.pushNamed(context, "signup");
              },
              color: Colors.pink,
              child: const Text("Signup",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20)
          ])),
    );
  }
}
