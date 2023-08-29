import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:pokedex/features/home/presentation/pages/home.dart';
import 'package:pokedex/injector_container.dart';
import 'package:pokedex/utils/message.helper.dart';

import '../blocs/auth.cubit.dart';
import 'signup.dart';

final _formKey = GlobalKey<FormBuilderState>();

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => AuthenticationCubit(),
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  final cubit = Injector.get<AuthenticationCubit>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocConsumer<AuthenticationCubit, AuthenticationState>(
        bloc: cubit,
        listenWhen: (previous, current) => current is ActionState,
        buildWhen: (previous, current) => current is! ActionState,
        listener: (context, state){
          if(state is AuthenticationFailure){
            ToastHelper.showFailure(state.message);
          }
          else if(state is AuthenticationSuccess){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){
              return const HomeScreen();
            }));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: FormBuilder(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/boy.png",height: 300,),
                  const SizedBox(height: 16),
                  FormBuilderTextField(
                    name: 'email',
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFF999999),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFF999999),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
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
                      contentPadding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFF999999),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFF999999),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
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
                      if (_formKey.currentState!.saveAndValidate()) {
                        final email = _formKey.currentState!.value['email'] as String;
                        final password = _formKey.currentState!.value['password'] as String;
                        cubit.login(email, password);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      primary: Theme.of(context).primaryColor,
                      minimumSize: const Size(328, 58),
                    ),
                    child: state is LoadingState ? const Center(child: CircularProgressIndicator(color: Colors.white70,),):const Text('Login'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignupScreen()),
                      );
                    },
                    child: Text('Don\'t have an account? Sign up',style: TextStyle(color: Colors.teal),),
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

