import 'package:etfi_point/Components/providers/stateProviders.dart';
import 'package:etfi_point/Components/providers/userStateProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Home2 extends ConsumerWidget {
  const Home2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUserSignedIn = ref.watch(userStateProvider);
    final int? idUsuarioActual = ref.watch(getCurrentUserProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Cambiar color predeterminado app"),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(appThemeColorProvider.notifier)
                    .update((state) => !state);
              },
              child: const Text("Cambiar tema"),
            ),
            ElevatedButton(
              onPressed: () {
                if (isUserSignedIn) {
                  print("Logueado : $idUsuarioActual");
                } else {
                  print("No logueado");
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PerfilPrincipal2()),
                );
              },
              child: const Text("Go to perfil"),
            )
          ],
        ),
      ),
    );
  }
}

class PerfilPrincipal2 extends ConsumerWidget {
  const PerfilPrincipal2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idUsuarioActual = ref.watch(getCurrentUserProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            print("imprecion despues: $idUsuarioActual");
          },
          child: Text("Precionar "),
        ),
      ),
    );
  }
}
