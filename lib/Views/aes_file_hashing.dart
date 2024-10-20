import 'dart:io';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class FileEncryptionScreen extends StatefulWidget {
  @override
  _FileEncryptionScreenState createState() => _FileEncryptionScreenState();
}

class _FileEncryptionScreenState extends State<FileEncryptionScreen> {
  File? _selectedFile;
  String? _encryptedData;
  String? _decryptedData;
  final _encryptionKey = encrypt.Key.fromUtf8('my_32_byte_long_encryption_key'); // AES requires 32 bytes key for AES-256
  final _iv = encrypt.IV.fromLength(16); // AES Initialization vector (16 bytes for AES)
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Encryption & Decryption'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _selectFile,
              child: Text('Select File'),
            ),
            if (_selectedFile != null) Text('Selected File: ${_selectedFile!.path}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _encryptFile,
              child: Text('Encrypt File'),
            ),
            if (_encryptedData != null)
              Text('File Encrypted! (Data in Base64)\n${_encryptedData!.substring(0, 30)}...'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _decryptFile,
              child: Text('Decrypt File'),
            ),
            if (_decryptedData != null) Text('File Decrypted: $_decryptedData'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveEncryptedFile,
              child: Text('Save Encrypted File'),
            ),
            ElevatedButton(
              onPressed: _saveDecryptedFile,
              child: Text('Save Decrypted File'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _encryptFile() async {
    if (_selectedFile == null) return;
    
    final encrypter = encrypt.Encrypter(encrypt.AES(_encryptionKey)); // AES encrypter
    final fileContent = await _selectedFile!.readAsBytes(); // Read file data
    
    final encrypted = encrypter.encryptBytes(fileContent, iv: _iv); // Encrypt file data
    
    setState(() {
      _encryptedData = encrypted.base64; // Store Base64 encoded data
    });
  }

  Future<void> _decryptFile() async {
    if (_encryptedData == null) return;
    
    final encrypter = encrypt.Encrypter(encrypt.AES(_encryptionKey)); // AES encrypter
    
    final decrypted = encrypter.decrypt64(_encryptedData!, iv: _iv); // Decrypt data
    
    setState(() {
      _decryptedData = decrypted; // Store decrypted data as string
    });
  }

  Future<void> _saveEncryptedFile() async {
    if (_encryptedData == null) return;
    
    final directory = await getExternalStorageDirectory();
    final filePath = '${directory!.path}/encrypted_file.txt';
    final file = File(filePath);

    await file.writeAsString(_encryptedData!); // Save the Base64-encoded encrypted data
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Encrypted file saved: $filePath')));
  }

  Future<void> _saveDecryptedFile() async {
    if (_decryptedData == null) return;
    
    final directory = await getExternalStorageDirectory();
    final filePath = '${directory!.path}/decrypted_file.txt';
    final file = File(filePath);

    await file.writeAsString(_decryptedData!); // Save the decrypted data
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Decrypted file saved: $filePath')));
  }
}
