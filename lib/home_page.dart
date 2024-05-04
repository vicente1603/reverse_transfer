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

  final List<String> cards = ['MASTERCARD/VISA', 'HIPER/ELO/AMEX'];

  final List<String> paymentMethods = ['A VISTA', 'DÉBITO', 'CRÉDITO'];

  final List<int> installments = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  late double percent;
  late int quota;
  double doctorValue = 0;
  double clinicValue = 0;
  double quotaValue = 0;
  double valueWithCardTax = 0;
  String selectedCard = '';
  String selectedPaymentMethod = '';

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

    selectedCard = cards.first;
    percent = procedures.values.first;
    quota = installments.first;
    selectedPaymentMethod = paymentMethods.first;
  }

  void clear() {
    setState(() {
      doctorValue = 0;
      clinicValue = 0;
      quotaValue = 0;
      valueWithCardTax = 0;
      valueController.clear();
      percent = procedures.values.first;
      quota = installments.first;
      selectedPaymentMethod = paymentMethods.first;
      selectedCard = cards.first;
    });
  }

  void calcDebitTax(double value, double percent) {
    if (selectedCard == 'MASTERCARD/VISA') {
      valueWithCardTax = value - (value * 0.96 / 100);
    } else {
      valueWithCardTax = value - (value * 1.76 / 100);
    }
    doctorValue = valueWithCardTax - (valueWithCardTax * percent / 100);
    clinicValue = valueWithCardTax - doctorValue;
  }

  void calcCreditTax(double value, int quota, double percent) {
    if (selectedCard == 'MASTERCARD/VISA') {
      switch (quota) {
        case 1:
          valueWithCardTax = value - (value * 2.23 / 100);
          break;
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
          valueWithCardTax = value - (value * 2.72 / 100);
          break;
        case 7:
        case 8:
        case 9:
        case 10:
        case 11:
        case 12:
          valueWithCardTax = value - (value * 2.97 / 100);
          break;
        default:
      }
    } else {
      switch (quota) {
        case 1:
          valueWithCardTax = value - (value * 3.03 / 100);
          break;
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
          valueWithCardTax = value - (value * 3.52 / 100);
          break;
        case 7:
        case 8:
        case 9:
        case 10:
        case 11:
        case 12:
          valueWithCardTax = value - (value * 3.77 / 100);
          break;
        default:
      }
    }
    doctorValue = valueWithCardTax - (valueWithCardTax * percent / 100);
    clinicValue = valueWithCardTax - doctorValue;
  }

  void calc(double percent, String valueStr, int quota) {
    valueStr = valueStr
        .replaceAll('R\$ ', '')
        .replaceAll('.', '')
        .replaceAll(',', '.');

    double value = double.parse(valueStr);

    setState(() {
      if (selectedPaymentMethod == "CRÉDITO") {
        calcCreditTax(value, quota, percent);
        if (quota > 1) {
          quotaValue = clinicValue / quota;
        } else {
          quotaValue = clinicValue;
        }
      } else if (selectedPaymentMethod == "DÉBITO") {
        calcDebitTax(value, percent);
      } else {
        doctorValue = value - (value * percent / 100);
        clinicValue = value - doctorValue;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Selecione um procedimento',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
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
                                                        textAlign:
                                                            TextAlign.center,
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
                                height: 8,
                              ),
                              const Text(
                                'Insira o valor do procedimento',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0),
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
                              const SizedBox(height: 8.0),
                              const Text(
                                'Selecione o método de pagamento',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2, //
                                  ),
                                ),
                                width: 200,
                                height: 50,
                                child: DropdownButton<String>(
                                  value: selectedPaymentMethod,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.black),
                                  underline: Container(),
                                  isExpanded: true,
                                  icon:
                                      const Icon(Icons.arrow_drop_down_rounded),
                                  iconSize: 36,
                                  onChanged: (String? paymentMethod) {
                                    setState(() {
                                      selectedPaymentMethod = paymentMethod!;
                                    });
                                  },
                                  items: paymentMethods.map((String key) {
                                    return DropdownMenuItem<String>(
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
                                                    textAlign: TextAlign.center,
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
                              const SizedBox(height: 8.0),
                              Visibility(
                                visible: selectedPaymentMethod != "A VISTA",
                                child: const Text(
                                  'Selecione o cartão e parcelas',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Visibility(
                                visible: selectedPaymentMethod != "A VISTA",
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 2, //
                                        ),
                                      ),
                                      width: 200,
                                      height: 50,
                                      child: DropdownButton<String>(
                                        value: selectedCard,
                                        elevation: 16,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        underline: Container(),
                                        isExpanded: true,
                                        icon: const Icon(
                                            Icons.arrow_drop_down_rounded),
                                        iconSize: 36,
                                        onChanged: (String? card) {
                                          setState(() {
                                            selectedCard = card!;
                                          });
                                        },
                                        items: cards.map((String key) {
                                          return DropdownMenuItem<String>(
                                            value: key,
                                            child: Padding(
                                              padding: const EdgeInsets.all(2),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: SizedBox(
                                                      child: Center(
                                                        child: Text(
                                                          key.toString(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black),
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
                                    const SizedBox(width: 8.0),
                                    Visibility(
                                      visible:
                                          selectedPaymentMethod == "CRÉDITO",
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 2, //
                                          ),
                                        ),
                                        width: 100,
                                        height: 50,
                                        child: DropdownButton<int>(
                                          value: quota,
                                          elevation: 16,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          underline: Container(),
                                          isExpanded: true,
                                          icon: const Icon(
                                              Icons.arrow_drop_down_rounded),
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
                                                padding:
                                                    const EdgeInsets.all(2),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: SizedBox(
                                                        child: Center(
                                                          child: Text(
                                                            key.toString(),
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black),
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
                                    ),
                                  ],
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
                              const SizedBox(
                                height: 8.0,
                              ),
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
                              Visibility(
                                visible: doctorValue != 0,
                                child: Container(
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Visibility(
                                              visible: quotaValue > 0,
                                              child: Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      "Valor de cada parcela da clínica: ",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    Text(
                                                      MoneyMaskedTextController(
                                                        initialValue:
                                                            quotaValue,
                                                        leftSymbol: 'R\$ ',
                                                        thousandSeparator: '.',
                                                        decimalSeparator: ',',
                                                        precision: 2,
                                                      ).text,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )),
                              ),
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
