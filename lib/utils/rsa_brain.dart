import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:crypto/crypto.dart'; // For hashing

class RSAUtils {
  static AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAKeyPair(
      SecureRandom secureRandom, int bitLength) {
    final keyGen = RSAKeyGenerator()
      ..init(ParametersWithRandom(
        RSAKeyGeneratorParameters(BigInt.from(65537), bitLength, 64),
        secureRandom,
      ));
    
    // Cast the generated key pair to RSAPublicKey and RSAPrivateKey
    final pair = keyGen.generateKeyPair();
    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(
      pair.publicKey as RSAPublicKey,
      pair.privateKey as RSAPrivateKey,
    );
  }

static SecureRandom getSecureRandom() {
  final secureRandom = FortunaRandom();
  final random = Random.secure();
  final seedSource = List<int>.generate(32, (_) => random.nextInt(256));
  final seed = sha256.convert(Uint8List.fromList(seedSource)).bytes;
  secureRandom.seed(KeyParameter(Uint8List.fromList(seed)));
  return secureRandom;
}


  static Uint8List rsaEncrypt(String plaintext, RSAPublicKey publicKey) {
    final encryptor = RSAEngine()
      ..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));
    final plainBytes = Uint8List.fromList(utf8.encode(plaintext));
    return encryptor.process(plainBytes);
  }

  static String rsaDecrypt(Uint8List ciphertext, RSAPrivateKey privateKey) {
    final decryptor = RSAEngine()
      ..init(false, PrivateKeyParameter<RSAPrivateKey>(privateKey));
    final decrypted = decryptor.process(ciphertext);
    return utf8.decode(decrypted);
  }
}
