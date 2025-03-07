drop table if exists Utente CASCADE;
drop table if exists Carta_di_debito CASCADE;
drop table if exists Prenotazione CASCADE;
drop table if exists Camera CASCADE;
drop table if exists Omaggi CASCADE;
drop table if exists OmaggiSuite CASCADE;
drop table if exists Hotel CASCADE;
drop table if exists Servizi CASCADE;
drop table if exists HotelServizi CASCADE;
drop table if exists Recensione CASCADE;
drop table if exists Attivita CASCADE;

CREATE TABLE Carta_di_debito(
    Numero_carta        bigint       PRIMARY KEY,
    CVC                 smallint     NOT NULL,
    Intestatario        varchar(40)  NOT NULL,
    Data_di_scadenza    date         NOT NULL

);


CREATE TABLE Utente(
    Id_Utente	    int         PRIMARY KEY,
	Nome		    varchar(20) NOT NULL,
	Cognome		    varchar(20) NOT NULL,
	Email		    varchar(30) NOT NULL,
	Password	    varchar(50) NOT NULL,
    Telefono        varchar(16) NOT NULL,
	Premium 		boolean     NOT NULL,
	Sconto			float,
    Carta_debito    bigint NOT NULL,   
    FOREIGN KEY(Carta_debito) REFERENCES Carta_di_debito(Numero_carta) on UPDATE CASCADE ON DELETE CASCADE,
    CHECK ((Premium=true AND Sconto>0 AND Sconto<1) OR (Premium=false AND Sconto IS NULL))
);

CREATE TABLE Hotel(
    Id_Hotel            int PRIMARY KEY,
    Nome	        	varchar(30)     NOT NULL,
    Email			    varchar(30)     NOT NULL,
    Telefono		    varchar(16)         NOT NULL,
    CAP                 char (5)        NOT NULL,
    Via                 varchar (50)    NOT NULL,
    N_Civico            varchar (10)    NOT NULL,
    Città               varchar (50)    NOT NULL,
    Stato               varchar (20)    NOT NULL

);

CREATE TABLE Camera(

    Id_Camera  	    	int     PRIMARY KEY,
    Costo_giornaliero 	int     NOT NULL,	
    Num_Max_Ospiti	    int  	NOT NULL,
    Suite               boolean NOT NULL,
    Hotel               int NOT NULL,
    FOREIGN KEY (Hotel) REFERENCES Hotel(Id_Hotel) on UPDATE CASCADE ON DELETE CASCADE

);

CREATE TABLE Prenotazione(
    Id_Prenotazione         int    PRIMARY KEY,
    Numero_di_ospiti        smallint NOT NULL,
    Rimborsabile            bool   NOT NULL,
    DataOraInizio           timestamp NOT NULL,
    DataOraFine             timestamp NOT NULL,
    Utente                  int NOT NULL,
    Camera                  int NOT NULL,
    FOREIGN KEY (Utente) REFERENCES Utente(Id_Utente) on UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Camera) REFERENCES Camera(Id_Camera) on UPDATE CASCADE ON DELETE CASCADE,
    CHECK( Dataorainizio<Dataorafine)

);

CREATE TABLE Omaggi(
    Id_Omaggio 	int PRIMARY KEY,    
    Nome		varchar(50) NOT NULL

);

CREATE TABLE OmaggiSuite (
    Id_Omaggio int NOT NULL,
    Id_Suite int NOT NULL,
    PRIMARY KEY (Id_Omaggio, Id_Suite),
    FOREIGN KEY (Id_Omaggio) REFERENCES Omaggi (Id_Omaggio) ON UPDATE CASCADE ON DELETE CASCADE, 
    FOREIGN KEY (Id_Suite) REFERENCES Camera(Id_Camera) ON UPDATE CASCADE ON DELETE CASCADE );


CREATE TABLE Servizi(
    Id_Servizio	int PRIMARY KEY,
    Nome 		varchar(40) NOT NULL
);

