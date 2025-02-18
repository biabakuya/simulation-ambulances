# Simulation des Ambulances dans une Ville

## Description
Ce projet utilise la plateforme GAMA pour modéliser et simuler la gestion des services d'ambulances dans un environnement urbain. L'objectif principal est d'optimiser la répartition des ambulances pour réduire les temps de réponse en cas d'urgence médicale. Le projet intègre des données spatiales et des modèles réalistes pour analyser les itinéraires, les performances, et les défis liés à la gestion des ressources médicales.

---

## Fonctionnalités
- **Création d'un réseau routier basé sur OpenStreetMap** : Importation et traitement des données via QGIS.
- **Simulation dynamique des ambulances** :
  - Gestion des trajets en fonction des appels d'urgence.
  - Modélisation des variations de trafic.
- **Analyse des performances** :
  - Temps de réponse moyen des ambulances.
  - Taux d'occupation et activités des ambulances.
  - Analyse des zones de forte demande.

---

## Objectifs
1. **Évaluation comparative** : Comparer les performances des itinéraires et des ambulances.
2. **Stratégies d'optimisation** : Proposer des améliorations pour réduire les temps d'intervention.
3. **Impact du trafic** : Étudier l'effet des variations de trafic sur les temps de réponse.

---

## Prérequis
### Logiciels nécessaires
- **QGIS** (version 3.34.4 ou supérieure) pour la gestion des données SIG.
- **GAMA** (version 1.9.3) pour la simulation multi-agents.

### Données
- Fichiers shapefiles (créés via QGIS) représentant :
  - Le réseau routier.
  - Les infrastructures urbaines (hôpitaux, résidences, etc.).

---

## Procédure : Configuration et Utilisation
### Étapes dans QGIS
1. **Installation de QGIS** : Téléchargez et installez QGIS depuis [le site officiel](https://www.qgis.org/).
2. **Création d'un nouveau projet** :
   - Ouvrez QGIS et créez un nouveau projet.
3. **Ajout des cartes OpenStreetMap** :
   - Accédez à **Web > QuickMapServices > OSM** pour ajouter une carte de base.
4. **Activation des extensions nécessaires** :
   - Activez "QuickMap Services" et "QuickOSM" dans **Extensions > Installer/Gérer les Extensions**.
5. **Création d'une couche shapefile** :
   - Allez dans **Couche > Créer une couche > Nouvelle couche shapefile** et dessinez les zones d'intérêt.
6. **Exportation des fichiers shapefiles** :
   - Enregistrez les fichiers shapefiles créés pour les importer dans GAMA.

### Étapes dans GAMA
1. **Importation des fichiers shapefiles** :
   - Chargez les fichiers shapefiles créés dans votre projet GAMA.
2. **Configuration des paramètres** :
   - Modifiez les noms des fichiers et les chemins d'accès dans le script GAMA pour qu'ils correspondent à vos données.
3. **Lancement de la simulation** :
   - Cliquez sur **Run** pour démarrer la simulation.

---

## Structure du Projet
- `data/` : Contient les fichiers shapefiles nécessaires à la simulation.
- `models/` : Fichiers `.gaml` pour le modèle et la simulation.
- `results/` : Résultats générés, incluant des graphiques et des cartes.
- `README.md` : Documentation du projet.

---

## Résultats attendus
- **Carte 3D de la zone simulée** :
  - Visualisation des déplacements des ambulances et des infrastructures urbaines.
- **Taux d'occupation des ambulances** :
  - Analyse des périodes d'activité et d'inactivité.
- **Temps moyen de transport** :
  - Identification des pics de congestion ou des zones problématiques.
- **Répartition des activités** :
  - Proportions de transport de patients, attente, et autres tâches.

---
### Interface de simulation



![simulation](image/simulation.png)

- **En bleu** : Valeurs réelles
- **En orange** : Prédictions du modèle CNN+LSTM
- **En vert** : Prédictions du modèle Transformer

## Analyse et Perspectives
### Analyse
- **Temps de transport moyen** :
  - Identification des périodes où les temps de réponse augmentent en raison de la demande ou du trafic.
- **Distribution des missions** :
  - Équilibrage efficace des tâches entre les ambulances.
- **Impact des stratégies d'optimisation** :
  - Réduction significative des temps d'attente pour les patients.

### Perspectives
- **Optimisation dynamique** :
  - Introduction de stratégies adaptatives pour repositionner les ambulances en temps réel.
- **Augmentation des ressources** :
  - Simulation avec un nombre accru d'ambulances pour les périodes de forte demande.
- **Évaluation continue** :
  - Utilisation des résultats de simulation pour former les équipes et ajuster les politiques de gestion.

---

## Contributions
Les contributions sont les bienvenues ! Pour participer :
1. Clonez le projet.
2. Créez une branche pour vos modifications :
   ```bash
   git checkout -b nouvelle-fonctionnalite

