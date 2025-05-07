import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_3/presentation/providers/imc_form_provider.dart';
import 'package:flutter_application_3/presentation/pages/page_check_past_register/page_check.dart';


class HistoryDrawer extends StatelessWidget {
  const HistoryDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final form = context.watch<ImcFormProvider>();
    final colors = Theme.of(context).colorScheme;

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(50)),
      ),
      width: 300,
      backgroundColor: colors.surfaceContainerHighest,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Text(
              "Historial de IMC",
              style: TextStyle(
                fontSize: 20,
                color: colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: form.history.isEmpty
                ? Center(
                    child: Text(
                      "No hay registros",
                      style: TextStyle(color: colors.onSurface),
                    ),
                  )
                : ListView.builder(
                    
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    itemCount: form.history.length,
                    itemBuilder: (context, index) {
                      final result = form.history[index];
                      return Dismissible(
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (_) async {
                          return await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              icon: Icon(Icons.warning, color: colors.error, size: 40),
                              iconColor: colors.errorContainer,
                              surfaceTintColor: colors.surface,
                              title: Text(
                                "Eliminar registro",
                                style: TextStyle(
                                  color: colors.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: const Text("¿Estás seguro de eliminar este registro?"),
                              actionsAlignment: MainAxisAlignment.spaceBetween,
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  style: TextButton.styleFrom(
                                    foregroundColor: colors.primary,
                                  ),
                                  child: const Text("Cancelar"),
                                ),
                                FilledButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: colors.error,
                                    foregroundColor: colors.onError,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                  ),
                                  child: const Text("Eliminar"),
                                ),
                              ],
                            ),
                          );
                        },
                        background: Container(
                          color: colors.error.withValues(alpha: 0.5),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.delete_forever,
                            color: colors.onError,
                            size: 30,
                          ),
                        ),
                        key: Key(result.timestamp.toString()),
                        onDismissed: (_) => form.deleteRecord(index),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                            color: form.getResultColor(result.imcValue).withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(16)
                          ),
                          child: ListTile(
                            
                            onTap:  () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => PageCheck(result: result),
                                ),
                              );
                            },
                            leading: Icon(
                              result.userProfile.gender == 'male' 
                                ? Icons.male 
                                : Icons.female,
                              color: result.userProfile.gender == 'male'
                                  ? Colors.blue
                                  : Colors.pink,
                            ),
                            title: Text("IMC: ${result.formattedImcValue}"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(result.healthMessage),
                                Text(
                                  "Edad: ${result.userProfile.age.toInt()} años • ${DateFormat('dd/MM/yyyy').format(result.timestamp)}",
                                  style: TextStyle(
                                    color: colors.onSurface.withValues(alpha:0.6),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Divider(color: colors.outline),
          Padding(
            padding: const EdgeInsets.all(20),
            child: FilledButton.icon(
              onPressed: form.history.isEmpty 
                  ? null 
                  : () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("¿Borrar historial?"),
                          content: const Text("¿Estás seguro de eliminar todos los registros?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Cancelar"),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: FilledButton.styleFrom(
                                backgroundColor: colors.error,
                                foregroundColor: colors.onError,
                              ),
                              child: const Text("Borrar todo"),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        form.clearHistory();
                      }
                    },
              style: FilledButton.styleFrom(
                backgroundColor: colors.error,
                foregroundColor: colors.onError,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              icon: const Icon(Icons.delete_forever),
              label: const Text("Borrar Historial",style: TextStyle(
                fontWeight: FontWeight.w500
              ),),
            ),
          ),
        ],
      ),
    );
  }
}