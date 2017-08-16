DROP TABLE users;
DROP TABLE questions;
DROP TABLE question_follows;
DROP TABLE replies;
DROP TABLE question_likes;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  reply_id INTEGER,
  FOREIGN KEY (reply_id) REFERENCES replies(id),
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- ALTER TABLE replies
--   ADD reply_id INTEGER NOT NULL,
--   ADD FOREIGN KEY (reply_id) REFERENCES replies(id)

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES question(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Finn', 'the Human'),
  ('Jake', 'the Dog'),
  ('Princess', 'Bubblegum');

INSERT INTO
  questions (title, body, user_id)
VALUES
  ('WHY IS LIFE?', '42', (SELECT id FROM users WHERE fname = 'Finn')),
  ('WHY not is LIFE?', '72', (SELECT id FROM users WHERE fname = 'Jake')),
  ('WHY not is LIFE PIZZA?', 'PIZZA IS LIFE', (SELECT id FROM users WHERE fname = 'Princess')),
  ('WHY not is LIFE?', '72', (SELECT id FROM users WHERE fname = 'Jake')),
  ('WHY not is LIFE?', '72', (SELECT id FROM users WHERE fname = 'Jake'));
INSERT INTO
  question_follows (user_id, question_id)
VALUES
  (1,2),
  (2,1),
  (3,1);

INSERT INTO
  replies (question_id, user_id, reply_id, body)
VALUES
  (1,3,NULL, 'PRINCESS'),
  (1,2,1, 'jake!'),
  (1,1,1, 'Finn'),
  (1,3,2, 'princess AGAIN!');

  INSERT INTO
    question_likes (user_id, question_id)
  VALUES
    (2,1),
    (3,1),
    (1,2);
