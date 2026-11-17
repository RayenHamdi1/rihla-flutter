# Journal IA — TP6 (Copilot)

Nom : Rayen Hamdi Dépôt :  Dépôt : https://github.com/RayenHamdi1/tp2-cross-plateform

Au moins 4 lignes, dont au moins une suggestion **modifiée** ou **rejetée**.

| # | Outil Copilot | Demande / intention | Décision | Pourquoi |
|---|---|---|---|---|
| 1 | Complétion | Compléter `basculer` dans `FavorisModel` | Modifiée | `notifyListeners()` a été vérifié et conservé pour reconstruire les écrans. |
| 2 | Chat inline | Transformer `FavoriteButton` en `StatelessWidget` | Modifiée | L’état local a été supprimé ; le bouton utilise maintenant `watch` et `read`. |
| 3 | `/explain` | Expliquer la différence entre `watch` et `read` | Acceptée | `watch` écoute les changements, tandis que `read` sert à agir sans écouter. |
| 4 | Chat inline | Ajouter l’onglet Favoris et son badge | Modifiée | Le badge est masqué lorsque le nombre de favoris est égal à zéro. |
| 5 | Message de commit | Proposer les messages des trois commits de la Partie 2 | Modifiée | Les messages ont été adaptés au format demandé par le TP : `feat(favoris): ...`. |

Outil : Complétion · Chat inline (Ctrl+I) · /explain · Message de commit (✨)
Décision : Acceptée · Modifiée · Rejetée

## /explain : watch et read (partie 2.4)
Ma reformulation, en une phrase : `watch` écoute le modèle et reconstruit le widget,
tandis que `read` lit le modèle pour agir sans créer d'écoute.

## Questions de compréhension
**Partie 1** — Que se passe-t-il pour `main` si je casse l'application sur `feature/favoris` ?

`main` reste inchangée, car les modifications sont isolées dans la branche
`feature/favoris`. Le problème rejoint `main` seulement si la Pull Request est
acceptée et fusionnée.

**Partie 2**
1. Pourquoi `FavoriteButton` peut-il être un `StatelessWidget` alors que son affichage change ?

   Parce que l'état est stocké dans `FavorisModel`. `context.watch` reconstruit
   le bouton lorsque le modèle est modifié.

2. Pourquoi ranger les favoris par `id` plutôt que dans un `Set<Destination>` ?

   L'identifiant reste stable lorsque les destinations sont rechargées depuis
   l'API. Un `Set<Destination>` dépendrait de l'égalité entre les objets.

3. Pourquoi les favoris disparaissent-ils après un hot restart ?

   Parce que les favoris sont conservés uniquement en mémoire dans le Provider.
   Le hot restart recrée le modèle vide ; aucune sauvegarde persistante n'est
   encore utilisée.


**Partie 4**
1. Pourquoi la Partie 3 n'a-t-elle produit aucun conflit ?
Parce qu'une seule branche avait modifié le code. `main` n'avait pas changé depuis la création de `feature/favoris`, donc Git a pu fusionner tout seul.
2. Que se passe-t-il si j'oublie de supprimer un marqueur `=======` ?
Le marqueur reste dans le fichier Dart comme du texte invalide, donc l'application ne compile plus.