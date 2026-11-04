DROP TABLE UserAbonnement CASCADE CONSTRAINT;
DROP TABLE UserPreference  CASCADE CONSTRAINT;
DROP TABLE Video  CASCADE CONSTRAINT;
DROP TABLE Emission  CASCADE CONSTRAINT;
DROP TABLE Categorie CASCADE CONSTRAINT ;
DROP TABLE Utilisateur CASCADE CONSTRAINT ;
DROP TABLE Favoris CASCADE CONSTRAINT ;
DROP TABLE Historique CASCADE CONSTRAINT ;
DROP TABLE VideosArchive CASCADE CONSTRAINT ;
DROP TABLE VideoSuggestion CASCADE CONSTRAINT ;


--leur pseudo doit etre unique 
CREATE TABLE Utilisateur (
    user_id INT PRIMARY KEY,
    login VARCHAR2(50) NOT NULL UNIQUE,
    mdp VARCHAR2(255) NOT NULL,
    prenom VARCHAR2(50) NOT NULL,
    nom VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL, 
    date_naissance DATE NOT NULL ,
    abo_newsletter INT DEFAULT 0 CHECK ( abo_newsletter IN (0,1)),
    pays_origine VARCHAR(50) NOT NULL,
    CONSTRAINT email_check CHECK (INSTR(email, '@') > 0)
);



--ma selection de Categorie
CREATE TABLE Categorie(
    nom_categorie VARCHAR2(100)PRIMARY KEY CHECK ( nom_categorie IN ('comedy', 'drama', 'kdrama', 'horror', 'romantic', 'sci-fi'))
);

--les Emission 
CREATE TABLE Emission(
    
    emission_id INT PRIMARY KEY,
    titre VARCHAR2(200) NOT NULL,
    description VARCHAR2(4000) NOT NULL,
    nom_categorie VARCHAR2(100) NOT NULL,
    
    CONSTRAINT unique_title unique(titre),
    CONSTRAINT fk_shows_cat FOREIGN KEY (nom_categorie) REFERENCES Categorie(nom_categorie) ON DELETE CASCADE
);



-- dans la table pas plusieurs episodes avec le meme numero pour un meme show
CREATE TABLE Video(
    video_id INT PRIMARY KEY,
    emission_id INT NOT NULL,
    episode_num INT NOT NULL,
    titre VARCHAR2(100) NOT NULL,
    description VARCHAR2(4000) DEFAULT '',
    duree INT CHECK (duree > 0) NOT NULL,
    image_format VARCHAR(20) NOT NULL CHECK (image_format IN ('8k','4k','uhd','hd')),
    pays_origine VARCHAR(50) NOT NULL,
    date_sortie DATE NOT NULL ,
    multilangage INT DEFAULT 0 CHECK (multilangage IN (0,1)),
    date_publication TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_video_emission FOREIGN KEY (emission_id) REFERENCES Emission(emission_id) ON DELETE CASCADE ,
    CONSTRAINT unique_video_emission UNIQUE (emission_id, episode_num),
    CONSTRAINT unique_emission_title UNIQUE (emission_id, titre)
);

--chaque preference d'Utilisateur a un id
--on ne peut avoir deux fois la preference d'un category pour un meme Utilisateur.
CREATE TABLE UserPreference (

    preference_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    nom_categorie VARCHAR2(100) NOT NULL,
    CONSTRAINT fk_upref_uid FOREIGN KEY (user_id) REFERENCES Utilisateur(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_upref_cat FOREIGN KEY (nom_categorie) REFERENCES Categorie(nom_categorie),
    CONSTRAINT unique_user_categorie UNIQUE (user_id, nom_categorie)
);


--un utilisateur peut s'inscrire a une emission mais pas plusieurs fois a un meme show donc unique couple user_id, emission_id 
CREATE TABLE UserAbonnement (

    abo_id  INT PRIMARY KEY,
    user_id INT NOT NULL,
    emission_id INT NOT NULL,
    CONSTRAINT fk_uAbonnement_uid FOREIGN KEY (user_id) REFERENCES Utilisateur(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_uAbonnement_emissionId FOREIGN KEY (emission_id) REFERENCES Emission(emission_id)ON DELETE CASCADE,
    CONSTRAINT unique_uid_emission_id UNIQUE (user_id, emission_id)
);

--un utilisateur peut avoir plusieurs Video, episodes en Favoris mais pas deux fois la meme d'ou l'unique couple user_id, video_id
CREATE TABLE Favoris (

    favoris_id INT  PRIMARY KEY,
    user_id INT NOT NULL,
    video_id INT NOT NULL,
    CONSTRAINT fk_fav_uid FOREIGN KEY (user_id) REFERENCES Utilisateur(user_id) ON DELETE CASCADE  ,
    CONSTRAINT fk_video FOREIGN KEY (video_id) REFERENCES Video(video_id)  ON DELETE CASCADE ,
    CONSTRAINT u_uid_video_id UNIQUE (user_id, video_id)
    
);

--on stocke l'historique des utilisateurs, chaque ajout par defaut est ajoute avec view date a l instant de l ajout
--plusieurs fois une video peut etre revue donc pas d unique couple cette fois 
CREATE TABLE Historique (

    historique_id  INT PRIMARY KEY,
    user_id INT NOT NULL,
    video_id INT NOT NULL,
    date_visionnement TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_vhistory_uid FOREIGN KEY (user_id) REFERENCES Utilisateur(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_vhistory_video FOREIGN KEY (video_id) REFERENCES Video(video_id) ON DELETE CASCADE

);

--en plus des booleans dans Video, on garde la date quand l'video a ete archive 
CREATE TABLE VideosArchive (
    archived_id INT PRIMARY KEY,
    video_id INT NOT NULL,
    emission_id INT NOT NULL,
    episode_num INT NOT NULL,
    titre VARCHAR2(100) NOT NULL,
    description VARCHAR2(4000) NOT NULL,
    duree INT CHECK (duree > 0) NOT NULL,
    image_format VARCHAR(20) NOT NULL,
    pays_origine VARCHAR(50) NOT NULL,
    date_sortie DATE  NOT NULL,
    multilangage INT CHECK ( multilangage IN (0,1)) NOT NULL,
    date_archivage TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_publication TIMESTAMP NOT NULL
);
--Je penses qu on peut sugerer plusieurs fois une video, ou video (on a presente les Video dans un table Video) d ou pas d unique couple cette fois-ci
--suggestion cree au moment de l insertion
CREATE TABLE VideoSuggestion (
    suggestion_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    video_id INT NOT NULL,
    
    date_creation DATE DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES Utilisateur(user_id) ON DELETE CASCADE,
    FOREIGN KEY (video_id) REFERENCES Video(video_id) ON DELETE CASCADE

);

