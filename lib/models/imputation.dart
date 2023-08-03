class Imputation {
  int? id;
  DateTime date;
  String projet;
  String phase;
  String tache;
  double hours;

  Imputation(
      {this.id,
      required this.date,
      required this.projet,
      required this.phase,
      required this.tache,
      required this.hours});
}