-- Tabella di Associazione HotelServizi
CREATE TABLE HotelServizi (
    Id_Hotel    int NOT NULL,
    Id_Servizio int NOT NULL,
    PRIMARY KEY (Id_Hotel, Id_Servizio),
    FOREIGN KEY (Id_Hotel) REFERENCES Hotel (Id_Hotel) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Id_Servizio) REFERENCES Servizi (Id_Servizio) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Attivita(
    Id_Attivita		int PRIMARY KEY,
    Nome	        varchar(30) NOT NULL,
    Prezzo	        int NOT NULL,
    Voto		    smallint, 
    Hotel           int NOT NULL,
	Affiliata		bool NOT NULL,
	Sconto			float,
    FOREIGN KEY (Hotel) REFERENCES Hotel(Id_Hotel) on UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Recensione(

    Commento	                                    varchar (200),
    Hotel                                           int     NOT NULL,
    Attivita                                        int     NOT NULL,
    Prenotazione                                    int     NOT NULL 
	CHECK( Punteggio_Hotel >=1 AND Punteggio_Hotel <=10),
    Punteggio_Hotel                                 smallint  NOT NULL,
    Punteggio_Attivita                              smallint CHECK(Punteggio_Attivita>=1 AND Punteggio_Attivita <=10) ,
    FOREIGN KEY (Hotel) REFERENCES Hotel(Id_Hotel)                      on UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Attivita) REFERENCES Attivita(Id_Attivita)             on UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Prenotazione) REFERENCES Prenotazione(Id_Prenotazione) on UPDATE CASCADE ON DELETE CASCADE

    
	
);

--inserimento
--Carta_di_debito
INSERT INTO Carta_di_debito (Numero_carta, CVC, Intestatario, Data_di_scadenza)
VALUES
    (1234567890123456, 123, 'Mario Rossi', '2023-12-31'),
    (2345678901234567, 234, 'Laura Bianchi', '2024-06-30'),
    (6958878901234567, 345, 'Luca Verdi', '2023-09-30'),
    (1111222233334444, 456, 'Giulia Neri', '2024-03-31'),
    (5555666677778888, 567, 'Alessio Gialli', '2023-11-30'),
    (9876543210987654, 678, 'Elena Rosa', '2025-01-31'),
    (4444333322221111, 789, 'Davide Marroni', '2024-08-31'),
    (9999111122223333, 890, 'Sara Blu', '2023-10-31'),
    (2345656901234568, 901, 'Francesca Viola', '2025-05-31'),
    (4442555566667747, 123, 'Roberto Robertini', '2024-02-28'),
    (6661777587832919, 234, 'Anna Bianchi', '2023-11-30'),
    (4443555966677778, 789, 'Daniele Marroni', '2024-07-31'),
    (6666777788889999, 890, 'Elisa Blu', '2025-02-28'),
    (1234566850123456, 901, 'Antonio Viola', '2023-09-30'),
    (8888999900001111, 012, 'Giorgia Gialli', '2024-05-31');

--utente
insert into Utente(Id_Utente, Nome, Cognome,Email, Password, Telefono, Premium, Carta_Debito, Sconto) values
(1, 'Mario', 'Rossi', 'marior@email.com', 'password123', '+61298765432', false, 1234567890123456, NULL),
(2, 'Laura', 'Bianchi', 'laurab@email.com', 'securepass','+14165557890' , true, 2345678901234567, 0.1),
(3, 'Luca', 'Verdi', 'lucav@email.com', 'secretword', '+442071238901', false, 6958878901234567, NULL),
(4, 'Giulia', 'Neri', 'giuliablacks@email.com', 'confidential', '+14155556789', true, 1111222233334444, 0.05),
(5, 'Alessio', 'Gialli', 'alessioyellows@email.com', 'topsecret', '+12029182132', false, 5555666677778888, NULL),
(6, 'Linda', 'Marrone', 'linda@email.com', 'classified', '+376604447', true, 9876543210987654, 0.3),
(7, 'Davide', 'Marrons', 'davidonem@gmail.com', 'hiddenpass', '+376669004', false, 4444333322221111, NULL),
(8, 'Sara', 'Blu', 'willitbeblue@email.com', 'mypassphrase','+43 697632013535' , true, 9999111122223333, 0.2),
(9, 'Francesca', 'Viola', 'Franciii@email.com', 'hiddenpassword', '+43653184217', false, 2345656901234568, NULL),
(10, 'Anna','Bianchi', 'paolo@email.com', 'mysecret','+43653184217' , true, 6661777587832919, 0.15),
(11, 'Daniele',' Marroni', 'Danielbroown@email.com', 'hiddenkey','+2977701368' , true, 4443555966677778, 0.1),
(12, 'Roberto', 'Robertini', 'roberto@email.com', 'safepassword','+35943989485' , false, 4442555566667747, NULL),
(13, 'Elisa',' Blu', 'elisssa@email.com', 'privatepass','+359999032066' , false, 6666777788889999, NULL),
(14, 'Antonio',' Viola', 'antopurple@email.com', 'myconfidentialpass','+393324114643' , true, 1234566850123456, 0.05),
(15, 'Giorgia',' Gialli', 'giogialli@email.com', 'newpassword','+39335864215' , false, 8888999900001111, NULL);

