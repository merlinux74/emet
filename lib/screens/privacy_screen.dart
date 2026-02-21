import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            title: Text(
              'PRIVACY & COOKIES',
              style: GoogleFonts.ruslanDisplay(
                color: theme.colorScheme.onSurface,
                fontSize: 20,
                letterSpacing: 1.5,
              ),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionTitle(context, 'Informativa sulla Privacy'),
                _buildText(context, 
                  'Benvenuto in Emet. La tua privacy è importante per noi. Questa informativa spiega come gestiamo i tuoi dati quando utilizzi la nostra applicazione musicale.'
                ),
                
                _buildSectionTitle(context, '1. Dati Raccolti'),
                _buildText(context, 
                  'Emet non richiede la creazione di un account utente e non raccoglie dati personali identificabili (PII) come nome, email o numero di telefono sui propri server.\n\n'
                  'L\'applicazione potrebbe raccogliere dati anonimi relativi all\'utilizzo dell\'app, come i brani riprodotti e le interazioni con l\'interfaccia, al solo scopo di migliorare l\'esperienza utente.'
                ),

                _buildSectionTitle(context, '2. Servizi di Terze Parti'),
                _buildText(context, 
                  'Questa applicazione utilizza servizi di terze parti per fornire contenuti multimediali:\n\n'
                  '• YouTube API Services: I contenuti video e audio sono forniti tramite YouTube. Utilizzando questa applicazione, accetti i Termini di Servizio di YouTube (https://www.youtube.com/t/terms) e le Norme sulla Privacy di Google (https://policies.google.com/privacy).'
                ),

                _buildSectionTitle(context, '3. Cookie e Archiviazione Locale'),
                _buildText(context, 
                  'Emet utilizza tecnologie di archiviazione locale sul tuo dispositivo ("Cookie tecnici" o "Local Storage") per:\n'
                  '• Memorizzare le tue preferenze di tema (Chiaro/Scuro).\n'
                  '• Salvare lo stato di riproduzione per riprendere l\'ascolto.\n'
                  '• Gestire la cache delle immagini per ridurre il consumo di dati.\n\n'
                  'Non utilizziamo cookie di profilazione o tracciamento pubblicitario.'
                ),

                _buildSectionTitle(context, '4. Contatti'),
                _buildText(context, 
                  'Per domande riguardanti questa informativa sulla privacy, puoi contattarci all\'indirizzo email ufficiale del ministero Emet.'
                ),

                const SizedBox(height: 40),
                Center(
                  child: Text(
                    'Ultimo aggiornamento: Febbraio 2026',
                    style: GoogleFonts.poppins(
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 80), // Spazio per la bottom bar
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color: theme.primaryColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildText(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: theme.colorScheme.onSurface.withOpacity(0.8),
        fontSize: 14,
        height: 1.6,
      ),
    );
  }
}
