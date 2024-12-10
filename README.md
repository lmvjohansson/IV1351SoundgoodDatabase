soundgood.sql contains the database and the data to populate the database

task3.sql contains the 4 views/queries requested in the mandatory part of the task

historical-lessons.sql contains the code to create the historical database for the higher grade task

The Soundgood folder contains the code for the different layers under src/main/java, divided into different folder for the different layers

Please note that if you want to try the program for yourself you need to change the code in the SoundgoodDAO file to reflect your database and password,
see code snippet below. "soundgood" is the name of the database, "postgres" the name of the user and "password" the password.

```
    private void connectToSoundgoodDB() throws ClassNotFoundException, SQLException {
        connection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/soundgood",
                "postgres", "password");
```
