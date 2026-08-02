/// Existing Supabase / Postgres table names.
/// Mirrors the project schema (`animal_name`). Do not rename here without
/// confirming the table is exposed under `public` in the Supabase dashboard.
class DbTables {
  DbTables._();

  static const String animalName = 'animal_name';
}