--Hotel
INSERT INTO Hotel (Id_Hotel, Nome, Email, Telefono, CAP, Via, N_Civico, Città, Stato) VALUES 
(1, 'Hotel Milano', 'milano@example.com', 3934949942, '20121', 'Via Roma', '10', 'Milano', 'Italia'),
(2, 'Hotel Roma', 'roma@example.com', 3838231281, '00118', 'Via Venezia', '25', 'Roma', 'Italia'),
(3, 'Hotel Paris', 'paris@example.com', 3133456389, '75008', 'Rue de la Paix', '45', 'Parigi', 'Francia'),
(4, 'Grand Hotel', 'grandhotel@example.com', 4445556666, '12345', 'Main Street', '100', 'New York', 'USA'),
(5, 'Hotel de Ville', 'hoteldeville@example.com', 7778889999, '75001', 'Rue de Rivoli', '50', 'Pargi', 'Francia'),
(6, 'Beach Resort', 'beachresort@example.com', 1112223333, '34256', 'Coastal Road', '78', 'Miami', 'USA'),
(7, 'Alpine Lodge', 'alpinelodge@example.com', 5556667777, '12345', 'Mountain View', '15', 'Zermatt', 'Switzerland'),
(8, 'Seaside Inn', 'seasideinn@example.com', 8889990000, '90210', 'Beach Boulevard', '200', 'Los Angeles', 'USA'),
(9, 'Mountain Retreat', 'mountainretreat@example.com', 2223334444, '54321', 'Pine Street', '10', 'Aspen', 'USA'),
(10, 'City Center Hotel', 'citycenterhotel@example.com', 6667778888, '10001', 'Central Avenue', '123', 'London', 'UK'),
(11, 'Tropical Paradise Resort', 'tropicalresort@example.com', 4445556666, '80001', 'Palm Beach', '50', 'Bali', 'Indonesia'),
(12, 'Historic Mansion', 'historicmansion@example.com', 7778889999, '12345', 'Historic Street', '100', 'Vienna', 'Austria'),
(13, 'Seaview Hotel', 'seaviewhotel@example.com', 2223334444, '50001', 'Ocean Drive', '25', 'Sydney', 'Australia');

-- Camera
INSERT INTO Camera (Id_Camera, Costo_giornaliero, Num_Max_Ospiti, Suite, Hotel)
VALUES 
(1, 100, 2, FALSE, 4),
(2, 150, 2, TRUE, 4),
(3, 120, 3, FALSE, 5),
(4, 180, 4, TRUE, 5),
(5, 200, 2, FALSE, 6),
(6, 250, 3, TRUE, 6),
(7, 80, 1, FALSE, 7),
(8, 120, 2, FALSE, 7),
(9, 180, 4, TRUE, 8),
(10, 100, 2, FALSE, 8),
(11, 250, 3, TRUE, 9),
(12, 150, 2, FALSE, 9),
(13, 120, 3, FALSE, 10),
(14, 180, 4, TRUE, 10),
(15, 200, 2, FALSE, 11),
(16, 250, 3, TRUE, 11),
(17, 80, 1, FALSE, 12),
(18, 120, 2, FALSE, 12),
(19, 180, 4, TRUE, 13),
(20, 100, 2, FALSE, 13),
(21, 150, 2, FALSE, 1),
(22, 180, 3, TRUE, 1),
(23, 100, 2, FALSE, 2),
(24, 200, 4, TRUE, 2),
(25, 120, 2, FALSE, 3),
(26, 250, 3, TRUE, 1),
(27, 240, 3, TRUE, 1);



--prenotazione

