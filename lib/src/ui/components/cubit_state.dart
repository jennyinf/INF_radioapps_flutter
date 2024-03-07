import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A State Helper class to automate reading the cubit for those classes
/// that cant just wrap it up in the build
///
/// Note that it doesnt save the cubit, the derived class can save, or watch it as needed
abstract class CubitState<T extends StatefulWidget,C extends Cubit> extends State<T> {

  @override void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) { 
      final state = context.read<C>();

      setCubit(state);
    });

  }

  /// override this function if you need to look at the cubit state
  void setCubit( C cubit ) {}
}
