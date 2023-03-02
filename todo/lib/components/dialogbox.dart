import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  DialogBox({Key? key, required this.controller, required this.onCancel, required this.onSave}) : super(key: key);
  TextEditingController controller = TextEditingController();
  VoidCallback onSave;
  VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
          height: 120,
          child: Column(
            children: [
              TextField(
                controller: controller,
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MaterialButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: onSave,
                        child: const Text('Ok'),
                      ),
                      const SizedBox(width: 10,),
                      MaterialButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: onCancel,
                        child: const Text('Thoát'),
                      ),
                    ],
                  )
              )
            ],
          )
      ),
    );
  }
}
