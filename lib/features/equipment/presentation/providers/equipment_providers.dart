import 'dart:core';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:core' as core;

import '../../data/equipment_repository_impl.dart';
import '../../domain/entities/equipment_entity.dart';
import '../../domain/entities/equipment_movement.dart';
import '../../domain/entities/incident_report.dart';
import '../../domain/repositories/equipment_repository.dart';

/// Ticket: Gp5-4/5, Gp6-1/2 — providers
final equipmentRepositoryProvider = Provider<EquipmentRepository>((ref) {
  return MockEquipmentRepository();
});

class EquipmentFilter {
  const EquipmentFilter({this.query = '', this.category, this.state});
  final core.String query;
  final EquipmentCategory? category;
  final EquipmentState? state;

  EquipmentFilter copyWith({
    core.String? query,
    EquipmentCategory? category,
    core.bool clearCategory = false,
    EquipmentState? state,
    core.bool clearState = false,
  }) => EquipmentFilter(
    query: query ?? this.query,
    category: clearCategory ? null : (category ?? this.category),
    state: clearState ? null : (state ?? this.state),
  );
}

final equipmentFilterProvider = StateProvider<EquipmentFilter>((ref) {
  return const EquipmentFilter();
});

final equipmentListProvider =
    AsyncNotifierProvider<EquipmentListNotifier, core.List<EquipmentEntity>>(
      EquipmentListNotifier.new,
    );

class EquipmentListNotifier extends AsyncNotifier<core.List<EquipmentEntity>> {
  @override
  Future<core.List<EquipmentEntity>> build() {
    final filter = ref.watch(equipmentFilterProvider);
    return ref
        .read(equipmentRepositoryProvider)
        .getEquipment(
          query: filter.query,
          category: filter.category,
          state: filter.state,
        );
  }

  Future<void> createEquipment(EquipmentEntity equipment) async {
    await ref.read(equipmentRepositoryProvider).createEquipment(equipment);
    ref.invalidateSelf();
  }

  Future<EquipmentEntity?> lookupByQr(core.String payload) {
    return ref.read(equipmentRepositoryProvider).findByQrPayload(payload);
  }
}

final equipmentMovementsProvider =
    AsyncNotifierProvider.family<
      EquipmentMovementsNotifier,
      core.List<EquipmentMovement>,
      String
    >(EquipmentMovementsNotifier.new);

class EquipmentMovementsNotifier
    extends FamilyAsyncNotifier<core.List<EquipmentMovement>, String> {
  @override
  Future<core.List<EquipmentMovement>> build(String equipmentId) {
    return ref.read(equipmentRepositoryProvider).getMovements(equipmentId);
  }

  Future<void> logMovement(EquipmentMovement movement) async {
    await ref.read(equipmentRepositoryProvider).logMovement(movement);
    ref.invalidateSelf();
    ref.invalidate(equipmentListProvider);
  }

  Future<void> reportIncident(IncidentReport report) async {
    await ref.read(equipmentRepositoryProvider).reportIncident(report);
    ref.invalidateSelf();
    ref.invalidate(equipmentListProvider);
  }
}

final frequentlyFailingProvider = FutureProvider<core.List<EquipmentEntity>>((
  ref,
) {
  return ref.read(equipmentRepositoryProvider).getFrequentlyFailing();
});
