import '../entities/equipment_entity.dart';
import '../entities/equipment_movement.dart';
import '../entities/incident_report.dart';

/// Ticket: Gp5-4/5, Gp6-1/2 — repository contract
abstract class EquipmentRepository {
  Future<List<EquipmentEntity>> getEquipment({
    String? query,
    EquipmentCategory? category,
    EquipmentState? state,
  });
  Future<EquipmentEntity> createEquipment(EquipmentEntity equipment);
  Future<EquipmentEntity> updateEquipment(EquipmentEntity equipment);

  /// Gp6-1: QR-based lookup — reuses the scanner service from module 3.
  Future<EquipmentEntity?> findByQrPayload(String qrPayload);

  Future<List<EquipmentMovement>> getMovements(String equipmentId);
  Future<void> logMovement(EquipmentMovement movement);

  /// Gp6-2: frequently failing equipment (failureCount above threshold)
  Future<List<EquipmentEntity>> getFrequentlyFailing({int threshold = 3});

  Future<IncidentReport> reportIncident(IncidentReport report);
}
