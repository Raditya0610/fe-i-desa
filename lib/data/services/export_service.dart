import 'dart:io';
import 'package:excel/excel.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class ExportService {
  /// Export villagers data to Excel format
  static Future<String?> exportToExcel(List<Map<String, dynamic>> data) async {
    try {
      final excel = Excel.createExcel();
      final sheet = excel['Data Penduduk'];

      // Add headers
      final headers = [
        'NIK',
        'Nama Lengkap',
        'Jenis Kelamin',
        'Tempat Lahir',
        'Tanggal Lahir',
        'Umur',
        'Agama',
        'Pendidikan',
        'Pekerjaan',
        'Status Perkawinan',
        'Status Hubungan',
        'Kewarganegaraan',
        'Nama Ayah',
        'Nama Ibu',
      ];

      for (var i = 0; i < headers.length; i++) {
        final cell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
        );
        cell.value = TextCellValue(headers[i]);
        cell.cellStyle = CellStyle(
          bold: true,
          backgroundColorHex: ExcelColor.blue,
          fontColorHex: ExcelColor.white,
        );
      }

      // Add data rows
      for (var rowIndex = 0; rowIndex < data.length; rowIndex++) {
        final villager = data[rowIndex];
        final rowData = [
          villager['nik'] ?? '',
          villager['name'] ?? villager['nama_lengkap'] ?? '',
          villager['jenis_kelamin'] ?? '',
          villager['tempat_lahir'] ?? '',
          villager['tanggal_lahir'] ?? '',
          villager['age']?.toString() ?? '',
          villager['agama'] ?? '',
          villager['pendidikan'] ?? '',
          villager['pekerjaan'] ?? '',
          villager['status_perkawinan'] ?? '',
          villager['status_hubungan'] ?? '',
          villager['kewarganegaraan'] ?? '',
          villager['nama_ayah'] ?? '',
          villager['nama_ibu'] ?? '',
        ];

        for (var colIndex = 0; colIndex < rowData.length; colIndex++) {
          final cell = sheet.cell(
            CellIndex.indexByColumnRow(
              columnIndex: colIndex,
              rowIndex: rowIndex + 1,
            ),
          );
          cell.value = TextCellValue(rowData[colIndex]);
        }
      }

      // Auto-fit columns
      for (var i = 0; i < headers.length; i++) {
        sheet.setColumnWidth(i, 20);
      }

      // Save file
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final filePath = '${directory.path}/data_penduduk_$timestamp.xlsx';

      final fileBytes = excel.save();
      if (fileBytes != null) {
        final file = File(filePath);
        await file.writeAsBytes(fileBytes);
        return filePath;
      }

      return null;
    } catch (e) {
      print('Error exporting to Excel: $e');
      return null;
    }
  }

  /// Export villagers data to CSV format
  static Future<String?> exportToCsv(List<Map<String, dynamic>> data) async {
    try {
      final List<List<dynamic>> rows = [];

      // Add headers
      rows.add([
        'NIK',
        'Nama Lengkap',
        'Jenis Kelamin',
        'Tempat Lahir',
        'Tanggal Lahir',
        'Umur',
        'Agama',
        'Pendidikan',
        'Pekerjaan',
        'Status Perkawinan',
        'Status Hubungan',
        'Kewarganegaraan',
        'Nama Ayah',
        'Nama Ibu',
      ]);

      // Add data rows
      for (final villager in data) {
        rows.add([
          villager['nik'] ?? '',
          villager['name'] ?? villager['nama_lengkap'] ?? '',
          villager['jenis_kelamin'] ?? '',
          villager['tempat_lahir'] ?? '',
          villager['tanggal_lahir'] ?? '',
          villager['age']?.toString() ?? '',
          villager['agama'] ?? '',
          villager['pendidikan'] ?? '',
          villager['pekerjaan'] ?? '',
          villager['status_perkawinan'] ?? '',
          villager['status_hubungan'] ?? '',
          villager['kewarganegaraan'] ?? '',
          villager['nama_ayah'] ?? '',
          villager['nama_ibu'] ?? '',
        ]);
      }

      // Convert to CSV
      final csv = const ListToCsvConverter().convert(rows);

      // Save file
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final filePath = '${directory.path}/data_penduduk_$timestamp.csv';

      final file = File(filePath);
      await file.writeAsString(csv);

      return filePath;
    } catch (e) {
      print('Error exporting to CSV: $e');
      return null;
    }
  }

  /// Export family cards data to Excel format
  static Future<String?> exportFamilyCardsToExcel(
      List<Map<String, dynamic>> data) async {
    try {
      final excel = Excel.createExcel();
      final sheet = excel['Data Kartu Keluarga'];

      // Add headers
      final headers = [
        'No KK',
        'Kepala Keluarga',
        'Jumlah Anggota',
      ];

      for (var i = 0; i < headers.length; i++) {
        final cell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
        );
        cell.value = TextCellValue(headers[i]);
        cell.cellStyle = CellStyle(
          bold: true,
          backgroundColorHex: ExcelColor.green,
          fontColorHex: ExcelColor.white,
        );
      }

      // Add data rows
      for (var rowIndex = 0; rowIndex < data.length; rowIndex++) {
        final familyCard = data[rowIndex];
        final rowData = [
          familyCard['nik'] ?? '',
          familyCard['nama_lengkap'] ?? '',
          familyCard['alamat'] ?? '',
          familyCard['jumlah_anggota']?.toString() ?? '0',
        ];

        for (var colIndex = 0; colIndex < rowData.length; colIndex++) {
          final cell = sheet.cell(
            CellIndex.indexByColumnRow(
              columnIndex: colIndex,
              rowIndex: rowIndex + 1,
            ),
          );
          cell.value = TextCellValue(rowData[colIndex]);
        }
      }

      // Auto-fit columns
      sheet.setColumnWidth(0, 25); // No KK
      sheet.setColumnWidth(1, 25); // Kepala Keluarga
      sheet.setColumnWidth(3, 18); // Jumlah Anggota

      // Save file
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final filePath = '${directory.path}/data_kartu_keluarga_$timestamp.xlsx';

      final fileBytes = excel.save();
      if (fileBytes != null) {
        final file = File(filePath);
        await file.writeAsBytes(fileBytes);
        return filePath;
      }

      return null;
    } catch (e) {
      print('Error exporting family cards to Excel: $e');
      return null;
    }
  }

  /// Export family cards data to CSV format
  static Future<String?> exportFamilyCardsToCsv(
      List<Map<String, dynamic>> data) async {
    try {
      final List<List<dynamic>> rows = [];

      // Add headers
      rows.add([
        'No KK',
        'Kepala Keluarga',
        'Jumlah Anggota',
      ]);

      // Add data rows
      for (final familyCard in data) {
        rows.add([
          familyCard['nik'] ?? '',
          familyCard['nama_lengkap'] ?? '',
          familyCard['alamat'] ?? '',
          familyCard['jumlah_anggota']?.toString() ?? '0',
        ]);
      }

      // Convert to CSV
      final csv = const ListToCsvConverter().convert(rows);

      // Save file
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final filePath = '${directory.path}/data_kartu_keluarga_$timestamp.csv';

      final file = File(filePath);
      await file.writeAsString(csv);

      return filePath;
    } catch (e) {
      print('Error exporting family cards to CSV: $e');
      return null;
    }
  }
}
