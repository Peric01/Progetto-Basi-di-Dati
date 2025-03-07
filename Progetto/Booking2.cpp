#define PG_HOST "127.0.0.1" // oppure " localhost " o " postgresql "
#define PG_USER "postgres" // il vostro nome utente
#define PG_DB "Booking2" // il nome del database
#define PG_PASS "password" // la vostra password
#define PG_PORT 5432

#include <cstdio>
#include <iostream>
#include <fstream>
#include "dependencies/include/libpq-fe.h"
using namespace std ;

PGresult* EseguiQuery(PGconn* conn, const char* query) {
    PGresult* res = PQexec(conn, query);
    if (PQresultStatus(res) != PGRES_TUPLES_OK) {
        cout << PQerrorMessage(conn) << endl;
        PQclear(res);
        exit(1);
    }


    return res;
}


void StampaQuery(PGresult* res) {
    int numTuple=PQntuples(res);
    int numcol=PQnfields(res);
    if(numTuple==0)
        cout<<"Nessuna tupla trovata.\n";
    else
    for(int i=0;i<numTuple;++i){
        for(int j=0;j<numcol;++j)
        cout<<PQgetvalue(res,i,j) <<"  ";
        cout<<endl;
    }
       
    PQclear(res);
   
}


void checkresults(PGresult*res, const PGconn* conn){
    if(PQresultStatus(res)!= PGRES_TUPLES_OK){
        cout<<"Risultati inconsistenti !"<<PQerrorMessage(conn)<< endl ;
        PQclear(res);
        exit(1);
    }
}


