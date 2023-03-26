import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPercentageTotal;

  ChartBar(
      {required this.label,
      required this.spendingAmount,
      required this.spendingPercentageTotal});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Container(
              //using entire page
              // height: MediaQuery.of(context).size.height * 0.030,
              //<-->
              //using constaints and applying based on the LayoutBuilder
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                child: Text('\৳${spendingAmount.toStringAsFixed(0)}'),
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
              //height: MediaQuery.of(context).size.height * 0.025,
            ),
            Container(
              height: constraints.maxHeight * 0.6,
              width: constraints.maxWidth * 0.2,
              // height: MediaQuery.of(context).size.height * 0.115,
              // width: MediaQuery.of(context).size.width * 0.020,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.grey),
                      color: Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: spendingPercentageTotal,
                    child: Container(
                        decoration: BoxDecoration(
                      color: Color.fromARGB(255, 0, 170, 212),
                      borderRadius: BorderRadius.circular(10),
                    )),
                  )
                ],
              ),
            ),
            SizedBox(
              //height: MediaQuery.of(context).size.height * 0.025,
              height: constraints.maxHeight * 0.05,
            ),
            Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                child: Text(label),
              ),
            ),
          ],
        );
      },
    );
  }
}
