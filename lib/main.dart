import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calc',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff2b6f68),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xfff4f1eb),
        useMaterial3: true,
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _display = '0';
  double? _storedValue;
  String? _operator;
  bool _replaceDisplay = false;

  void _digit(String value) => setState(() {
        if (_replaceDisplay || _display == '0') {
          _display = value;
          _replaceDisplay = false;
        } else {
          _display += value;
        }
      });

  void _decimal() => setState(() {
        if (_replaceDisplay) {
          _display = '0.';
          _replaceDisplay = false;
        } else if (!_display.contains('.')) {
          _display += '.';
        }
      });

  void _operatorPressed(String value) => setState(() {
        final current = double.tryParse(_display) ?? 0;
        if (_storedValue != null && _operator != null && !_replaceDisplay) {
          _storedValue = _calculate(_storedValue!, current, _operator!);
          _display = _format(_storedValue!);
        } else {
          _storedValue = current;
        }
        _operator = value;
        _replaceDisplay = true;
      });

  void _equals() {
    if (_storedValue == null || _operator == null) return;
    setState(() {
      _display = _format(
        _calculate(_storedValue!, double.tryParse(_display) ?? 0, _operator!),
      );
      _storedValue = null;
      _operator = null;
      _replaceDisplay = true;
    });
  }

  void _clear() => setState(() {
        _display = '0';
        _storedValue = null;
        _operator = null;
        _replaceDisplay = false;
      });

  void _backspace() => setState(() {
        if (_replaceDisplay || _display.length == 1) {
          _display = '0';
        } else {
          _display = _display.substring(0, _display.length - 1);
        }
      });

  void _sign() => setState(() {
        if (_display != '0') {
          _display = _display.startsWith('-')
              ? _display.substring(1)
              : '-$_display';
        }
      });

  void _percent() => setState(() {
        _display = _format((double.tryParse(_display) ?? 0) / 100);
      });

  double _calculate(double left, double right, String operator) {
    switch (operator) {
      case '+':
        return left + right;
      case '-':
        return left - right;
      case '×':
        return left * right;
      case '÷':
        return right == 0 ? 0 : left / right;
      default:
        return right;
    }
  }

  String _format(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(8).replaceFirst(RegExp(r'0+$'), '');
  }

  Widget _button(String label, VoidCallback action, {bool accent = false}) {
    final colors = Theme.of(context).colorScheme;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: FilledButton(
          onPressed: action,
          style: FilledButton.styleFrom(
            backgroundColor: accent ? colors.primary : colors.surface,
            foregroundColor: accent ? colors.onPrimary : colors.onSurface,
            elevation: 0,
            minimumSize: const Size.fromHeight(64),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _row(List<Widget> buttons) => Row(children: buttons);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'simple calc',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
              child: Column(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _display,
                          key: const Key('calculator-display'),
                          style: const TextStyle(
                            fontSize: 68,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff173f3c),
                          ),
                        ),
                      ),
                    ),
                  ),
                  _row([
                    _button('C', _clear),
                    _button('⌫', _backspace),
                    _button('%', _percent),
                    _button('÷', () => _operatorPressed('÷'), accent: true),
                  ]),
                  _row([
                    _button('7', () => _digit('7')),
                    _button('8', () => _digit('8')),
                    _button('9', () => _digit('9')),
                    _button('×', () => _operatorPressed('×'), accent: true),
                  ]),
                  _row([
                    _button('4', () => _digit('4')),
                    _button('5', () => _digit('5')),
                    _button('6', () => _digit('6')),
                    _button('-', () => _operatorPressed('-'), accent: true),
                  ]),
                  _row([
                    _button('1', () => _digit('1')),
                    _button('2', () => _digit('2')),
                    _button('3', () => _digit('3')),
                    _button('+', () => _operatorPressed('+'), accent: true),
                  ]),
                  _row([
                    _button('+/-', _sign),
                    _button('0', () => _digit('0')),
                    _button('.', _decimal),
                    _button('=', _equals, accent: true),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
