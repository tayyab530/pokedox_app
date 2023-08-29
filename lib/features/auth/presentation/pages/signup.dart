import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:pokedex/features/home/presentation/pages/home.dart';

import '../../../../injector_container.dart';
import '../../../../utils/message.helper.dart';
import '../blocs/auth.cubit.dart';

final _signupFormKey = GlobalKey<FormBuilderState>();

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios,color: Colors.black87,)),
      ),
      body: BlocProvider(
        create: (context) => AuthenticationCubit(),
        child: SignupForm(),
      ),
    );
  }
}

class SignupForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = Injector.get<AuthenticationCubit>();

    return SingleChildScrollView(
      child: BlocConsumer<AuthenticationCubit, AuthenticationState>(
        bloc: cubit,
        listenWhen: (previous, current) => current is ActionState,
        buildWhen: (previous, current) => current is! ActionState,
        listener: (context, state) {
          if (state is AuthenticationFailure) {
            ToastHelper.showFailure(state.message);
          } else if (state is AuthenticationSuccess) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
              return HomeScreen();
            }));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: FormBuilder(
              key: _signupFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Expanded(child: Image.asset("assets/images/signup.png",fit: BoxFit.cover,)),
                  ),
                  SizedBox(height: 20,),
                  FormBuilderTextField(
                    name: 'name',
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(16, 14, 16, 14),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF999999),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF999999),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF999999),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      isDense: true,
                      hintText: 'User Name', // Replace with your hint text
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.match(r'^[a-zA-Z\s]*$',
                          errorText: 'Only characters are allowed.'),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  FormBuilderTextField(
                    name: 'email',
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(16, 14, 16, 14),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF999999),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF999999),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF999999),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      isDense: true,
                      hintText: 'Email', // Replace with your hint text
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.email(),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  FormBuilderTextField(
                    name: 'password',
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(16, 14, 16, 14),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF999999),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF999999),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF999999),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      isDense: true,
                      hintText: 'Password', // Replace with your hint text
                    ),
                    obscureText: true,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(6),
                    ]),
                  ),
                  const SizedBox(height: 36),
                  ElevatedButton(
                    onPressed: () {
                      if (_signupFormKey.currentState!.saveAndValidate()) {
                        final email =
                            _signupFormKey.currentState!.value["email"] as String;
                        final password = _signupFormKey
                            .currentState!.value['password'] as String;
                        final name =
                            _signupFormKey.currentState!.value['name'] as String;
                        cubit.signup(email, password, name);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      primary: Theme.of(context).primaryColor,
                      minimumSize: Size(328, 58),
                    ),
                    child: state is LoadingState ? const Center(child: CircularProgressIndicator(color: Colors.white70,),):const Text('Signup'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
