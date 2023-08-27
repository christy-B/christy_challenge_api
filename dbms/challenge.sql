/* La définition du schéma */

USE challenge;

CREATE TABLE INSTANCE (
   id INT NOT NULL AUTO_INCREMENT,
   adresse_ip VARCHAR(255) NOT NULL,
   login VARCHAR(255) NOT NULL,
   mdp VARCHAR(255) NOT NULL,
   PRIMARY KEY (id),
   UNIQUE KEY (adresse_ip, login)
);

CREATE TABLE PROMO(
   id INT NOT NULL AUTO_INCREMENT,
   nom VARCHAR(255) NOT NULL,
   PRIMARY KEY (id),
   UNIQUE KEY (nom)
);

CREATE TABLE SCORE (
   id INT NOT NULL AUTO_INCREMENT,
   points INT NOT NULL,
   PRIMARY KEY (id),
   CHECK (points >= 0)
);

CREATE TABLE SESSION (
   id INT NOT NULL AUTO_INCREMENT,
   nom VARCHAR(255) NOT NULL,
   id_promo INT NOT NULL,
   PRIMARY KEY (id),
   FOREIGN KEY (id_promo) REFERENCES PROMO(id)
);

CREATE TABLE REPONSE (
   id INT NOT NULL AUTO_INCREMENT,
   intitule VARCHAR(255) NOT NULL,
   point INT NOT NULL,
   PRIMARY KEY (id),
   CHECK (point >= 0)
);

CREATE TABLE QUESTION (
   id INT NOT NULL AUTO_INCREMENT,
   intitule VARCHAR(255) NOT NULL,
   id_session INT,
   id_reponse INT,
   PRIMARY KEY (id),
   FOREIGN KEY (id_session) REFERENCES SESSION(id),
   FOREIGN KEY (id_reponse) REFERENCES REPONSE(id)
);

CREATE TABLE USER (
   id INT NOT NULL AUTO_INCREMENT,
   email VARCHAR(255) NOT NULL,
   nom VARCHAR(255),
   prenom VARCHAR(255),
   scope VARCHAR(255) NOT NULL CHECK (scope IN ('admin', 'user')),
   id_promo INT,
   id_instance INT,
   id_score INT,
   PRIMARY KEY (id),
   FOREIGN KEY (id_promo) REFERENCES PROMO(id),
   FOREIGN KEY (id_instance) REFERENCES INSTANCE(id),
   FOREIGN KEY (id_score) REFERENCES SCORE(id)
);

CREATE INDEX idx_promo_id ON SESSION (id_promo);
CREATE INDEX idx_session_id ON QUESTION (id_session);
CREATE INDEX idx_reponse_id ON QUESTION (id_reponse);
CREATE INDEX idx_promo_id ON USER (id_promo);
CREATE INDEX idx_instance_id ON USER (id_instance);
CREATE INDEX idx_score_id ON USER (id_score);

ALTER TABLE INSTANCE ADD CONSTRAINT unique_instance UNIQUE (adresse_ip);
ALTER TABLE PROMO ADD CONSTRAINT unique_nom UNIQUE (nom);
ALTER TABLE SCORE ADD CONSTRAINT positive_points CHECK (points >= 0);
ALTER TABLE SESSION ADD CONSTRAINT fk_session_promo FOREIGN KEY (id_promo) REFERENCES PROMO(id);
ALTER TABLE QUESTION ADD CONSTRAINT fk_question_session FOREIGN KEY (id_session) REFERENCES SESSION(id);
ALTER TABLE QUESTION ADD CONSTRAINT fk_question_reponse FOREIGN KEY (id_reponse) REFERENCES REPONSE(id);
ALTER TABLE USER ADD CONSTRAINT fk_user_promo FOREIGN KEY (id_promo) REFERENCES PROMO(id);
ALTER TABLE USER ADD CONSTRAINT fk_user_instance FOREIGN KEY (id_instance) REFERENCES INSTANCE(id);
ALTER TABLE USER ADD CONSTRAINT fk_user_score FOREIGN KEY (id_score) REFERENCES SCORE(id);
ALTER TABLE USER ADD CONSTRAINT unique_email UNIQUE (email);

drop trigger if exists before_insert_user;

create trigger before_insert_user
before insert
on USER for each row set new.email = lower(trim(new.email));