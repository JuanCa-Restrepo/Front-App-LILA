/// Evidencia (archivo) adjunta a un caso.
///
/// `urlArchivo` apunta al recurso ya alojado en Google Drive — el
/// backend nunca recibe el binario, solo la URL pública resultante.
class Evidencia {
  final String idEvidencia;
  final String idCaso;
  final String? tipoArchivo;
  final String urlArchivo;
  final DateTime? fechaSubida;

  const Evidencia({
    required this.idEvidencia,
    required this.idCaso,
    this.tipoArchivo,
    required this.urlArchivo,
    this.fechaSubida,
  });
}
