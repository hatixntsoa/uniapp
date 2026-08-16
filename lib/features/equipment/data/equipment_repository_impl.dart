import 'package:uuid/uuid.dart';

import '../domain/entities/equipment_entity.dart';
import '../domain/entities/equipment_movement.dart';
import '../domain/entities/incident_report.dart';
import '../domain/repositories/equipment_repository.dart';

/// Ticket: Gp5-4/5, Gp6-1/2 — mock in-memory implementation.
/// Status: mocked. Replace with Dio calls to /equipment, /equipment/:id/movements,
/// /equipment/lookup?code=, /incidents once backend is available.
class MockEquipmentRepository implements EquipmentRepository {
  final List<EquipmentEntity> _equipment = [
    const EquipmentEntity(
      id: 'eq-1',
      inventoryCode: 'INV-VP-001',
      name: 'Vidéoprojecteur Epson',
      category: EquipmentCategory.audiovisuel,
      roomName: 'Salle B12',
      state: EquipmentState.fonctionnel,
      responsibleName: 'Yacine Ouali',
      failureCount: 1,
    ),
    const EquipmentEntity(
      id: 'eq-2',
      inventoryCode: 'INV-PC-014',
      name: 'PC Labo Réseaux #14',
      category: EquipmentCategory.informatique,
      roomName: 'Salle Labo 2',
      state: EquipmentState.enPanne,
      responsibleName: 'Yacine Ouali',
      failureCount: 4,
    ),
    const EquipmentEntity(
      id: 'eq-3',
      inventoryCode: 'INV-SW-002',
      name: 'Switch réseau 24 ports',
      category: EquipmentCategory.reseau,
      roomName: 'Salle Serveur',
      state: EquipmentState.maintenance,
      responsibleName: 'Yacine Ouali',
      failureCount: 5,
    ),
  ];

  final Map<String, List<EquipmentMovement>> _movements = {
    'eq-1': [
      EquipmentMovement(
        id: 'mv-1',
        equipmentId: 'eq-1',
        type: MovementType.sortie,
        date: DateTime.now().subtract(const Duration(days: 5)),
        actorName: 'Karim Haddad',
        note: 'Utilisation salle B12',
      ),
    ],
  };

  final List<IncidentReport> _incidents = [];

  @override
  Future<List<EquipmentEntity>> getEquipment({
    String? query,
    EquipmentCategory? category,
    EquipmentState? state,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _equipment.where((e) {
      if (query != null && query.trim().isNotEmpty) {
        final q = query.toLowerCase();
        if (!e.name.toLowerCase().contains(q) &&
            !e.inventoryCode.toLowerCase().contains(q)) {
          return false;
        }
      }
      if (category != null && e.category != category) return false;
      if (state != null && e.state != state) return false;
      return true;
    }).toList();
  }

  @override
  Future<EquipmentEntity> createEquipment(EquipmentEntity equipment) async {
    _equipment.add(equipment);
    _movements.putIfAbsent(equipment.id, () => []);
    return equipment;
  }

  @override
  Future<EquipmentEntity> updateEquipment(EquipmentEntity equipment) async {
    final i = _equipment.indexWhere((e) => e.id == equipment.id);
    if (i != -1) _equipment[i] = equipment;
    return equipment;
  }

  @override
  Future<EquipmentEntity?> findByQrPayload(String qrPayload) async {
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      return _equipment.firstWhere((e) => e.inventoryCode == qrPayload.trim());
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<EquipmentMovement>> getMovements(String equipmentId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.unmodifiable(_movements[equipmentId] ?? const []);
  }

  @override
  Future<void> logMovement(EquipmentMovement movement) async {
    final list = _movements.putIfAbsent(movement.equipmentId, () => []);
    list.insert(0, movement);
    if (movement.type == MovementType.panne) {
      final i = _equipment.indexWhere((e) => e.id == movement.equipmentId);
      if (i != -1) {
        _equipment[i] = _equipment[i].copyWith(
          state: EquipmentState.enPanne,
          failureCount: _equipment[i].failureCount + 1,
        );
      }
    }
  }

  @override
  Future<List<EquipmentEntity>> getFrequentlyFailing({
    int threshold = 3,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _equipment.where((e) => e.failureCount >= threshold).toList();
  }

  @override
  Future<IncidentReport> reportIncident(IncidentReport report) async {
    _incidents.add(report);
    await logMovement(
      EquipmentMovement(
        id: const Uuid().v4(),
        equipmentId: report.equipmentId,
        type: MovementType.panne,
        date: report.reportedAt,
        actorName: report.reporterName,
        note: report.description,
      ),
    );
    return report;
  }
}
