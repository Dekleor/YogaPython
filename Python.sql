BEGIN TRANSACTION;

	-- Création des tables de la base

		CREATE TABLE IF NOT EXISTS Participant(
                login varchar NOT NULL UNIQUE,
		mdp varchar NOT NULL UNIQUE,
 		nom varchar NOT NULL UNIQUE,
		prenom varchar NOT NULL UNIQUE,
		ville varchar NOT NULL UNIQUE,
                age INT NOT NULL
			);
			
		CREATE TABLE IF NOT EXISTS TypeYoga(
		ID
		nomYoga varchar NOT NULL UNIQUE
			);	
			
		CREATE TABLE IF NOT EXISTS TempsHeure(
		heure varchar NOT NULL UNIQUE,
		DateJ  Date DEFAULT (strftime('%d-%m-%Y', 'now')),
		idCours varchar NOT NULL UNIQUE,
		FOREIGN KEY (idCours)REFERENCES Cours (rowid)
			            );

		CREATE TABLE IF NOT EXISTS Cours(
		IDTime INT NOT NULL,
		ville varchar NOT NULL UNIQUE,
        place INT NOT NULL,
        IDyoga INT NOT NULL,
		FOREIGN KEY (IDyoga) REFERENCES TypeYoga (rowid),
		FOREIGN KEY (IDTime) REFERENCES TempsHeure (rowid));
	
COMMIT TRANSACTION;