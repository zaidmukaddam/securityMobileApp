import 'package:fast_rsa/model/bridge.pb.dart';
import 'package:flutter/material.dart';
import 'package:security/widget/ButtonBuilder.dart';
import 'package:security/widget/TextInput.dart';
import 'package:fast_rsa/rsa.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DecryptAsyUI extends StatefulWidget {
  @override
  _DecryptAsyUIState createState() => _DecryptAsyUIState();
}

class _DecryptAsyUIState extends State<DecryptAsyUI> {
  TextEditingController _input = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _output = TextEditingController();
  @override
  void initState() {
    super.initState();
    _initFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(80, 0, 0, 1),
          title: Text("Decrypt"),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                Color.fromRGBO(80, 0, 0, 1),
                Color.fromRGBO(20, 0, 0, 1),
                Color.fromRGBO(15, 0, 0, 1)
              ])),
          child: Center(child: _getBody(context)),
        ));
  }

  _getBody(BuildContext context) {
    double inputHeight = MediaQuery.of(context).size.height / 4;
    return Column(
      children: [
        buildCustomInputField(
            true, "Your Message", _input, inputHeight, true, true, this),
        buildCustomInputField(
            false, "", _password, inputHeight / 2, true, true, this),
        ButtonBuilder.buildRaisedButton(context, _decrypt, "Decrypt"),
        buildCustomInputField(true, "", _output, inputHeight, true, false, this)
      ],
    );
  }

  _decrypt() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var private = preferences.get('privateKey');
    var result =
        await RSA.decryptOAEP(_input.text, "", Hash.HASH_SHA256, private);
    _output.text = result;
    setState(() {});
  }

  _initFields() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _password.text = preferences.getString('privateKey');
    setState(() {});
  }
}
