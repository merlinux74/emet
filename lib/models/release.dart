class Release {
  final int id;
  final String nome;
  final String img;
  final String imgpx;
  final List<Brano> brani;

  Release({
    required this.id,
    required this.nome,
    required this.img,
    required this.imgpx,
    required this.brani,
  });

  factory Release.fromJson(Map<String, dynamic> json) {
    List<Brano> braniList = [];
    
    // Controlla se 'brani' è presente direttamente
    if (json['brani'] != null) {
      var listBrani = json['brani'] as List;
      for (var b in listBrani) {
        braniList.add(Brano.fromJson(b));
      }
    } 
    // Altrimenti controlla in 'relazione' (struttura API di Emet)
    else if (json['relazione'] != null) {
      var relazioneList = json['relazione'] as List;
      for (var rel in relazioneList) {
        if (rel['brani'] != null) {
          var listBrani = rel['brani'] as List;
          for (var b in listBrani) {
            braniList.add(Brano.fromJson(b));
          }
        }
      }
    }
    
    return Release(
      id: json['id'],
      nome: json['titolo'] ?? 'Senza Titolo',
      img: json['img'] ?? '',
      imgpx: json['imgpx'] ?? '',
      brani: braniList,
    );
  }

  String get imageUrl {
    // Priorità a imgpx con il percorso fornito dall'utente
    if (imgpx.isNotEmpty) {
      if (imgpx.startsWith('http')) return imgpx;
      return 'https://app.wipstaf.net/storage/uploads/album/px/$imgpx';
    }
    
    // Fallback su img standard
    if (img.isNotEmpty) {
      if (img.startsWith('http')) return img;
      return 'https://app.wipstaf.net/storage/$img';
    }
    
    return '';
  }
}

class Brano {
  final int id;
  final String titolo;
  final String? videoUrl;
  final String? youtubeId;

  Brano({
    required this.id,
    required this.titolo,
    this.videoUrl,
    this.youtubeId,
  });

  factory Brano.fromJson(Map<String, dynamic> json) {
    return Brano(
      id: json['id'],
      titolo: json['titolo'] ?? 'Traccia senza titolo',
      videoUrl: json['video'],
      youtubeId: json['link'], // Il campo 'link' contiene l'ID YouTube
    );
  }
}