int main(int argc, char** argv){
   
    PGconn* conn;
    char conninfo [250];
    sprintf(conninfo," user =%s password =%s dbname =%s host =%s port =%d",PG_USER , PG_PASS , PG_DB , PG_HOST , PG_PORT);
    conn=PQconnectdb(conninfo);


    if(PQstatus(conn) != CONNECTION_OK){//La funzione PQstatus prende in input il puntatore alla connessione e ne restituisce lo stato.
        cout<<"errore di connessione!! "<<PQerrorMessage(conn);


        PQfinish(conn);
        exit(1);
    }
    else cout<<"\nconnessione avvenuta correttamente";
           
    const char* querys[7]={
    "SELECT Stato, COUNT(*) AS NumeroHotel FROM Hotel GROUP BY Stato ORDER BY Stato;",
    //--query2
    "SELECT H.Id_Hotel, H.Nome AS Nome_Hotel, COUNT(Cam.Id_Camera) AS Numero_Suite, MIN(OS.Num_Omaggi) AS Min_Numero_Omaggi FROM Hotel H\
    LEFT JOIN Camera Cam ON H.Id_Hotel = Cam.Hotel AND Cam.Suite=true\
    LEFT JOIN ( SELECT Id_Suite, COUNT(Id_Omaggio) AS Num_Omaggi\
        FROM OmaggiSuite\
        GROUP BY Id_Suite\
    ) AS OS ON Cam.Id_Camera = OS.Id_Suite\
    GROUP BY H.Id_Hotel, H.Nome ORDER BY H.Id_Hotel;",
    
    //--query3 Group by e Having: mostrare il numero di attività affiliate presenti in hotel  
    //in cui il costo di è maggiore di un valore x, che nell'esempio è 15;

    "SELECT h.Id_Hotel, h.Nome AS NomeHotel, COUNT(a.Id_Attivita) AS NumeroAttivitaAffiliate FROM Hotel h \
    JOIN Attivita a ON h.Id_Hotel = a.Hotel WHERE a.Affiliata = true AND a.Prezzo >%d\
    GROUP BY h.Id_Hotel, h.Nome HAVING COUNT(a.Id_Attivita) >= 2;",

    //query4
    "SELECT U.Id_Utente, U.Nome, U.Cognome,COUNT(P.Id_Prenotazione) AS Numero_Prenotazioni,\
        Round( SUM(C.Costo_giornaliero * EXTRACT(EPOCH FROM (P.DataOraFine - P.DataOraInizio)) / (60 * 60 * 24))) AS Importo_Totale\
    FROM    Utente U JOIN Prenotazione P ON U.Id_Utente = P.Utente, JOIN Camera C ON P.Camera = C.Id_Camera\
    GROUP BY U.Id_Utente, U.Nome, U.Cognome ORDER BY Numero_Prenotazioni DESC \
    LIMIT 1;",


    //query5
    "SELECT P.Id_Prenotazione, U.Nome AS Nome_Utente, U.Cognome AS Cognome_Utente, P.DataOraInizio, P.DataOraFine,\
        ROUND(EXTRACT(EPOCH FROM (P.DataOraFine - P.DataOraInizio)) / (60 * 60 * 24)) AS Durata_Giorni\
    FROM Prenotazione P JOIN Utente U ON P.Utente = U.Id_Utente \
    WHERE P.DataOraInizio >= '%d-01-01' AND P.DataOraFine <= '%d-12-31' ORDER BY Durata_Giorni DESC LIMIT 3;"


    //query6
    "SELECT h.Id_Hotel, h.Nome, COUNT(hs.Id_Servizio) AS NumeroServizi, r.Punteggio_Hotel, r.Commento \
    FROM Hotel h LEFT JOIN HotelServizi hs ON h.Id_Hotel = hs.Id_Hotel\
    LEFT JOIN Recensione r ON h.Id_Hotel = r.Hotel\
    GROUP BY h.Id_Hotel, h.Nome, r.Punteggio_Hotel, r.Commento\
    HAVING COUNT(hs.Id_Servizio) = (\
        SELECT MIN(ServiziCount)\
        FROM (\
            SELECT hs.Id_Hotel, COUNT(hs.Id_Servizio) AS ServiziCount\
            FROM HotelServizi hs\
            GROUP BY hs.Id_Hotel\
        ) AS MinServizi\
    );\
    ORDER BY NumeroServizi ASC;",


    //query7
    "SELECT A.Id_Attivita, A.Nome AS Nome_Attivita,\
        A.Prezzo * (1 - A.Sconto) AS Prezzo_Scontato, A.Voto, H.Nome AS Nome_Hotel\
    FROM Attivita A JOIN Hotel H ON A.Hotel = H.Id_Hotel\
    WHERE A.Affiliata = TRUE ORDER BY A.Voto DESC LIMIT 3;" 
    };
   
    pg_result* res;
    int c=-1;
    bool esegui=true;
    while (esegui)
    {  
        cout<<endl;
        cout<<"Inserire un numero per visualizzare la rispettiva query, o Zero per uscire"<<endl;
        cout<<"1. Mostrare il numero di hotel presenti in uno stesso stato;"<<endl;
        cout<<"2. Mostrare quante suite ha ciascun hotel e il numero minimo di omaggi che vengono offerti da ciascun hotel;"<<endl;
        cout<<"3. Mostrare gli hotel che hanno almeno due attività affiliate se il loro costo è maggiore di un valore x, che nell'esempio è 15;"<<endl;
        cout<<"4. Mostrare l'utente con più prenotazioni di camere e l'importo totale pagato;"<<endl;
        cout<<"5. Mostrare le 3 prenotazioni di durata piu' lunga del 2022;"<<endl;
        cout<<"6. Mostrare l'hotel con meno servizi e le sue recensioni:"<<endl;
        cout<<"7. Mostrare le 3 attività affiliate con punteggio più alto e il loro prezzo tenendo in considerazione lo sconto;"<<endl;
       
        char TestoStampaQuery[1000];
        cin>>c;
        switch (c)
        {
        case 0:
            exit(1);
            esegui=false;
            break;
        case 1:
            res=EseguiQuery(conn,querys[0]);
            StampaQuery(res);
            break;
        case 2:
            res=EseguiQuery(conn,querys[1]);
            StampaQuery(res);
            break;
        case 3:
            int prezzo;
            cout << "Inserisci il prezzo minimo che deve avere l'attivita:";
            cin >> prezzo;
            sprintf(TestoStampaQuery, querys[2], prezzo);
            res=EseguiQuery(conn, TestoStampaQuery);
            StampaQuery(res);
            break;
        case 4:
            break;
        case 5:
            int anno;
            cout << "Inserisci l'anno delle prenotazioni da controllare: ";
            cin >> anno;
            sprintf(TestoStampaQuery, querys[4], anno, anno);
            res=EseguiQuery(conn, querys[4]);
            StampaQuery(res);
            break;
        case 6:
            break;
        case 7:
            break;
        }

    }
   


    PQfinish(conn);
    return 0;
}