INSERT INTO Prenotazione (Id_Prenotazione, Numero_di_ospiti, Rimborsabile, DataOraInizio, DataOraFine, Utente, Camera)
VALUES
    (1, 2, TRUE, '2023-07-23 14:00:00', '2023-07-25 12:00:00', 1, 1),
    (2, 3, TRUE, '2023-08-10 15:30:00', '2023-08-15 10:00:00', 2, 2),
    (3, 1, FALSE, '2023-09-05 12:00:00', '2023-09-07 09:00:00', 3, 3),
    (4, 2, TRUE, '2023-08-28 10:00:00', '2023-09-02 16:00:00', 4, 4),
    (5, 1, FALSE, '2023-10-12 18:00:00', '2023-10-15 11:30:00', 5, 5),
    (6, 4, TRUE, '2023-11-08 14:00:00', '2023-11-12 12:00:00', 6, 6),
    (7, 2, FALSE, '2023-12-05 12:30:00', '2023-12-09 10:00:00', 7, 7),
    (8, 1, TRUE, '2023-08-20 08:00:00', '2023-08-23 16:00:00', 8, 8),
    (9, 3, TRUE, '2023-09-15 10:00:00', '2023-09-20 11:00:00', 9, 9),
    (10, 2, FALSE, '2023-11-01 14:30:00', '2023-11-04 09:00:00', 10, 10),
    (11, 1, TRUE, '2023-10-05 12:00:00', '2023-10-07 10:00:00', 11, 11),
    (12, 2, TRUE, '2023-10-18 15:00:00', '2023-10-22 12:00:00', 12, 12),
    (13, 1, FALSE, '2023-12-02 10:00:00', '2023-12-04 09:00:00', 13, 13),
    (14, 4, TRUE, '2023-05-25 12:00:00', '2023-05-30 11:00:00', 14, 14),
    (15, 2, FALSE, '2023-11-15 14:30:00', '2023-11-20 10:00:00', 15, 15),
	(16, 3, TRUE, '2019-12-10 15:00:00', '2019-12-15 11:00:00', 9, 1), 
(17, 1, FALSE, '2021-11-28 12:00:00', '2021-11-30 09:00:00', 3, 19),
 (18, 2, TRUE, '2021-10-22 10:00:00', '2021-10-25 18:00:00', 8, 22), 
(19, 1, FALSE, '2023-09-18 18:00:00', '2023-09-20 10:30:00', 11, 7), 
(20, 2, TRUE, '2022-08-28 14:00:00', '2022-09-01 12:00:00', 7, 20), 
(21, 3, TRUE, '2021-11-15 11:30:00', '2021-11-20 10:00:00', 2, 4), 
(22, 1, FALSE, '2020-12-18 12:00:00', '2020-12-20 09:00:00', 12, 6), 
(23, 2, TRUE, '2023-09-25 10:00:00', '2023-09-30 16:00:00', 14, 11), 
(24, 1, FALSE, '2020-10-10 18:00:00', '2020-10-12 11:30:00', 10, 24), 
(25, 4, TRUE, '2022-11-28 14:00:00', '2022-12-03 12:00:00', 6, 25), 
(26, 2, TRUE, '2021-10-15 12:30:00', '2021-10-20 10:00:00', 5, 8), 
(27, 1, FALSE, '2023-04-05 12:00:00', '2023-04-07 09:00:00', 4, 20),
 (28, 3, TRUE, '2020-08-25 15:00:00', '2020-08-30 11:00:00', 15, 13), 
(29, 1, FALSE, '2020-12-02 12:00:00', '2020-12-04 09:00:00', 1, 25), 
(30, 2, TRUE, '2021-09-18 10:00:00', '2021-09-22 18:00:00', 13, 26), 
(31, 1, FALSE, '2021-10-10 18:00:00', '2021-10-12 11:30:00', 10, 21), 
(32, 4, TRUE, '2022-12-28 14:00:00', '2022-12-30 12:00:00', 6, 22), 
(33, 2, TRUE, '2023-10-15 12:30:00', '2023-10-20 10:00:00', 5, 18), 
(34, 1, FALSE, '2021-09-05 12:00:00', '2021-09-07 09:00:00', 4, 16), 
(35, 3, TRUE, '2022-08-25 15:00:00', '2022-08-30 11:00:00', 15, 17),
 (36, 1, FALSE, '2021-12-02 12:00:00', '2021-12-04 09:00:00', 1, 23);




