import 'package:flutter/material.dart';
import 'package:state_button/state_button.dart';

void main() => runApp(const _App());

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StateButton Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF6366F1),
        useMaterial3: true,
      ),
      home: const StateButtonDemo(),
    );
  }
}

/// Showcases three distinct [StateButton] variants:
///
/// 1. Primary filled  — solid indigo, failure flow
/// 2. Outlined        — white + border, success flow
/// 3. Pill with icon  — dark rounded, success flow
class StateButtonDemo extends StatefulWidget {
  const StateButtonDemo({super.key});

  @override
  State<StateButtonDemo> createState() => _StateButtonDemoState();
}

class _StateButtonDemoState extends State<StateButtonDemo> {
  // One controller per button — each manages its own phase independently.
  final _primaryCtrl = SbController();
  final _outlineCtrl = SbController();
  final _pillCtrl = SbController();

  @override
  void dispose() {
    // Always dispose every controller to release internal ValueNotifiers.
    _primaryCtrl.dispose();
    _outlineCtrl.dispose();
    _pillCtrl.dispose();
    super.dispose();
  }

  // ── Handlers ──────────────────────────────────────────────────────────────

  Future<void> _onSubmit() async {
    _primaryCtrl.setLoading();
    await Future.delayed(const Duration(seconds: 2));
    // Simulate a failed API call.
    _primaryCtrl.setFailure();
  }

  Future<void> _onUpload() async {
    _outlineCtrl.setLoading();
    await Future.delayed(const Duration(seconds: 2));
    // Simulate a successful upload.
    _outlineCtrl.setSuccess();
  }

  Future<void> _onDeploy() async {
    _pillCtrl.setLoading();
    await Future.delayed(const Duration(milliseconds: 1500));
    // Simulate a successful deployment.
    _pillCtrl.setSuccess();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('StateButton'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 1. Primary filled ──────────────────────────────────────────
            _SectionLabel('1 · Primary filled'),
            const SizedBox(height: 10),
            StateButton(
              loaderType: SbLoaderType.progressiveDots,
              controller: _primaryCtrl,
              width: double.infinity,
              onPressed: _onSubmit,
              child: const Text(
                'Submit',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 36),

            // ── 2. Outlined / custom decoration ───────────────────────────
            _SectionLabel('2 · Outlined'),
            const SizedBox(height: 10),
            StateButton(
              controller: _outlineCtrl,
              width: double.infinity,
              // Keep white background so the outline is visible in all phases.
              backgroundColor: Colors.white,
              successColor: const Color(0xFF22C55E),
              failureColor: const Color(0xFFEF4444),
              // Use coloured icons so they're readable on the white background.
              successIconColor: const Color(0xFF22C55E),
              failureIconColor: const Color(0xFFEF4444),
              loadingColor: const Color(0xFF6366F1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF6366F1), width: 1.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
              onPressed: _onUpload,
              child: const Text(
                'Upload File',
                style: TextStyle(color: Color(0xFF6366F1), fontSize: 15),
              ),
            ),

            const SizedBox(height: 36),

            // ── 3. Pill with icon + label ──────────────────────────────────
            _SectionLabel('3 · Pill with icon'),
            const SizedBox(height: 10),
            Center(
              child: StateButton(
                controller: _pillCtrl,
                // borderRadius: 999 produces a fully-rounded pill shape.
                borderRadius: 999,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                backgroundColor: const Color(0xFF0F172A),
                autoResetDuration: const Duration(seconds: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
                onPressed: _onDeploy,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.rocket_launch_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Deploy',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helper ────────────────────────────────────────────────────────────────────

/// Small section label used to identify each demo variant.
class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Color(0xFF6B7280),
        letterSpacing: 0.4,
      ),
    );
  }
}
