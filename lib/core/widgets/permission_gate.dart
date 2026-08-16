import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/permission_service.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

/// Ticket: Gp3-3 — wraps any widget/action and hides it if the current
/// user's role lacks the required permission. Used across feature screens
/// instead of ad-hoc `if (user.role == ...)` checks.
class PermissionGate extends ConsumerWidget {
  const PermissionGate({
    super.key,
    required this.permission,
    required this.child,
    this.fallback,
  });

  final AppPermission permission;
  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    if (user == null) return fallback ?? const SizedBox.shrink();
    final allowed = PermissionService.can(user.role, permission);
    return allowed ? child : (fallback ?? const SizedBox.shrink());
  }
}
