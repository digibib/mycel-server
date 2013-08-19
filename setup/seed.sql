USE mycel2;
INSERT INTO UserTypes (label) VALUES ('Library user'), ('Guest user'), ('Anonymous user');
INSERT INTO LevelTypes (label) VALUES ('Organization'), ('Branch'), ('Department');

INSERT INTO Levels (type, label) VALUES (1, 'Deichmanske Bibliotek');
INSERT INTO Levels (type, label, parent) VALUES (2, 'Hovedbiblioteket', 1),
                                                (3, 'Digital testavdeling', 2),
                                                (3, 'Voksenavdelingen', 2),
                                                (3, 'Musikkavdelingen', 2),
                                                (3, 'Unge Deichman', 2),
                                                (3, 'Vestibylen', 2);

INSERT INTO Admins (username, password, password_salt) VALUES ("superbruker", "suppebruker", "pepper");
INSERT INTO Admins (username, password, password_salt) VALUES ("petter", "petter", "sjø");

INSERT INTO LevelAdmins (level, admin) VALUES (1, 1), (3, 2);