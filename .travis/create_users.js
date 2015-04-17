db = db.getSiblingDB("admin");

db.createUser(
    {
        "user"  : "useradmin",
        "pwd"   : "useradmin",
        "roles" : [
            {
                "role" : "userAdminAnyDatabase",
                "db"   : "admin"
            }
        ]
    }
);

db.auth("useradmin", "useradmin");

db = db.getSiblingDB("workflow_test");

db.createUser(
    {
        "user"  : "test",
        "pwd"   : "abc123",
        "roles" : [
            {
                "role" : "readWriteAnyDatabase",
                "db"   : "admin"
            }
        ]
    }
);