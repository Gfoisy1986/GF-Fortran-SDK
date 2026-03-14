# Relation avec le reste du SDK

Flux logique :

- `deps/` → bibliothèques natives (C, externes)
- `src/wrappers/c/` → adaptation C
- `src/wrappers/fortran/` → FFI Fortran
- `src/modules/` → logique Fortran regroupée
- `src/api/` → API haut niveau
- `src/core/` → apps/démos internes
- `examples/` → exemples simples pour les utilisateurs

Les wrappers ne doivent **pas** contenir de logique métier :  
ils servent uniquement à connecter proprement C ↔ Fortran.
