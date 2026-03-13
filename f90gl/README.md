# 🎨 **README — UI Module (GF‑Fortran‑SDK)**

```markdown
# UI Module — GF‑Fortran‑SDK

Le dossier `ui/` contient l’infrastructure nécessaire pour la future API graphique du SDK.  
Cette API permettra de créer des interfaces graphiques modernes en Fortran95 en s’appuyant sur **f90GL** (OpenGL + GLUT pour Fortran).

L’objectif est d’offrir une couche simple, portable et intuitive pour concevoir des applications graphiques, des outils internes, des dashboards et des interfaces interactives — sans exposer la complexité d’OpenGL.

---

## 🎯 Objectifs du module UI

- Fournir une API haut niveau pour créer des interfaces graphiques en Fortran95.
- Simplifier l’utilisation de f90GL en masquant :
  - la gestion des fenêtres
  - les callbacks GLUT
  - le rendu OpenGL
  - la gestion des événements
- Offrir des widgets simples :
  - boutons
  - labels
  - sliders
  - champs texte
- Intégration directe avec les modules réseau du SDK.
- Assurer une compatibilité multi‑plateforme (Windows, Linux, macOS).

---

## 🧱 Structure du dossier

```
ui/
  f90gl/          ← sources officiels + licence NIST
  build/          ← bibliothèques précompilées par plateforme
  include/        ← modules Fortran générés
  src/            ← API UI haut niveau (en développement)
  examples/       ← exemples d’utilisation
  source/         ← nist source ofiiciel
```

### 📌 `f90gl/`
Contient les sources originales de f90GL ainsi que la licence NIST.  
Ces fichiers ne doivent pas être modifiés sans documentation claire.

### 📌 `build/`
Contiendra les versions précompilées de f90GL pour chaque plateforme :

```
build/
  windows/
  linux/
  macos/
```

Les utilisateurs du SDK n’auront pas à compiler f90GL eux‑mêmes.

### 📌 `src/`
Contiendra l’API UI haut niveau, par exemple :

```fortran
call UI_Begin("Demo", 800, 600)
call UI_Label("Bonjour")
if (UI_Button("OK")) then
    call DoSomething()
end if
call UI_End()
```

### 📌`examples
Exemples complets montrant comment utiliser l’API UI avec ou sans réseau à venir.

---

## 🔧 Compilation

Le module UI sera fourni avec :

- des bibliothèques précompilées pour chaque OS
- des scripts de build simples
- une intégration automatique dans le SDK

Les utilisateurs n’auront pas à compiler f90GL.

---

## 📜 Licence

Le module UI inclut f90GL, distribué sous la licence NIST.  
Le fichier `license-nist.txt` doit être conservé tel quel.

---

## 🔮 État actuel

- Intégration des sources f90GL : ✔
- Préparation du dossier `build/` : en cours
- Conception de l’API UI haut niveau : en développement
- Exemples graphiques : à venir

Ce module deviendra une brique essentielle du GF‑Fortran‑SDK.


---

Guillaume Foisy
