BEGIN TRANSACTION;
drop table if exists user;
drop table if exists TypeYoga;
drop table if exists TempsHeure;
drop table if exists Cours;

-- Création des tables de la base
		
		CREATE TABLE user (
		id   INTEGER  PRIMARY KEY AUTOINCREMENT,
		username  VARCHAR (50)  UNIQUE NOT NULL,
		firstname VARCHAR (50)  NOT NULL,
		lastname  VARCHAR (50)  NOT NULL,
		email     VARCHAR (150) NOT NULL,
		password  VARCHAR (20)  NOT NULL
);
			
CREATE TABLE IF NOT EXISTS TypeYoga(
	nomYoga varchar NOT NULL 
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
	
CREATE TABLE IF NOT EXISTS PositionYoga(
	nom varchar NOT NULL
	,description longtext NOT NULL
	,photo varchar
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


INSERT INTO user  (username,firstname,lastname,password,email) VALUES
	(1,"user","John","Chabot","Bordeaux","r@gmail.com")
	,(2,"user2","Nathan","Darrieu","Lyon","t@gmail.com")      
        ,(3,"user4","Maxime","Daro","Paris","y@gmail.com")
	,(4,"user5","John","Chabot","Bordeaux","u@gmail.com")
	,(5,"user6","Marie","Larrieu","Marseille","o@gmail.com")      
        ,(6,"user7","Valerie","Valoire","Paris","q@gmail.com") 
	,(7,"user8","Isabelle","Dupuis","Bordeaux","d@gmail.com")
	,(8,"user9","Marguerite","Desfleurs","Bretagne","g@gmail.com")      
        ,(9,"user10","Robert","Joanny","Paris","c@gmail.com");
		

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
	
INSERT INTO YogaPose(nom,description,photo) VALUES
	("Utkatasana", "Start in Mountain Pose. As you inhale, raise your arms, spread your fingers, and reach up through your fingertips. As you exhale, sit back and down as if sitting into a chair. Shift your weight toward the heels and lengthen up through the spine. As you inhale, lift and lengthen through your arms. As you exhale, sit deeper into the pose.", "")
	,("Uttana shishosana", "Place your hands on the back of a chair with palms shoulder-distance apart. Step your feet back until they align under hips, creating a right angle with your body, spine parallel with the floor. Ground through your feet and lift through thighs. Reach hips away from hands to lengthen the sides of your torso. Firm your outer arms in and lengthen through the crown of your head.", "")
	,("Adho Mukha Svanasana", "From all fours, walk your hands 6 inches in front of you. Tuck your toes and lift your hips up and back to lengthen your spine. If your hamstrings are tight, keep your knees bent in order to bring your weight back into the legs", "")
	,("Virabhadrasana II", "Stand with feet wide, 3–4 feet apart. Shift your right heel out so your toes are pointing slightly inward. Turn your left foot out 90 degrees. Line up your left heel with the arch of your right foot. Bend your left knee to a 90-degree angle, keeping the knee in line with the second toe to protect the knee joint. Stretch through your straight back leg and ground down into the back foot.", "")
	,("Trikonasana", "Stand with feet wide, 3–4 feet apart. Shift your right heel out so your toes are pointing slightly inward. Turn your left foot out 90 degrees. Line up your left heel with the arch of your right foot. Keeping both legs straight, ground through your feet. Lift arms into a T at shoulder height. Reach forward with your front arm. When you can’t reach anymore, hinge at the front hip.", "")
	
COMMIT TRANSACTION;
