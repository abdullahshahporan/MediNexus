import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'doctor_dashboard_page.dart';

class DoctorLoginFaceDetectionScreen extends StatefulWidget {
  const DoctorLoginFaceDetectionScreen({super.key});

  @override
  State<DoctorLoginFaceDetectionScreen> createState() =>
      _DoctorLoginFaceDetectionScreenState();
}

class _DoctorLoginFaceDetectionScreenState
    extends State<DoctorLoginFaceDetectionScreen>
    with TickerProviderStateMixin {
  bool _isCapturing = false;
  bool _isProcessing = false;
  int _countdown = 3;
  Timer? _countdownTimer;
  late AnimationController _pulseController;
  late AnimationController _scanController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scanAnimation;
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();

    // Pulse animation for camera button
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Scan animation
    _scanController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scanAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );

    // Initialize camera and auto-start
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
          orElse: () => cameras.first,
        );

        _cameraController = CameraController(
          frontCamera,
          ResolutionPreset.medium,
          enableAudio: false,
        );

        await _cameraController!.initialize();
        if (mounted) {
          setState(() => _isCameraInitialized = true);
          // Auto-start capture after camera initializes
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) _startCapture();
          });
        }
      }
    } catch (e) {
      debugPrint('Camera error: $e');
      // If camera fails, still proceed with animation
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) _startCapture();
        });
      }
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _pulseController.dispose();
    _scanController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  void _startCapture() {
    setState(() {
      _isCapturing = true;
      _countdown = 3;
    });

    _pulseController.stop();
    _scanController.repeat();

    // Countdown timer
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
        _processFaceDetection();
      }
    });
  }

  void _processFaceDetection() {
    setState(() {
      _isCapturing = false;
      _isProcessing = true;
    });

    _scanController.stop();

    // Simulate face processing
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _navigateToDashboard();
      }
    });
  }

  void _navigateToDashboard() {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const DoctorDashboardPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ),
              ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    const Color(0xFF0D47A1),
                    const Color(0xFF1A237E),
                    Colors.black,
                  ]
                : [
                    const Color(0xFF42A5F5),
                    const Color(0xFF1976D2),
                    const Color(0xFF0D47A1),
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed:
                          _isCapturing || _isProcessing
                              ? null
                              : () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    const Text(
                      'Face Verification',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      _isProcessing
                          ? 'Verifying your identity...'
                          : _isCapturing
                              ? 'Hold still...'
                              : 'Position your face in the circle',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Camera Circle with Animations
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer glow ring
                        if (!_isProcessing)
                          AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Container(
                                width: 280 * _pulseAnimation.value,
                                height: 280 * _pulseAnimation.value,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 2,
                                  ),
                                ),
                              );
                            },
                          ),

                        // Main camera circle
                        Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                            border: Border.all(
                              color: _isCapturing || _isProcessing
                                  ? Colors.green
                                  : Colors.white,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: (_isCapturing || _isProcessing
                                        ? Colors.green
                                        : Colors.white)
                                    .withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Camera Preview
                              if (_isCameraInitialized && _cameraController != null)
                                ClipOval(
                                  child: SizedBox(
                                    width: 242,
                                    height: 242,
                                    child: CameraPreview(_cameraController!),
                                  ),
                                )
                              else if (!_isCapturing && !_isProcessing)
                                const Icon(
                                  Icons.camera_alt_rounded,
                                  size: 80,
                                  color: Colors.white,
                                ),

                              // Countdown
                              if (_isCapturing && _countdown > 0)
                                TweenAnimationBuilder<double>(
                                  duration: const Duration(milliseconds: 300),
                                  tween: Tween(begin: 0.8, end: 1.2),
                                  builder: (context, scale, child) {
                                    return Transform.scale(
                                      scale: scale,
                                      child: Text(
                                        '$_countdown',
                                        style: const TextStyle(
                                          fontSize: 100,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  },
                                ),

                              // Processing indicator
                              if (_isProcessing)
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 4,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      'Processing...',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),

                              // Scan line animation
                              if (_isCapturing)
                                ClipOval(
                                  child: AnimatedBuilder(
                                    animation: _scanAnimation,
                                    builder: (context, child) {
                                      return Transform.translate(
                                        offset: Offset(
                                            0, 125 * _scanAnimation.value),
                                        child: Container(
                                          height: 3,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.transparent,
                                                Colors.green.withOpacity(0.8),
                                                Colors.transparent,
                                              ],
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.green
                                                    .withOpacity(0.5),
                                                blurRadius: 10,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Corner markers
                        if (!_isProcessing) ...[
                          _buildCornerMarker(
                              -90, -90, Alignment.topLeft, false),
                          _buildCornerMarker(
                              90, -90, Alignment.topRight, true),
                          _buildCornerMarker(
                              -90, 90, Alignment.bottomLeft, true),
                          _buildCornerMarker(
                              90, 90, Alignment.bottomRight, false),
                        ],
                      ],
                    ),

                    const SizedBox(height: 60),

                    // Status indicator
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: _isCapturing || _isProcessing
                            ? Colors.green.withOpacity(0.2)
                            : Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _isCapturing || _isProcessing
                              ? Colors.green
                              : Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_isProcessing)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          else
                            Icon(
                              _isCapturing
                                  ? Icons.camera_rounded
                                  : Icons.face_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          const SizedBox(width: 12),
                          Text(
                            _isProcessing
                                ? 'Analyzing...'
                                : _isCapturing
                                    ? 'Scanning...'
                                    : 'Auto-detecting face',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCornerMarker(
      double left, double top, Alignment alignment, bool flip) {
    return Positioned(
      left: left > 0 ? left : null,
      right: left < 0 ? -left : null,
      top: top > 0 ? top : null,
      bottom: top < 0 ? -top : null,
      child: Transform.rotate(
        angle: flip ? 3.14159 : 0,
        child: CustomPaint(
          size: const Size(30, 30),
          painter: CornerMarkerPainter(
            color: _isCapturing ? Colors.green : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildInstruction(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class CornerMarkerPainter extends CustomPainter {
  final Color color;

  CornerMarkerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw L-shaped corner
    canvas.drawLine(Offset.zero, Offset(size.width, 0), paint);
    canvas.drawLine(Offset.zero, Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