INSERT INTO Omaggi (Id_Omaggio, Nome)
VALUES
    (1, 'Cesto di Frutta'),
    (2, 'Bottiglia di Vino'),
    (3, 'Set di Prodotti da Bagno'),
    (4, 'Colazione Gratuita'),
    (5, 'Buono Sconto per il Ristorante'),
    (6, 'Pantofole e Accappatoio'),
    (7, 'Cestino di Benvenuto'),
    (8, 'Pacchetto Spa'),
    (9, 'Accesso Gratuito alla Palestra'),
    (10, 'Aperitivo di Benvenuto'),
    (11, 'Pacchetto Romantico'),
    (12, 'Tour Guidato della Città'),
    (13, 'Buono Sconto per il Centro Benessere'),
    (14, 'Pacchetto Relax'),
    (15, 'Bottiglia di Champagne'),
    (16, 'Massaggio Rilassante'),
    (17, 'Gita in Barca a Vela'),
    (18, 'Pacchetto Avventura'),
    (19, 'Gita in Jeep');


INSERT INTO OmaggiSuite (Id_Omaggio, Id_Suite)
VALUES
    (1, 2),
    (2, 4),
    (3, 6),
    (4, 9),
    (5, 11),
    (6, 14),
    (7, 16),
    (8, 19),
    (9, 22),
    (10, 24),
    (11, 26),
    (12, 2),
    (13, 4),
    (14, 6),
    (15, 9),
    (16, 11),
    (17, 14),
    (18, 16),
    (19, 19),
    (1, 4),
    (2, 6),
    (2, 9),
    (3, 11),
    (3, 14),
    (4, 16),
    (4, 19),
    (5, 22),
    (5, 24),
    (6, 26),
    (7, 2),
    (7, 4),
    (8, 6),
    (8, 9),
    (9, 11),
    (9, 14),
    (10, 16),
    (10, 19),
    (11, 22),
    (11, 24),
    (12, 26),
    (13, 2),
    (14, 9),
    (15, 11),
    (15, 14),
    (16, 16),
    (16, 19),
    (16, 27);

INSERT INTO Servizi (Id_Servizio, Nome)
VALUES
    (1, 'Piscina'),
    (2, 'Palestra'),
    (3, 'Centro Benessere'),
    (4, 'Ristorante'),
    (5, 'Servizio in Camera'),
    (6, 'Connessione Wi-Fi'),
    (7, 'Navetta Aeroportuale'),
    (8, 'Servizio di Pulizia'),
    (9, 'Reception 24 ore'),
    (10, 'Bar'),
    (11, 'Lavanderia'),
    (12, 'Area Giochi per Bambini'),
    (13, 'Centro Congressi'),
    (14, 'Servizio Navetta'),
    (15, 'Parcheggio Gratuito'),
    (16, 'Servizio in Spiaggia'),
    (17, 'Servizio Noleggio Biciclette'),
    (18, 'Campo da Tennis'),
    (19, 'Mini Club per Bambini'),
    (20, 'Ristorante Gourmet'),
    (21, 'Servizio Navetta per il Centro'),
    (22, 'Sauna e Bagno Turco'),
    (23, 'Servizio in Camera 24 ore'),
    (24, 'Ristorante Panoramico');
INSERT INTO HotelServizi (Id_Hotel,Id_Servizio)
VALUES
    (1, 3),   
    (1, 5),   
    (2, 2),   
    (2, 4),   
    (2, 6),   
    (3, 1),   
    (3, 3),   
    (3, 7),  
    (4, 8),  
    (4, 10),
    (4, 12),  
    (5, 1),   
    (5, 4),  
    (5, 13),  
    (6, 7),   
    (6, 11), 
    (6, 15),  
    (7, 5),   
    (7, 9),   
    (7, 17),  
    (8, 18), 
    (8, 21),  
    (8, 24), 
    (9, 8),   
    (9, 14),  
    (9, 20), 
    (10, 2),  
    (10, 6),
    (10, 22),
    (11, 3),
    (11, 6),
    (11, 12), 
    (12, 1),
    (12, 5),
    (12, 17),
    (13, 2),
    (13, 9),
    (13, 23),
    (13, 24);

