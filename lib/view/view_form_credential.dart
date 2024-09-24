import 'package:app_connect_bot/models/credential.dart';
import 'package:app_connect_bot/variables/var.dart';
import 'package:flutter/material.dart';

// Le Widget ViewFormCredential
class ViewFormCredential extends StatefulWidget {
  final String headerText;
  final String description;

  const ViewFormCredential({Key? key, required this.headerText, required this.description})
      : super(key: key);

  @override
  _ViewFormCredentialState createState() => _ViewFormCredentialState();
}

class _ViewFormCredentialState extends State<ViewFormCredential> {
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs des champs de texte
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variable pour contrôler la visibilité du mot de passe
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // Initialisation des valeurs des contrôleurs avec credentialSave si elles sont disponibles
    if (credentialSave != null) {
      _ssidController.text = credentialSave.ssid;
      _passwordController.text = credentialSave.password;
    }
  }

  // Méthode de validation et soumission du formulaire
  void _validate() {
    if (_formKey.currentState!.validate()) {
      String ssid = _ssidController.text;
      String password = _passwordController.text;
      // Créer l'instance de Credential et sauvegarder
      Credential credential = Credential(ssid: ssid, password: password);
      credentialSave = credential;
      // Imprimer les informations dans la console
      print('Credential: ${credential.ssid}, ${credential.password}');
      Navigator.of(context).pop(); // Fermer le dialog après validation
    }
  }

  // Méthode pour changer la visibilité du mot de passe
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 10,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Clé pour la validation du formulaire
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/credential.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 15.0),
                  Text(
                    widget.headerText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8.0),
              // Barre de séparation
              const Divider(thickness: 2.0),
              const SizedBox(height: 8.0),
              // Description
              Text(
                widget.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20.0),
              // Formulaire SSID
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Name SSID",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _ssidController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter SSID',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a SSID';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  // Formulaire password
                  const Text(
                    "Password",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _passwordController,
                    //obscureText: true,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Changer l'icône en fonction de l'état
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: _togglePasswordVisibility, // Inverser la visibilité
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              // Boutons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _validate,
                    icon: const Icon(Icons.check),
                    label: const Text('Valider'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop(); // Fermer le dialogue
                    },
                    icon: const Icon(Icons.cancel),
                    label: const Text('Annuler'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                      backgroundColor: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Fonction pour afficher le ViewFormCredential
void showViewFormCredential(BuildContext context, String header, String description) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ViewFormCredential(headerText: header, description: description);
    },
  );
}













