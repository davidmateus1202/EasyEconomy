import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/hex_color.dart';


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
      hintStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 15,
        fontWeight: FontWeight.bold,

      ),
      prefixIcon: Icon(icon),
    ),
  );
}
