db = db.getSiblingDB('sample_db');

db.users.insertMany([
    {
        "name": "John Doe",
        "email": "john@example.com",
        "age": 30
    },
    {
        "name": "Jane Smith",
        "email": "jane@example.com",
        "age": 25
    }
]);