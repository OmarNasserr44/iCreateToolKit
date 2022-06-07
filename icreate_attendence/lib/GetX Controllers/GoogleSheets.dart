import 'dart:developer';

import 'package:get/get.dart';
import 'package:gsheets/gsheets.dart';

class GoogleSheetsController extends GetxController {
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "icreate-4beec",
  "private_key_id": "00df67884d42ebd9db30350237e61055e1ab4664",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC4bKp06XYnNTVV\ntTkLE7R4UzuFuGJZ3MSUL3DhL0Bar1EAPPuP8cdjC5QmohOAm1ZVWUNBIv9qksV7\ncCAjw2FMc2OtuKFTYHGYUtK9ctueSqBakmjKYaxtkCDdJ5laTvM0d1ZPOTK/NX4l\nV6b+RSQb0LO4tVO2cOWMM3JAT2c7fu7W4KLvNXa2PtQTIsiBzoaUSXgdDqzsg3LY\nAF0exBOsSJD2p70P87YrFXCpIq1oV7MvFX87llAPjkyiL49WXMxp02QFP6I/PxIB\ntkQ5ZRsXQnR4PcEI6ejXl/MOkhftpBMYSSWahG1JgL0bR1/tIBJbiAQLlmsg2Epv\nLV7WoRmnAgMBAAECggEACxsMFrc6VLkZCZy8nySkIPzOIErOrV+kfNHwh7brNqrJ\nA20oru3d1mKLnNn0t7Fi/Qe/i4waemX1O24wmUa6NLrcHUl5eYZcwNH3+82PWRRg\nXKPlaI6CLiTYPckVLIGFlrq6+VFV83q6qnABT92FA6HJOM2+iUV6JTux3RqK+mOb\nmNqJImYDxSt2BWybNjvQe+Fu9TY20MMyGlmYFPcziHWHKpBzfz8dNqra0FjVbWv5\nzOjWIjjo+bbwYz2clWPZtcAnF7MDfiteMJIWhVjaS6ZjvtH8MVRJl1qsw1C8sBMG\naspnF6x5bVwuh+bKLrqENAdL+nh4Gqi0stFbGS6BZQKBgQDxaEh3uPOv9bE5ubxS\nFlSI9V/PutEc+Mn0Je7yebTz1kFXyvQEtWhq9W7X5oxAnWIMuv3NAysACwTDbhr6\nP6VxDEF02jwg0OQR1WzsNo1808OMz7wRa3pm85eU3VIWdlBKNy4gBPrZqe4zWioJ\n3G+Xx72GTOKp4dPjsctReNxdpQKBgQDDkpZacJh+UMVxCTcynHMqXeNok7kqb45d\n3p6KXHQwLBqDZ9vvHx5BAdEu+vr8AQAk8+fBlxcy6qDRGPc9vpDBEkSGYk5ymNIC\najeQau43H73dn2CzMdqb5LKd1AC6KAuWbJ1yGkjdWymW4nfafcBX5xS7UcKraO8Z\n//dRaPOQWwKBgQCRwOXoKyoutkgP012prkPSAVyc3m29cVT17SVND0C67ES9jhMw\n+JqX4aHQByntJVj62Le+XUhMGVsB5+uv5lesXrryo4UkRxs8zUCbigB5Op5Z2V7y\noZLgr/h4b/xNBZhKhvB5cqhGXTwtkyXImGhkGrwKZ0d/TJMTadiZU0Cx5QKBgQC6\nGE07Z7KjV4ZYxfUhEp+/a7GNfCuQxrAIgGIJtGnWwNDFw1kTE2A9aVY8RxP2IZma\nkAAyROwNRheagBAbT678GL7dxMNy5hnHtHyEzks4ZtrK/PIN8V1cQ+T2q5m5iYtl\nKpsyzPISt8E+UubLICebPUaL7AO6CVKjQd57N8uzywKBgEicF5dcKqv3ygSALPBv\naxFM1F5URx8q+CJM14ir1Xd/2x4DWbJYuUcWFReoTjHgH7+AS8LgSn7yVlql4mbF\n+PyR+ACUqjRUUwRskJ1zT/clBJr6zg8Hdmd1qAlJ8sr07VNzQAzFypFLHxOmHn2j\nCAu+5rDK2e+e635DggU/F5mb\n-----END PRIVATE KEY-----\n",
  "client_email": "googlesheets@icreate-4beec.iam.gserviceaccount.com",
  "client_id": "108417460355852668728",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/googlesheets%40icreate-4beec.iam.gserviceaccount.com"
}
  ''';
  static const _spreadSheetID = "1OsoClCHqvYBP75mpj90vGy0h4IJbKs4aXkAUaVFXutY";
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _icreatSheet;
  static Worksheet? _historySheet;

  static Future init() async {
    try {
      final spreadSheet = await _gsheets.spreadsheet(_spreadSheetID);
      _icreatSheet = await _getWorkSheet(spreadSheet, title: 'iCreate');
      _historySheet = await _getWorkSheet(spreadSheet, title: 'History');
    } on Exception catch (e) {
      log("gSheets exception $e");
    }
  }

  static Future<Worksheet> _getWorkSheet(Spreadsheet spreadsheet,
      {required String title}) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future insert(List<Map<String, dynamic>> rowList) async {
    if (_icreatSheet == null) return;
    _icreatSheet!.values.map.appendRows(rowList);
  }

  static Future insertHistory(List<Map<String, dynamic>> rowList) async {
    if (_historySheet == null) return;
    _historySheet!.values.map.appendRows(rowList);
  }
//
}
