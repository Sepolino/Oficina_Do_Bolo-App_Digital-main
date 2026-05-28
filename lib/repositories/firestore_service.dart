import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUserProfile({
    required String uid,
    required String username,
    required String email,
    required String telefone,
  }) async {
    if (uid.isEmpty) return;

    try {
      await _db.collection('usuarios').doc(uid).set({
        'username': username,
        'email': email,
        'telefone': telefone,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (_) {
      // Não interrompe o cadastro se não for possível salvar o perfil.
    }
  }

  Future<String?> fetchPromotion() async {
    try {
      final query = await _db.collection('promocoes').limit(1).get();
      if (query.docs.isEmpty) {
        final defaultPromo = {
          'titulo': 'Promoção automática',
          'mensagem': 'Comece agora e ganhe 10% de desconto no seu primeiro bolo!',
          'createdAt': FieldValue.serverTimestamp(),
        };
        await _db.collection('promocoes').add(defaultPromo);
        return defaultPromo['mensagem']?.toString();
      }

      final data = query.docs.first.data();
      return data['mensagem']?.toString() ?? data['titulo']?.toString();
    } catch (_) {
      return null;
    }
  }

  Future<void> logTransaction({
    required String userId,
    required String userEmail,
    required double total,
    required String metodo,
  }) async {
    try {
      await _db.collection('transacoes').add({
        'userId': userId,
        'userEmail': userEmail,
        'total': total,
        'metodo': metodo,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {
      // Não interrompe o pedido se não conseguir salvar a transação.
    }
  }
}
