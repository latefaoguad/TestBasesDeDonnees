# TestBasesDeDonnees


Que contiennent les tables dans les schéma louis_v005? Expliquer la structure relationelle et la fonction de chaque table.

Table "ada_002"

id (uuid, clé primaire, non nulle) : Identifiant unique de la ligne.
token_id (uuid, nullable) : Clé étrangère faisant référence à la table "token".
embedding (public.vector, nullable) : Champ pour le stockage de données vectorielles.

Table "chunk"

id (uuid, clé primaire, non nulle) : Identifiant unique de la ligne.
title (text, nullable) : Titre du chunk.
text_content (text, nullable) : Contenu textuel du chunk.

Table "crawl"

id (uuid, clé primaire, non nulle) : Identifiant unique de la ligne.
url (text, nullable) : URL de la page web crawlée.
title (text, nullable) : Titre de la page.
lang (bpchar(2), nullable) : Langue de la page.
last_crawled (text, nullable) : Date et heure de la dernière extraction.
last_updated (text, nullable) : Date et heure de la dernière mise à jour.
last_updated_date (date, nullable) : Date de la dernière mise à jour.
md5hash (bpchar(32), nullable) : Hash MD5 de contenu.

Table "default_chunks"

url (text, nullable) : URL de la page.
id (uuid, nullable) : Identifiant unique.
chunk_id (uuid, nullable) : Clé étrangère faisant référence à la table "chunk".

Table "html_content"

content (text, non nulle) : Contenu HTML.
md5hash (bpchar(32), non nulle) : Hash MD5 de contenu.

Table "html_content_to_chunk"

md5hash (bpchar(32), non nulle) : Hash MD5 de contenu.
chunk_id (uuid, non nulle) : Clé étrangère faisant référence à la table "chunk".

Table "link"

source_crawl_id (uuid, non nulle) : Clé étrangère faisant référence à la table "crawl" (ID source).
destination_crawl_id (uuid, non nulle) : Clé étrangère faisant référence à la table "crawl" (ID destination).

Table "query"

id (uuid, clé primaire, non nulle) : Identifiant unique de la ligne.
query (text, nullable) : Requête textuelle.
tokens (_int4, nullable) : Liste de jetons (entiers).
embedding (public.vector, nullable) : Données vectorielles.
encoding (text, par défaut 'cl100k_base'::text) : Encodage.
model (text, par défaut 'ada_002'::text) : Modèle.
result (jsonb, nullable) : Résultat de la requête.

Table "score"

entity_id (uuid, nullable) : Identifiant d'entité.
score (float8, nullable) : Score.
score_type (louis_v005."score_type", nullable) : Type de score.

Table "token"

id (uuid, clé primaire, non nulle) : Identifiant unique de la ligne.
chunk_id (uuid, nullable) : Clé étrangère faisant référence à la table "chunk".
tokens (_int4, nullable) : Liste de jetons (entiers).
encoding (louis_v005."encoding", nullable) : Encodage.

Quelle distribution prennent les valeurs de longueur du contenu?

Il peut y avoir des pages web courtes, longues, de longueur moyenne, etc. La distribution pourrait être normale (la plupart des pages ont des longueurs moyennes, 
avec quelques-unes très courtes et très longues) ou présenter d'autres formes en fonction des données spécifiques. Plus la longueur est petite plus elle se rapproche de zéro et plus elle est grandre plus elle se rapproche de 1.


Expliquer le calcul en fonction de la distribution spécifique des valeurs de longueurs de html_content script

Si la longueur du contenu est égale à zéro (c'est-à-dire s'il n'y a pas de contenu), alors le score est défini à 0.0 (le score le plus bas possible).

Sinon, si la longueur du contenu est différente de zéro, le score est calculé en fonction de la place relative de cette longueur parmi toutes les longueurs de contenu dans la table. Plus simplement, cela signifie que les lignes avec des longueurs de contenu plus courtes obtiennent un score plus bas, tandis que les lignes avec des longueurs de contenu plus longues obtiennent un score plus élevé.

Le calcul "percent_rank() OVER (ORDER BY (length(h.content)))" classe les lignes en fonction de la longueur du contenu et attribue un score en pourcentage basé sur la position de chaque ligne dans l'ordre croissant des longueurs de contenu. Par exemple, si une ligne a une longueur de contenu plus courte que la plupart des autres, elle recevra un score plus bas, et si elle a une longueur de contenu plus longue, elle obtiendra un score plus élevé.

Cela permet d'attribuer des scores relatifs en fonction de la longueur du contenu, ce qui peut être utile pour classer ou noter les données en fonction de leur pertinence ou de leur importance.


Expliquer et discuter de la performance de votre fonction recherche

En raison de la limite de 10 lignes à afficher, la fonction rechercher est performante. Par contre, si je devais augmenter mon nombre limite de ligne afficher alors l'operation LIKE devient couteuse au niveau des performance.
