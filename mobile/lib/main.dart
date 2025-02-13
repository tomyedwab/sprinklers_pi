import 'package:flutter/material.dart';
import 'api/api_client.dart';
import 'api/models/zone.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sprinklers Pi',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Sprinklers Pi Control'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ApiClient _apiClient = ApiClient();
  List<Zone> _zones = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadZones();
  }

  Future<void> _loadZones() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      
      final zones = await _apiClient.getZones();
      setState(() {
        _zones = zones;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleZone(String zoneId, bool newState) async {
    try {
      await _apiClient.setZoneState(zoneId, newState);
      await _loadZones(); // Reload to get updated states
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to toggle zone: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadZones,
            tooltip: 'Refresh zones',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadZones,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_zones.isEmpty) {
      return const Center(
        child: Text('No zones configured'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadZones,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _zones.length,
        itemBuilder: (context, index) {
          final zone = _zones[index];
          return Card(
            child: ListTile(
              leading: Icon(
                Icons.water_drop,
                color: zone.state ? Colors.blue : Colors.grey,
              ),
              title: Text(zone.name),
              subtitle: Text(
                'Enabled: ${zone.enabled ? 'Yes' : 'No'} | '
                'Pump: ${zone.pump ? 'Yes' : 'No'}',
              ),
              trailing: Switch(
                value: zone.state,
                onChanged: zone.enabled
                    ? (bool value) => _toggleZone('z${String.fromCharCode(97 + index)}', value)
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
