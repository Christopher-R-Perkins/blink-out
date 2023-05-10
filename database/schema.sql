CREATE TABLE highscores (
  seed char(12) NOT NULL UNIQUE CHECK (seed ~ '^[0-9a-f]{12}$'),
  score integer NOT NULL CHECK (score > 0)
);
