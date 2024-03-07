

import 'package:flutter/material.dart';

/// Manage display of errors and global messages to the user - at some point this code will
/// use a custom snackbar
class MessageDisplay {

  // to use the snackbar associated with this scaffold, either instantiate it with the default key or 
  // pass the key you did use into showSnackBar
  static void showErrorInSnackBar(BuildContext context, String value) {
    final snackBar = SnackBar(
      backgroundColor : Theme.of(context).colorScheme.errorContainer,
      content: Text(value, 
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: 
                          Theme.of(context).colorScheme.onErrorContainer))
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}