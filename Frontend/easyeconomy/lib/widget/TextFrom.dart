import 'package:flutter/material.dart';


Widget TextformFieldMovimientos(BuildContext context,
    TextEditingController controller, String hintText, IconData icon, GlobalKey<FormFieldState> formKey, TextInputType keyboardType) {
  return TextFormField(
    key: formKey,
    maxLines: null,
    keyboardType: keyboardType,
    validator: (value) {
      if (value!.isEmpty) {
        return 'Campo requerido';
      }
      return null;
    },
    onChanged: (value){
      formKey.currentState!.validate();
    
    },
    controller: controller,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      hintText: hintText,
      prefixIcon: Icon(icon),
    ),
  );
}
