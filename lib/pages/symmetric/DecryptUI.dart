import 'package:flutter/material.dart';
import 'package:security/util/SymmetricUtil.dart';
import 'package:security/util/styling/Text.dart';
import 'package:security/widget/TextInput.dart';

class DecryptUI extends StatefulWidget {
  @override
  _DecryptUIState createState() => _DecryptUIState();
}

class _DecryptUIState extends State<DecryptUI> {
  TextEditingController _input = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _output = TextEditingController();
  String dropdownValue = 'AES CBC';
  @override
  void initState() {
    super.initState();
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
            true, "Your Message", _input, inputHeight, true, true, this,
            callback: (v) => _onTextChange(v)),
        buildCustomInputField(
            true, "Your Key", _password, inputHeight / 3, true, true, this,
            callback: (v) => _onTextChange(v)),
        _getToggleButton(),
        buildCustomInputField(
            false, "", _output, inputHeight, true, false, this)
      ],
    );
  }

  _getToggleButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: DropdownButton<String>(
          style: buttonStyle,
          value: dropdownValue,
          dropdownColor: Colors.black87,
          isExpanded: true,
          elevation: 5,
          focusColor: Colors.red,
          underline: Container(),
          itemHeight: 50,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: Colors.red,
          ),
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
              _onTextChange(_input.text);
            });
          },
          items: <String>[
            'AES CBC',
            'AES CFB-64',
            'AES CTR',
            'AES ECB',
            'AES OFB-64/GCTR',
            'AES OFB-64',
            'AES SIC'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: _getListItem(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Null _onTextChange(String v) {
    _output.text = SymmetricUtil.decrypt(
        dropdownValue, _input.text, _password.text.trim());
    setState(() {});
  }

  _getListItem(String value) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Card(
        color: Colors.black45,
        child: Center(
            child: Text(
          value,
          style: buttonStyle,
        )),
      ),
    );
  }
}
