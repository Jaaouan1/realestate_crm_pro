import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

class BiometricLoginWidget extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onBiometricLogin;

  const BiometricLoginWidget({
    super.key,
    required this.isLoading,
    required this.onBiometricLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider
        Row(
          children: [
            Expanded(
              child: Divider(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.3),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Quick Access',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.3),
              ),
            ),
          ],
        ),

        SizedBox(height: 3.h),

        // Biometric Login Button
        GestureDetector(
          onTap: isLoading ? null : onBiometricLogin,
          child: Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.fingerprint,
                size: 10.w,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),

        SizedBox(height: 2.h),

        Text(
          'Use Face ID or Touch ID',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),

        Text(
          'Tap to authenticate with biometrics',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}