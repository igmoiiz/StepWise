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
}
