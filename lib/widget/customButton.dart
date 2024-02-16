import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;
  const CustomButton({super.key,required this.title,required this.onTap,this.loading=false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.deepOrange,
            borderRadius: BorderRadius.circular(4)
        ),
        child: Center(child: loading ? const CircularProgressIndicator(color: Colors.white,strokeWidth: 3,) : Text(title,style: const TextStyle(color: Colors.white),)),
      ),
    );
  }
}