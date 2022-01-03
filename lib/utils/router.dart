import 'package:flutter/material.dart';
import 'package:hera2/enums/checklist_context_type.dart';
import 'package:hera2/main.dart';
import 'package:hera2/screens/baby_names_screen.dart';
import 'package:hera2/screens/due_date_screen.dart';
import 'package:hera2/screens/hospital_list_screen.dart';
import 'package:hera2/screens/initial_measurements_screen.dart';
import 'package:hera2/screens/generic_checklist_screen.dart';
import 'package:hera2/screens/pregnancy_rights_screen.dart';
import 'package:hera2/screens/sign_in_screen.dart';
import 'package:hera2/screens/the_bottle_shaker_screen.dart';
import '../screens/baby_size_screen.dart';

const String HomePageRoute = '/';
const String SignInRoute = 'sign_in';
const String BabyNamesRoute = 'baby_names';
const String DueDateRoute = 'due_date';
const String TheBottleShakerRoute = 'the_bottle_shaker';
const String BabySizeRoute = 'baby_size';
const String HospitalListRoute = 'hospital_list';
const String InitialMeasurementsRoute = 'initial_measurements';
const String GenericCheckListRoute = 'generic_checklist_route';
const String PregnancyRightsRoute = 'pregnancy_rights';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomePageRoute:
      return MaterialPageRoute(builder: (context) => MyHomePage());
    case SignInRoute:
      return MaterialPageRoute(builder: (context) => SignInScreen());
    case BabyNamesRoute:
      return MaterialPageRoute(builder: (context) => BabyNamesScreen());
    case DueDateRoute:
      bool isPoppable = false;
      if (settings.arguments != null) {
        isPoppable = settings.arguments as bool;
      }
      return MaterialPageRoute(
          builder: (context) => DueDateScreen(isPoppable: isPoppable));
    case TheBottleShakerRoute:
      return MaterialPageRoute(builder: (context) => TheBottleShakerScreen());
    case BabySizeRoute:
      return MaterialPageRoute(builder: (context) => BabySizeScreen());
    case HospitalListRoute:
      return MaterialPageRoute(builder: (context) => HospitalListScreen());
    case PregnancyRightsRoute:
      return MaterialPageRoute(builder: (context) => PregnancyRightsScreen());
    case GenericCheckListRoute:
      int args = settings.arguments as int;
      ChecklistContextType contextType = ChecklistContextType.values[args];
      return MaterialPageRoute(
          builder: (context) => GenericChecklistScreen(
                contextType: contextType,
              ));
    case InitialMeasurementsRoute:
      return MaterialPageRoute(
          builder: (context) => InitialMeasurementsScreen());
    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Text('No path for ${settings.name}'),
          ),
        ),
      );
  }
}
