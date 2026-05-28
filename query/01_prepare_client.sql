DROP TABLE IF EXISTS client;

CREATE TABLE client (
    id                  BIGSERIAL PRIMARY KEY,
    external_id         UUID,
    first_name          VARCHAR(100) NOT NULL,
    last_name           VARCHAR(100) NOT NULL,
    middle_name         VARCHAR(100),
    email               VARCHAR(255),
    phone               VARCHAR(32),
    birth_date          DATE,
    status              VARCHAR(32) NOT NULL DEFAULT 'active',
    is_verified         BOOLEAN NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);


-- Включаем расширение для генерации UUID
CREATE EXTENSION IF NOT EXISTS pgcrypto;

\timing on

INSERT INTO client (
    external_id,
    first_name,
    last_name,
    middle_name,
    email,
    phone,
    birth_date,
    status,
    is_verified,
    created_at,
    updated_at
)
SELECT
    gen_random_uuid()                                    AS external_id,
    'FirstName_' || gs                                   AS first_name,
    'LastName_' || gs                                    AS last_name,
    CASE
        WHEN random() < 0.7 THEN 'MiddleName_' || gs
        ELSE NULL
    END                                                  AS middle_name,
    'user' || gs || '@example.com'                       AS email,
    '+7' || lpad((floor(random() * 10^10))::text, 10, '0') AS phone,
    date '1950-01-01'
        + (random() * (date '2005-12-31' - date '1950-01-01'))::int
                                                         AS birth_date,
    CASE
        WHEN random() < 0.9 THEN 'active'
        ELSE 'blocked'
    END                                                  AS status,
    random() < 0.6                                       AS is_verified,
    now() - (random() * interval '5 years')              AS created_at,
    now() - (random() * interval '5 years')              AS updated_at
FROM generate_series(1, 1000000) gs;