--attivita
INSERT INTO Attivita (Id_Attivita, Nome, Prezzo, Voto, Hotel, Affiliata, Sconto)
VALUES
    (1, 'Escursione in Montagna', 50, 4, 1, FALSE, NULL),
    (2, 'Tour delle Città', 30, 8, 1, TRUE, 0.05),
    (3, 'Cena Romantica', 80, 2, 1, FALSE, NULL),
    (4, 'Corso di Cucina', 40, 4, 2, FALSE, NULL),
    (5, 'Spa e Massaggio', 60, 3, 2, TRUE, 0.1),
    (6, 'Tour in Bicicletta', 25, 5, 2, FALSE, NULL),
    (7, 'Gita in Barca', 70, 1, 3, FALSE, NULL),
    (8, 'Lezione di Surf', 45, 3, 3, TRUE, 0.07),
    (9, 'Visita ai Musei', 20, 4, 3, FALSE, NULL),
    (10, 'Tour Enogastronomico', 55, 10, 4 ,TRUE, 0.01),
    (11, 'Escursione in Jeep', 65, 4, 4, FALSE, NULL),
    (12, 'Attività Sportive', 35, 7, 4, FALSE, NULL),
    (13, 'Yoga e Meditazione', 40, 6, 5, TRUE, 0.15),
    (14, 'Laboratorio di Pittura', 30, 5, 5, FALSE, NULL),
    (15, 'Giardino Botanico', 25, 8, 5, TRUE, 0.2),
    (16, 'Tour in Elicottero', 120, 5, 6, FALSE, NULL),
    (17, 'Parco Divertimenti', 60, 4, 6, TRUE, 0.09),
    (18, 'Caccia al Tesoro', 40, 1, 6, FALSE, NULL),
    (19, 'Percorso di Arrampicata', 50, 4, 7, TRUE, 0.4),
    (20, 'Cinema all Aperto', 20, 3, 7, TRUE, 0.6),
    (21, 'Tour in Barca a Vela', 70, 2, 8, FALSE, NULL),
    (22, 'Degustazione di Vini', 40, 4, 8, TRUE, 0.05),
    (23, 'Tour di Paddle Board', 30, 7, 8, FALSE, NULL),
    (24, 'Spettacolo di Cabaret', 55, 9, 9, FALSE, NULL),
    (25, 'Visita a Parchi Naturali', 25, 4, 9, FALSE, NULL),
    (26, 'Caccia al Tesoro', 40, 7, 9, TRUE, 0.5),
    (27, 'Gita in Bicicletta', 35, 4, 10, FALSE, NULL),
    (28, 'Esplorazione Sotterranea', 60, 6, 13, TRUE, 0.2),
    (29, 'Tour della Città Antica', 30, 5, 11, FALSE, NULL),
    (30, 'Escursione in Montagna', 50, 8, 12, TRUE, 0.2);


INSERT INTO Recensione (Commento, Hotel, Attivita, Prenotazione, Punteggio_Hotel, Punteggio_Attivita)
VALUES
    ('Hotel poco accogliente e personale non molto gentile', 1, 5, 10, 1, 7),
    ('Molto soddisfatto del soggiorno', 2, 12, 15, 8, 9),
    ('Attività emozionante e divertente', 3, 25, 12, 7, 8),
    ('Un hotel con vista mozzafiato', 4, 8, 11, 10, 7),
    ('Ottima cucina nel ristorante dell''hotel', 5, 15, 1, 9, 8),
    ('Escursione interessante e ben organizzata', 6, 22, 4, 8, 9),
    ('Personale cordiale e disponibile', 7, 3, 3, 9, 8),
    ('Servizio in camera efficiente e veloce', 8, 18, 1, 7, 9),
    ('Bella esperienza di benessere al centro spa', 9, 29, 4, 8, 10),
    ('Un soggiorno rilassante e piacevole', 10, 11, 7, 9, 8),
    ('Staff cortese e professionale', 11, 4, 10, 9, 7),
    ('Attività adrenalinica e avventurosa', 12, 19, 13, 8, 9),
    ('Un hotel di charme con atmosfera romantica', 13, 20, 14, 10, 8),
    ('Una piacevole esperienza culinaria', 1, 9, 6, 9, 8),
    ('Escursione tra la natura incontaminata', 2, 26, 7, 8, 9),
    ('Personale sempre disponibile e attento', 3, 1, 8, 9, 8),
    ('Servizio navetta molto comodo', 4, 13, 9, 7, 9),
    ('Un soggiorno da ricordare', 5, 23, 2, 9, 8),
    ('Attività divertente per tutta la famiglia', 6, 10, 5, 8., 9),
    ('Bellissima piscina con vista panoramica', 7, 7, 8, 10, 8);

