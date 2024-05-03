import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late MoneyMaskedTextController valueController;

  final Map<String, double> procedures = {
    'CONSULTAS/MMP': 30,
    'INJETÁVEIS': 50,
    'MPT': 60,
    'LASER': 40
  };

  final List<int> installments = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  late double percent;
  late int quota;
  double doctorValue = 0;
  double clinicValue = 0;
  double valorParcela = 0;

  @override
  void initState() {
    super.initState();
    valueController = MoneyMaskedTextController(
      initialValue: 0.0,
      leftSymbol: 'R\$ ',
      thousandSeparator: '.',
      decimalSeparator: ',',
      precision: 2,
    );
    percent = procedures.values.first;
    quota = installments.first;
  }

  void clear() {
    setState(() {
      doctorValue = 0;
      clinicValue = 0;
      valorParcela = 0;
      valueController.clear();
      percent = procedures.values.first;
      quota = installments.first;
    });
  }

  void calc(double percent, String valueStr, int quota) {
    valueStr = valueStr
        .replaceAll('R\$ ', '')
        .replaceAll('.', '')
        .replaceAll(',', '.');

    setState(() {
      double value = double.parse(valueStr);

      doctorValue = value - (value * percent / 100);
      clinicValue = value - doctorValue;

      if (quota > 1) {
        valorParcela = clinicValue / quota;
        print('Valor do médico: $doctorValue');
        print('Valor da clínica: $clinicValue');
        print('Valor de cada parcela da clínica: $valorParcela');
      } else {
        valorParcela = clinicValue;
        print('Valor do médico: $doctorValue');
        print('Valor da clínica: $clinicValue');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: LayoutBuilder(builder: (context, constraints) {
              return ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxHeight: 700, maxWidth: 500),
                  child: IntrinsicHeight(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.black,
                            width: 2, //
                          ),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Selecione um procedimento',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 2, //
                                        ),
                                      ),
                                      child: DropdownButton<double>(
                                        value: percent,
                                        elevation: 16,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        underline: Container(),
                                        isExpanded: true,
                                        icon: const Icon(
                                            Icons.arrow_drop_down_rounded),
                                        iconSize: 36,
                                        onChanged: (double? valor) {
                                          setState(() {
                                            percent = valor!;
                                          });
                                        },
                                        items:
                                            procedures.keys.map((String key) {
                                          return DropdownMenuItem<double>(
                                            value: procedures[key],
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: SizedBox(
                                                      child: Text(
                                                        key,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              const Text(
                                'Insira o valor do procedimento',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                width: 250,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2, //
                                  ),
                                ),
                                child: TextFormField(
                                  controller: valueController,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      hintText: MoneyMaskedTextController(
                                    initialValue: 0.0,
                                    leftSymbol: 'R\$ ',
                                    thousandSeparator: '.',
                                    decimalSeparator: ',',
                                    precision: 2,
                                  ).text),
                                ),
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                'Selecione o nº de parcelas',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2, //
                                  ),
                                ),
                                width: 150,
                                height: 50,
                                child: DropdownButton<int>(
                                  value: quota,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.black),
                                  underline: Container(),
                                  isExpanded: true,
                                  icon:
                                      const Icon(Icons.arrow_drop_down_rounded),
                                  iconSize: 36,
                                  onChanged: (int? valor) {
                                    setState(() {
                                      quota = valor!;
                                    });
                                  },
                                  items: installments.map((int key) {
                                    return DropdownMenuItem<int>(
                                      value: key,
                                      child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: SizedBox(
                                                child: Center(
                                                  child: Text(
                                                    key.toString(),
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors
                                            .blue, // Cor de fundo do botão
                                        foregroundColor: Colors
                                            .white, // Cor do texto do botão
                                      ),
                                      onPressed: () {
                                        calc(percent, valueController.text,
                                            quota);
                                      },
                                      child: const Text("CALCULAR"))),
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors
                                            .lightBlueAccent, // Cor de fundo do botão
                                        foregroundColor: Colors
                                            .white, // Cor do texto do botão
                                      ),
                                      onPressed: () {
                                        clear();
                                      },
                                      child: const Text("LIMPAR"))),
                              const SizedBox(
                                height: 8,
                              ),
                              Container(
                                  height: 200,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  width: double.infinity,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2, //
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  "Valor do médico: ",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  MoneyMaskedTextController(
                                                    initialValue: doctorValue,
                                                    leftSymbol: 'R\$ ',
                                                    thousandSeparator: '.',
                                                    decimalSeparator: ',',
                                                    precision: 2,
                                                  ).text,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  "Valor da clínica: ",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  MoneyMaskedTextController(
                                                    initialValue: clinicValue,
                                                    leftSymbol: 'R\$ ',
                                                    thousandSeparator: '.',
                                                    decimalSeparator: ',',
                                                    precision: 2,
                                                  ).text,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  "Valor de cada parcela da clínica: ",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  MoneyMaskedTextController(
                                                    initialValue: valorParcela,
                                                    leftSymbol: 'R\$ ',
                                                    thousandSeparator: '.',
                                                    decimalSeparator: ',',
                                                    precision: 2,
                                                  ).text,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ));
            }),
          ),
        ),
      ),
    );
  }
}
