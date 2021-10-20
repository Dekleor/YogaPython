BEGIN TRANSACTION;

	-- Création des tables de la base
		
		CREATE TABLE IF NOT EXISTS Participant(
         login varchar NOT NULL UNIQUE
		,mdp varchar NOT NULL UNIQUE
 		,nom varchar NOT NULL 
		,prenom varchar NOT NULL 
		,ville varchar NOT NULL 
                ,age INT NOT NULL
			);
			
		CREATE TABLE IF NOT EXISTS TypeYoga(
		nomYoga varchar NOT NULL UNIQUE
			);	
			
		CREATE TABLE IF NOT EXISTS TempsHeure(
		 heure varchar NOT NULL 
		,DateJ  Date DEFAULT (strftime('%d-%m-%Y'))
			            );

		CREATE TABLE IF NOT EXISTS Cours(
		 IDheure INT NOT NULL
        ,IDdate INT NOT NULL
		,ville varchar NOT NULL
        ,place INT NOT NULL
	    ,IDyoga INT NOT NULL
		,FOREIGN KEY (IDyoga) REFERENCES TypeYoga (rowid)
		,FOREIGN KEY (IDheure) REFERENCES TempsHeure (rowid)
		,FOREIGN KEY (IDdate) REFERENCES TempsHeure (rowid)		
	);

		
	-- Remplissage des tables avec les jeux de données


			INSERT INTO TypeYoga (nomYoga) VALUES 
                 ("HATHA")
                ,("ASHTANGA")
			    ,("VINYASA")
                ,("IYENGAR")
                ,("BIKRAM")
			    ,("YIN")
                ,("JIVAMUKTI");


		INSERT INTO Participant  (login,mdp,nom,prenom,ville,age) VALUES
             ("user","mdp1","John","Chabot","Bordeaux",20)
			,("user2","mdp2","Nathan","Darrieu","Lyon",25)      
            ,("user4","mdp4","Maxime","Daro","Paris",22)
			,("user5","mdp5","John","Chabot","Bordeaux",21)
			,("user6","mdp6","Marie","Larrieu","Marseille",23)      
            ,("user7","mdp7","Valerie","Valoire","Paris",30) 
			,("user8","mdp8","Isabelle","Dupuis","Bordeaux",36)
			,("user9","mdp9","Marguerite","Desfleurs","Bretagne",18)      
            ,("user10","mdp10","Robert","Joanny","Paris",32);
		

	INSERT INTO TempsHeure(heure,DateJ) VALUES
       ("17h-19h","01-12-2021")
      ,("9h-10h","02-12-2021")
      ,("11h-13h","03-12-2021")
      ,("9h-10h","04-12-2021")
      ,("12h-14h","05-12-2021")
      ,("13h-15h","06-12-2021")
      ,("17h-20h","07-12-2021")
      ,("7h-10h","08-12-2021")
      ,("6h-9h","09-12-2021");
	


		INSERT INTO Cours (IDheure,IDdate,ville,place,IDyoga ) VALUES
	  ((SELECT (heure) FROM TempsHeure WHERE TempsHeure.rowid = 1),(SELECT (DateJ) FROM TempsHeure WHERE TempsHeure.rowid = 1),"Bordeaux",15,(SELECT (nomYoga) FROM typeYoga WHERE typeYoga .rowid = 1))
     ,((SELECT (heure) FROM TempsHeure WHERE TempsHeure.rowid = 2),(SELECT (DateJ) FROM TempsHeure WHERE TempsHeure.rowid = 2),"Lyon",20,(SELECT (nomYoga) FROM typeYoga WHERE typeYoga .rowid = 2))
     ,((SELECT (heure) FROM TempsHeure WHERE TempsHeure.rowid = 3),(SELECT (DateJ) FROM TempsHeure WHERE TempsHeure.rowid = 3),"Bretagne",25,(SELECT (nomYoga) FROM typeYoga WHERE typeYoga .rowid = 3))
     ,((SELECT (heure) FROM TempsHeure WHERE TempsHeure.rowid = 4),(SELECT (DateJ) FROM TempsHeure WHERE TempsHeure.rowid = 4),"Marseille",10,(SELECT (nomYoga) FROM typeYoga WHERE typeYoga .rowid = 4));

COMMIT TRANSACTION;