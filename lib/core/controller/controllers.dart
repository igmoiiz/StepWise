import 'package:flutter/widgets.dart';

class Controllers {
  //  Input Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  //  Global Keys
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //  Animation Controllers
  late AnimationController fadeController;
  late AnimationController slideController;

  //  Animations Variables
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  //  Loading Variable and Agree to terms and condition variable
  bool isLoading = false;
  bool agreeToTerms = false;
}
