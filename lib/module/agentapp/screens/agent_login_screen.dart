import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:photoapp/service/user_service.dart';

class AgentLoginScreen extends StatefulWidget {
  @override
  State<AgentLoginScreen> createState() => _AgentLoginScreenState();
}

class _AgentLoginScreenState extends State<AgentLoginScreen> {
  final formKey = GlobalKey<FormState>();
  String? id = "";
  String? pw = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
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
                  Text("맥스런 에이전트", style: TextStyle(fontSize: 32)),
                  SizedBox(height: 24),
                  TextFormField(
                    initialValue: kDebugMode ? "maxrun" : null,
                    autofocus: true,
                    decoration: InputDecoration(labelText: "아이디"),
                    onSaved: (newValue) {
                      id = newValue;
                    },
                    validator: (value) {
                      if (value?.isNotEmpty != true) {
                        return "아이디를 입력하세요";
                      }
                    },
                    onFieldSubmitted: (value) {
                      submit();
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    initialValue: kDebugMode ? "maxrun" : null,
                    decoration: InputDecoration(labelText: "비밀번호"),
                    obscureText: true,
                    onSaved: (newValue) {
                      pw = newValue;
                    },
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

  submit() {
    if (formKey.currentState?.validate() == true) {
      formKey.currentState?.save();
      UserService().login(id!, pw!);
    }
  }
}
