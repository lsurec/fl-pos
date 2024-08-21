import 'package:flutter/material.dart';

class TransferSummaryView extends StatelessWidget {
  const TransferSummaryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Datos simulados para el origen y el destino
    final String originLocation = "Balcón";
    final String originTable = "Mesa 1";
    final String originAccount = "Cuenta de Juan";
    final List<String> originTransactions = ["1 Café", "2 Sándwiches de jamón"];

    final String destinationLocation = "Patio";
    final String destinationTable = "Mesa 2";
    final String destinationAccount = "Cuenta de Pedro";
    return Scaffold(
      appBar: AppBar(
        title: Text('Resumen de Traslado'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Confirma los detalles del traslado antes de proceder.',
              style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
            ),
            SizedBox(height: 20.0),
            // Tarjeta de Origen
            TransferCard(
              title: "Origen",
              location: originLocation,
              table: originTable,
              account: originAccount,
              transactions: originTransactions,
            ),
            SizedBox(height: 20.0),
            // Tarjeta de Destino
            TransferCard(
              title: "Destino",
              location: destinationLocation,
              table: destinationTable,
              account: destinationAccount,
              transactions: null, // El destino no tiene transacciones aún
            ),
            Spacer(),
            // Botón de Confirmación
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Aquí puedes implementar la acción de confirmación
                  print("Traslado confirmado");
                },
                child: Text('Confirmar Traslado'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransferCard extends StatelessWidget {
  final String title;
  final String location;
  final String table;
  final String account;
  final List<String>? transactions;

  const TransferCard({
    required this.title,
    required this.location,
    required this.table,
    required this.account,
    this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text('Ubicación: $location'),
            Text('Mesa: $table'),
            Text('Cuenta: $account'),
            if (transactions != null) ...[
              SizedBox(height: 10.0),
              Text('Transacciones:'),
              for (var transaction in transactions!) Text('- $transaction'),
            ]
          ],
        ),
      ),
    );
  }
}
