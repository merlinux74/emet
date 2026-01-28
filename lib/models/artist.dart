class Artist {
  final int id;
  final String name;
  final String img;
  final String imgPx;
  final String email;
  final String compleanno;
  final String genere;
  final String etichetta;
  final String biografia;
  final String? youtube;
  final String? spotify;
  final String? appleMusic;
  final String? instagram;
  final String? tiktok;
  final String? versoBibbia;

  Artist({
    required this.id,
    required this.name,
    required this.img,
    required this.imgPx,
    required this.email,
    required this.compleanno,
    required this.genere,
    required this.etichetta,
    required this.biografia,
    this.youtube,
    this.spotify,
    this.appleMusic,
    this.instagram,
    this.tiktok,
    this.versoBibbia,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      name: json['name'] ?? 'Artista',
      img: json['img'] ?? '',
      imgPx: json['img_px'] ?? '',
      email: json['email'] ?? '',
      compleanno: json['compleanno'] ?? '',
      genere: json['genere'] ?? '',
      etichetta: json['etichetta'] ?? '',
      biografia: json['biografia'] ?? '',
      youtube: json['lyoutube'],
      spotify: json['lspotify'],
      appleMusic: json['lapplemusic'],
      instagram: json['linstagram'],
      tiktok: json['ltiktok'],
      versoBibbia: json['versobibbia'],
    );
  }

  String get imageUrl {
    if (imgPx.isNotEmpty) {
      if (imgPx.startsWith('http')) return imgPx;
      return 'https://app.wipstaf.net/storage/uploads/artisti/$imgPx';
    }
    if (img.isNotEmpty) {
      if (img.startsWith('http')) return img;
      return 'https://app.wipstaf.net/storage/$img';
    }
    return '';
  }
}
