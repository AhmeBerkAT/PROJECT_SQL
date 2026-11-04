# Projet PL/SQL : Gestion de Vidéothèque

Ce projet implémente les éléments demandés dans l'énoncé, incluant les **procédures**, **fonctions**, **déclencheurs**, et **requêtes SQL**, avec des scripts d'initialisation et de tests pour assurer leur bon fonctionnement.
---
## Structure des fichiers

### 1. **Dossier `insert/`**
- Contient les fichiers pour l’initialisation et l’insertion des données :
  - **`init.sql`** : Réinitialise les tables.
  - **`insert.sql`** : Lance `init.sql` suivi des inserts dans le bon ordre.

### 2. **Dossier `more_triggers/`**
- Implémente des contraintes annoncés dans mes contraintes en version texte, dans le rapport (au-delà des déclencheurs explicites de l'énoncé). 
- Inclut des tests pertinents pour vérifier leur bon fonctionnement.

### 3. **Dossier `requetesIndex/`**
- Contient :
  - **`requetes.sql`** : Les requêtes demandées dans l'énoncé.
  - Des index optimisant les performances des requêtes.

### 4. **Dossier `triggersandTests/`**
- Implémente et teste les **déclencheurs explicites** mentionnés dans l'énoncé.

### 5. **Dossier `proceduresFonctions/`**
- Contient :
  - **`procsFuncs.sql`** : Implémente les procédures et fonctions demandées dans l’énoncé, ATTENTION : NE SACHANT PAS QUAND SERA LA CORRECTION SI IL N Y A PAS DE VIDEO POPULAIRE OU DE NOUVELLE VIDEO SORTIES VOUS POUVEZ ELARGIR LES INTERVALES DES DATES DE SORTIE ET DE POPULARITE

  - **`archive_old_videos.sql`** : Contient une procédure supplémentaire permettant d’archiver périodiquement les vidéos anciennes.
  - **`insert_newSuggestions.sql`** : Contient la procédure qui permet de faire apparaitre "les nouveaux épisodes des émissions auxquelles il est abonné" dans la table de suggestions.
 Vous pouvez egalement trouver les fichiers de tests de ces derniers.

### 6. **`Dans ce dossier `**
 Pour archiver les anciennes videos, je supprime les videos qui sont archivés grace a triggerArchive.sql, il est preferable de d'abord compiler le tout ou de commencer par les tests de l'enonce. Meme si, le comportement est presque identique si vous le faites pas. C'est mieux.

 Si vous voulez lancer séparement les tests vous pouvez sinon vous pouvez tout lancer.
 - **`reinit.sql`** : lance la recréation des tables suivis par les inserts dans le bon ordre.
 - **`launchProcedureEnonce.sql`** : lance la création et tests des procedures explicités dans l'énoncé
 - **`launchTriggersEnonce.sql`** : lance la création et tests des procedures et fonctions explicités 
 - **`launchRequetes.sql`** : lance la création des indexes et les requetes.
 - **`launchMoreTriggers.sql`** : lance la création des autres triggers, contraintes
 - **`launchOtherProcedures.sql`**: lance la création de la procédure d'archivage des anciennes vidéos et celle d'insertion des suggestions basés sur l'abonnement dans la table des suggestions puis lance leurs tests
 - **`contraintesEtProcedures.sql`** : seulement pour compiler les triggers et procedures, fonctions
- **`toutSaufReInit.sql`** : compile les triggers et procedures ensuite lance les tests
---
## Scripts périodiques
- **`archive_old_videos.sql`** : à lancer périodiquement pour archiver les vidéos anciennes, comme expliqué dans le rapport.
---

## Remarques et Bonnes pratiques
### Nettoyage des archives de test
Lors des tests de suppression de vidéos, les archives de test sont nettoyées pour garantir des tests répétables :
```sql
DELETE FROM VideosArchive;
COMMIT;
EXECUTE IMMEDIATE 'DROP SEQUENCE seq_archive_id';
EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_archive_id START WITH 1 NOCACHE INCREMENT BY 1';
COMMIT;
```
Cela est fait pour nettoyer les videos testers de l'archive que j'utilise seulement pour les tests, je n'ai pas d autre entrée que les donnees de tests.
Cela n est pas necessaire quand le trigger d archivage n a pas ete encore compilé mais fonctionne dans tt les cas.

### Intervalle des dates de popularité
Lors de la correction, si aucune vidéo populaire ne semble correspondre, élargissez les intervalles de **dates de sortie** et de **popularité**.

---
## Organisation des tests
Les tests sont organisés pour couvrir :
- **Procédures et fonctions** : Exécution et validation des résultats attendus.
- **Déclencheurs** : Vérification des règles et contraintes.
- **Requêtes SQL** : Les résultats

---

## Contact
ahmet-berk.ates@etu.unistra.fr

