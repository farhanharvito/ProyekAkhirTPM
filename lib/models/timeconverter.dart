import 'dart:async';

import 'package:flutter/material.dart';

class TimeConv extends StatefulWidget {
  const TimeConv({Key? key}) : super(key: key);

  @override
  _TimeConvState createState() => _TimeConvState();
}

class _TimeConvState extends State<TimeConv> {
  late String _input = 'WIB';
  late String _output = 'WIB';
  DateTime _result = DateTime.now();
  Timer _timer = Timer.periodic(const Duration(seconds: 1), (timer) {});
  late DateTime _convertedResult = DateTime.now();

  @override
  void initState() {
    super.initState();
    _input = 'WIB';
    _output = 'WIB';
    _result = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _result = DateTime.now();
      });
    });
  }

  void _onInputChanged(String? value) {
    setState(() {
      _input = value ?? 'WIB';
    });
  }

  void _onOutputChanged(String? value) {
    setState(() {
      _output = value ?? 'WIB';
    });
  }

  void _convert() {
    setState(() {
      switch (_input) {
        case 'WIB':
          switch (_output) {
            case 'WIB':
              _convertedResult = DateTime.now();
              break;
            case 'WITA':
              _convertedResult = DateTime.now().add(const Duration(hours: 1));
              break;
            case 'WIT':
              _convertedResult = DateTime.now().add(const Duration(hours: 2));
              break;
            case 'GMT (London)':
              _convertedResult = DateTime.now().subtract(const Duration(hours: 7));
              break;
          }
          break;
        case 'WITA':
          switch (_output) {
            case 'WIB':
              _convertedResult = DateTime.now().subtract(const Duration(hours: 1));
              break;
            case 'WITA':
              _convertedResult = DateTime.now();
              break;
            case 'WIT':
              _convertedResult = DateTime.now().add(const Duration(hours: 1));
              break;
            case 'GMT (London)':
              _convertedResult = DateTime.now().subtract(const Duration(hours: 7));
              break;
          }
          break;
        case 'WIT':
          switch (_output) {
            case 'WIB':
              _convertedResult = DateTime.now().subtract(const Duration(hours: 2));
              break;
            case 'WITA':
              _convertedResult = DateTime.now().subtract(const Duration(hours: 1));
              break;
            case 'WIT':
              _convertedResult = DateTime.now();
              break;
            case 'GMT (London)':
              _convertedResult = DateTime.now().subtract(const Duration(hours: 7));
              break;
          }
          break;
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget _buildInput() {
    return DropdownButtonFormField<String>(
      dropdownColor: Color.fromRGBO(49, 39, 79, 1),
      value: _input,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Input',
      ),
      onChanged: _onInputChanged,
      items: const [
        DropdownMenuItem(
          value: 'WIB',
          child: Text('WIB',style: TextStyle(
            color: Colors.white,
          ),),
        ),
        DropdownMenuItem(
          value: 'WITA',
          child: Text('WITA',style: TextStyle(
            color: Colors.white,
          ),),
        ),
        DropdownMenuItem(
          value: 'WIT',
          child: Text('WIT',style: TextStyle(
            color: Colors.white,
          ),),
        ),
        DropdownMenuItem(
          value: 'GMT (London)',
          child: Text('GMT (London)',style: TextStyle(
            color: Colors.white,
          ),),
        ),
      ],
    );
  }

  Widget _buildOutput() {
    return DropdownButtonFormField<String>(
      dropdownColor: Color.fromRGBO(49, 39, 79, 1),
      value: _output,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Output',
      ),
      onChanged: _onOutputChanged,
      items: const [
        DropdownMenuItem(
          value: 'WIB',
          child: Text('WIB',style: TextStyle(
            color: Colors.white,
          ),),
        ),
        DropdownMenuItem(
          value: 'WITA',
          child: Text('WITA',style: TextStyle(
            color: Colors.white,
          ),),
        ),
        DropdownMenuItem(
          value: 'WIT',
          child: Text('WIT',style: TextStyle(
            color: Colors.white,
          ),),
        ),
        DropdownMenuItem(
          value: 'GMT (London)',
          child: Text('GMT (London)',style: TextStyle(
            color: Colors.white,
          ),),
        ),
      ],
    );
  }

  Widget _buildResult() {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1), (i) => i),
      initialData: _result,
      builder: (context, snapshot) {
        return Text(
          '${_result.hour}:${_result.minute}:${_result.second}',
          style: const TextStyle(fontSize: 30, color: Colors.white),
        );
      },
    );
  }

  Widget _buildConvertedResult() {
    return Text(
      '${_convertedResult.hour}:${_convertedResult.minute}:${_convertedResult.second}',
      style: const TextStyle(fontSize: 30, color: Colors.white),
    );
  }

  Widget _buildConvertButton() {
    return ElevatedButton(
      onPressed: _convert,
      child: const Text('Convert',style: TextStyle(
        color: Colors.white,
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3C2A21),
      appBar: AppBar(
        backgroundColor: Color(0xFF3C2A21),
        title: const Text(
          'Time Converter',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInput(),
                  const SizedBox(height: 20),
                  _buildOutput(),
                  const SizedBox(height: 20),
                  _buildConvertButton(),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Current Time:',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 10),
            _buildResult(),
            const SizedBox(height: 10),
            Text(
              'Converted Time:',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 10),
            _buildConvertedResult(),
          ],
        ),
      ),
    );
  }
}

