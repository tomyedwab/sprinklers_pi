import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/zone_provider.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sprinklers Pi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zonesAsync = ref.watch(zonesNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sprinklers Pi'),
      ),
      body: zonesAsync.when(
        data: (zones) => ListView.builder(
          itemCount: zones.length,
          itemBuilder: (context, index) {
            final zone = zones[index];
            return ListTile(
              title: Text(zone.name),
              subtitle: Text(zone.description ?? ''),
              trailing: Switch(
                value: zone.isEnabled,
                onChanged: (value) {
                  ref.read(zonesNotifierProvider.notifier)
                     .toggleZone(zone.id, value);
                },
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
