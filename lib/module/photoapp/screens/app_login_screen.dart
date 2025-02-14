import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:photoapp/service/user_service.dart';

class AppLoginScreen extends StatefulWidget {
  @override
  State<AppLoginScreen> createState() => _AppLoginScreenState();
}

class _AppLoginScreenState extends State<AppLoginScreen> {
  final formKey = GlobalKey<FormState>();
  final idCon = TextEditingController(text: kDebugMode ? "" : "");
  final pwCon = TextEditingController(text: kDebugMode ? "" : "");

  @override
  void dispose() {
    super.dispose();
    idCon.dispose();
    pwCon.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFD10F1A),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            // color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12)),
        // color: Theme.of(context).scaffoldBackgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: SizedBox(
          width: 300,
          child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Text("MAXRUN", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800))
                  Image.asset("assets/maxrun.jpg",width: 200,),
                  SizedBox(height: 48),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: idCon,
                    autofocus: true,
                    decoration: InputDecoration(labelText: "아이디"),
                    validator: (value) {
                      if (value?.isNotEmpty != true) {
                        return "아이디를 입력하세요";
                      }
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    textInputAction: TextInputAction.go,
                    controller: pwCon,
                    decoration: InputDecoration(labelText: "비밀번호"),
                    obscureText: true,
                    validator: (value) {
                      if (value?.isNotEmpty != true) {
                        return "비밀번호를 입력하세요";
                      }
                    },
                    onFieldSubmitted: (value) {
                      submit();
                    },
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: submit,
                      style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: Text("로그인", style: TextStyle(fontSize: 16)),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }

  submit() async {
    if (formKey.currentState?.validate() == true) {
      formKey.currentState?.save();
      await UserService().login(idCon.text, pwCon.text);
      idCon.text="";
      pwCon.text="";
    }
  }
}
