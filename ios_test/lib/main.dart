import 'package:flutter/material.dart';
import 'package:google_navigation_flutter/google_navigation_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const NavigationTestPage(),
    );
  }
}

class NavigationTestPage extends StatefulWidget {
  const NavigationTestPage({super.key});

  @override
  State<NavigationTestPage> createState() => _NavigationTestPageState();
}

class _NavigationTestPageState extends State<NavigationTestPage> {
  bool _navigationSessionInitialized = false;
  bool _isInitializing = false;
  String _status = 'Ready to initialize navigation';
  bool _isNavigationStarted = false;
  String _sdkVersion = 'Loading SDK version...';

  @override
  void initState() {
    super.initState();
    _loadSdkVersion();
  }

  Future<void> _loadSdkVersion() async {
    try {
      final version = await GoogleMapsNavigator.getNavSDKVersion();
      setState(() {
        _sdkVersion = 'Google Navigation SDK v$version';
      });
    } catch (e) {
      setState(() {
        _sdkVersion = 'Google Navigation SDK (version unavailable)';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps Navigation Test'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // SDK Version at the top
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    _sdkVersion,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Main content - centered and stable
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        _navigationSessionInitialized
                            ? Icons.navigation
                            : Icons.navigation_outlined,
                        size: 80,
                        color: _navigationSessionInitialized ? Colors.green : Colors.grey,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Text(
                          _status,
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // Buttons with consistent width
                      SizedBox(
                        width: 280, // Fixed width for all button containers
                        child: _buildButtonContent(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (!_navigationSessionInitialized && !_isInitializing) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _initializeNavigationSession,
              child: const Text('Initialize Navigation Session'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _openAppSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Open App Settings'),
            ),
          ),
        ],
      );
    }
    
    if (_isInitializing) {
      return const Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Initializing...'),
        ],
      );
    }
    
    if (_navigationSessionInitialized && !_isNavigationStarted) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _startNavigation,
              child: const Text('Start Navigation to Sample Location'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _cleanup,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Cleanup Navigation'),
            ),
          ),
        ],
      );
    }
    
    if (_isNavigationStarted) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _stopNavigation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Stop Navigation'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _cleanup,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Cleanup Navigation'),
            ),
          ),
        ],
      );
    }
    
    return const SizedBox.shrink();
  }

  Future<void> _requestLocationPermission() async {
    setState(() {
      _status = 'Checking current location permission status...';
    });

    // Check current status first
    final currentStatus = await Permission.location.status;
    setState(() {
      _status =
          'Current permission status: $currentStatus. Now requesting permission...';
    });

    final PermissionStatus locationPermission = await Permission.location
        .request();

    setState(() {
      if (locationPermission == PermissionStatus.granted) {
        _status =
            'Location permission granted! Ready to initialize navigation.';
      } else if (locationPermission == PermissionStatus.denied) {
        _status =
            'Location permission denied. Please allow location access for navigation.';
      } else if (locationPermission == PermissionStatus.permanentlyDenied) {
        _status =
            'Location permission permanently denied. This usually means the app was previously denied. Please go to Settings > Privacy & Security > Location Services > This App and enable location access.';
      } else {
        _status = 'Location permission status: $locationPermission';
      }
    });

    if (locationPermission != PermissionStatus.granted) {
      throw Exception('Location permission not granted: $locationPermission');
    }
  }

  Future<void> _openAppSettings() async {
    await openAppSettings();
  }

  Future<void> _initializeNavigationSession() async {
    setState(() {
      _isInitializing = true;
      _status = 'Requesting location permissions...';
    });

    try {
      // Request location permission first
      await _requestLocationPermission();

      setState(() {
        _status =
            'Location permission granted. Checking terms and conditions...';
      });

      // Check and show terms if needed
      if (!await GoogleMapsNavigator.areTermsAccepted()) {
        setState(() {
          _status = 'Showing terms and conditions dialog...';
        });
        final accepted = await GoogleMapsNavigator.showTermsAndConditionsDialog(
          'Navigation Test App',
          'Test Company',
        );
        if (!accepted) {
          throw Exception('Terms and conditions not accepted');
        }
      }

      setState(() {
        _status = 'Initializing navigation session...';
      });

      // Initialize navigation session
      await GoogleMapsNavigator.initializeNavigationSession(
        taskRemovedBehavior: TaskRemovedBehavior.continueService,
      );

      setState(() {
        _navigationSessionInitialized = true;
        _isInitializing = false;
        _status =
            'Navigation session initialized successfully! Ready to start navigation.';
      });
    } catch (e) {
      setState(() {
        _isInitializing = false;
        _status = 'Failed to initialize navigation: $e';
      });
    }
  }

  Future<void> _startNavigation() async {
    try {
      setState(() {
        _status = 'Setting destination...';
      });

      // Create a sample destination (Google HQ in Mountain View)
      final destination = NavigationWaypoint.withLatLngTarget(
        title: 'Google HQ',
        target: const LatLng(latitude: 37.4220656, longitude: -122.0840897),
      );

      // Create destinations object
      final destinations = Destinations(
        waypoints: [destination],
        displayOptions: NavigationDisplayOptions(),
      );

      setState(() {
        _status = 'Building route...';
      });

      // Set destinations
      final routeStatus = await GoogleMapsNavigator.setDestinations(
        destinations,
      );

      if (routeStatus == NavigationRouteStatus.statusOk) {
        // Start guidance
        await GoogleMapsNavigator.startGuidance();

        setState(() {
          _isNavigationStarted = true;
          _status =
              'Navigation started! Guidance is active. This is a background navigation session.';
        });
      } else {
        setState(() {
          _status = 'Failed to build route. Status: $routeStatus';
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Failed to start navigation: $e';
      });
    }
  }

  Future<void> _stopNavigation() async {
    try {
      await GoogleMapsNavigator.stopGuidance();
      setState(() {
        _isNavigationStarted = false;
        _status = 'Navigation stopped. Session is still active.';
      });
    } catch (e) {
      setState(() {
        _status = 'Failed to stop navigation: $e';
      });
    }
  }

  Future<void> _cleanup() async {
    try {
      if (_isNavigationStarted) {
        await GoogleMapsNavigator.stopGuidance();
      }
      await GoogleMapsNavigator.cleanup();
      setState(() {
        _navigationSessionInitialized = false;
        _isNavigationStarted = false;
        _status = 'Navigation session cleaned up. Ready to initialize again.';
      });
    } catch (e) {
      setState(() {
        _status = 'Failed to cleanup navigation: $e';
      });
    }
  }

  @override
  void dispose() {
    if (_navigationSessionInitialized) {
      GoogleMapsNavigator.cleanup();
    }
    super.dispose();
  }
}