--query

--query1 Group by: contare gli hotel presenti in uno stesso stato;

SELECT Stato, COUNT(*) AS NumeroHotel
FROM Hotel
GROUP BY Stato
ORDER BY Stato;

--query2
SELECT H.Id_Hotel, H.Nome AS Nome_Hotel, COUNT(Cam.Id_Camera) AS Numero_Suite, MIN(OS.Num_Omaggi) AS Min_Numero_Omaggi
FROM Hotel H
LEFT JOIN Camera Cam ON H.Id_Hotel = Cam.Hotel AND Cam.Suite = true
LEFT JOIN (
    SELECT Id_Suite, COUNT(Id_Omaggio) AS Num_Omaggi
    FROM OmaggiSuite
    GROUP BY Id_Suite
) AS OS ON Cam.Id_Camera = OS.Id_Suite
GROUP BY H.Id_Hotel, H.Nome
ORDER BY H.Id_Hotel;



--query3 Group by e Having: mostrare il numero di attività affiliate presenti in hotel  
--in cui il costo di è maggiore di un valore x, che nell'esempio è 15;
SELECT h.Id_Hotel, h.Nome AS NomeHotel, COUNT(a.Id_Attivita) AS NumeroAttivitaAffiliate
FROM Hotel h
JOIN Attivita a ON h.Id_Hotel = a.Hotel
WHERE a.Affiliata = true AND a.Prezzo > 15
GROUP BY h.Id_Hotel, h.Nome
HAVING COUNT(a.Id_Attivita) >= 2;


--query4
SELECT U.Id_Utente, U.Nome, U.Cognome,COUNT(P.Id_Prenotazione) AS Numero_Prenotazioni,
    Round( SUM(C.Costo_giornaliero * EXTRACT(EPOCH FROM (P.DataOraFine - P.DataOraInizio)) / (60 * 60 * 24))) AS Importo_Totale
FROM    Utente U
JOIN Prenotazione P ON U.Id_Utente = P.Utente
JOIN Camera C ON P.Camera = C.Id_Camera
GROUP BY U.Id_Utente, U.Nome, U.Cognome
ORDER BY Numero_Prenotazioni DESC
LIMIT 1;

--query5
SELECT P.Id_Prenotazione, U.Nome AS Nome_Utente, U.Cognome AS Cognome_Utente, P.DataOraInizio, P.DataOraFine,
    ROUND(EXTRACT(EPOCH FROM (P.DataOraFine - P.DataOraInizio)) / (60 * 60 * 24)) AS Durata_Giorni
FROM Prenotazione P
JOIN Utente U ON P.Utente = U.Id_Utente
WHERE P.DataOraInizio >= '2022-01-01' AND P.DataOraFine <= '2022-12-31'
ORDER BY Durata_Giorni DESC
LIMIT 3;

--query6
SELECT h.Id_Hotel, h.Nome, COUNT(hs.Id_Servizio) AS NumeroServizi, r.Punteggio_Hotel, r.Commento
FROM Hotel h
LEFT JOIN HotelServizi hs ON h.Id_Hotel = hs.Id_Hotel
LEFT JOIN Recensione r ON h.Id_Hotel = r.Hotel
GROUP BY h.Id_Hotel, h.Nome, r.Punteggio_Hotel, r.Commento
HAVING COUNT(hs.Id_Servizio) = (
    SELECT MIN(ServiziCount)
    FROM (
        SELECT hs.Id_Hotel, COUNT(hs.Id_Servizio) AS ServiziCount
        FROM HotelServizi hs
        GROUP BY hs.Id_Hotel
    ) AS MinServizi
)
ORDER BY NumeroServizi ASC;

--query7
SELECT A.Id_Attivita, A.Nome AS Nome_Attivita,
    A.Prezzo * (1 - A.Sconto) AS Prezzo_Scontato, A.Voto, H.Nome AS Nome_Hotel
FROM Attivita A
JOIN Hotel H ON A.Hotel = H.Id_Hotel
WHERE A.Affiliata = TRUE
ORDER BY A.Voto DESC
LIMIT 3;

CREATE INDEX Camere on Camera(Id_Camera);
CREATE INDEX Hotel_index on Hotel(Id_Hotel);

    