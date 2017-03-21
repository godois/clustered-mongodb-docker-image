use admin;

db.createUser( {
     user: "admin",
     pwd: "password",
     roles: [ { role: "root", db: "admin" },
              { role: "userAdminAnyDatabase", db: "admin" } ]
   });

exit;
