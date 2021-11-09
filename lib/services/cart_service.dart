import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
String userID = FirebaseAuth.instance.currentUser!.uid;
CollectionReference cart =
    db.collection('UserInformations').doc(userID).collection('UserCart');

class CartService {
  Future<void> ajouterAuPanier(
      {image, prix, taille, marque, nom, description, id}) async {
    var quantiteAlreadyInCart = 1;

    await cart.doc(id).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        quantiteAlreadyInCart = documentSnapshot["quantite"] + 1;
      }
    });

    cart.doc(id).set({
      "image": image,
      "prix": prix,
      "taille": taille,
      "marque": marque,
      "nom": nom,
      "description": description,
      "id": id,
      "quantite": quantiteAlreadyInCart
    });
  }

  Stream<QuerySnapshot> getPanier() {
    return cart.snapshots();
  }

  void supprimerArticlePanier(id) {
    cart.doc(id).delete();
  }
}
