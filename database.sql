--DROP SCHEMA public CASCADE; This is to delete the table that remained
--CREATE SCHEMA public;

DROP DATABASE IF EXISTS dblaunchstore;
CREATE DATABASE dblaunchstore;

CREATE TABLE "products" (
  "id" SERIAL PRIMARY KEY,
  "category_id" int NOT NULL,
  "user_id" int,
  "name" text NOT NULL,
  "description" text NOT NULL,
  "old_price" int,
  "price" int NOT NULL,
  "quantity" int DEFAULT 0,
  "status" int DEFAULT 1,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "categories" (
  "id" SERIAL PRIMARY KEY,
  "name" text NOT NULL
);

INSERT INTO categories(name) VALUES ('Comida');
INSERT INTO categories(name) VALUES ('Eletrônicos');
INSERT INTO categories(name) VALUES ('Automóveis');

CREATE TABLE "files" (
  "id" SERIAL PRIMARY KEY,
  "name" text,
  "path" text NOT NULL,
  "product_id" int
);



ALTER TABLE "products" ADD FOREIGN KEY ("category_id") REFERENCES "categories" ("id");
ALTER TABLE "files" ADD FOREIGN KEY ("product_id") REFERENCES "products" ("id");


CREATE TABLE "users" (
  "id" SERIAL PRIMARY KEY,
  "name" text NOT NULL,
  "email" text UNIQUE NOT NULL,
  "password" text NOT NULL,
  "cpf_cnpj" text UNIQUE NOT NULL,
  "cep" text,
  "address" text,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

ALTER TABLE "products" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

-- password token,  added to fields
--ALTER TABLE "users" ADD COLUMN reset_token text;
--ALTER TABLE "users" ADD COLUMN reset_token_expires text;

-- Creating procedure for field updated_at
--CREATE FUNCTION trigger_set_timestamp()
--RETURNS TRIGGER AS 
--$$
--BEGIN
--  NEW.updated_at = NOW();
--  RETURN NEW;
--END;

--$$ LANGUAGE plpgsql;

-- Creating trigger for PROCEDURE trigger_set_timestamp on PRODUCTS
--CREATE TRIGGER set_timestamp 
--BEFORE UPDATE ON products 
--FOR EACH ROW 
--EXECUTE PROCEDURE trigger_set_timestamp();


-- Creating trigger for PROCEDURE trigger_set_timestamp on USERS
--CREATE TRIGGER set_timestamp 
--BEFORE UPDATE ON users 
--FOR EACH ROW 
--EXECUTE PROCEDURE trigger_set_timestamp();

-- connect=pg-simple TABLE
CREATE TABLE "session" (
 -- "sid" varchar NOT NULL COLLATE "default",
	"sess" json NOT NULL,
	"expire" timestamp(6) NOT NULL
)
--WITH (OIDS=FALSE);

--ALTER TABLE "session" ADD CONSTRAINT "session_pkey" PRIMARY KEY ("sid") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- Cascade EFFECT
-- Changing TABLES products and files for when deleting users
--ALTER TABLE "products"
--DROP CONSTRAINT products_user_id_fkey, 
--ADD CONSTRAINT products_user_id_fkey
--FOREIGN KEY ("user_id")
--REFERENCES "users" ("id")
--ON DELETE CASCADE;

--ALTER TABLE "files"
--DROP CONSTRAINT files_product_id_fkey,
--ADD CONSTRAINT files_product_id_fkey
--FOREIGN KEY ("product_id")
--REFERENCES "products" ("id")
--ON DELETE CASCADE;


-- to run seeds
DELETE FROM products;
DELETE FROM users;
DELETE FROM files;

-- restart sequence auto-increment from tables ids
ALTER SEQUENCE products_id_seq RESTART WITH 1;
ALTER SEQUENCE users_id_seq RESTART WITH 1;
ALTER SEQUENCE files_id_seq RESTART WITH 1;

-- creating table orders 
CREATE TABLE "orders"(
"id" SERIAL PRIMARY KEY,
"seller_id" int NOT NULL,
"buyer_id" int NOT NULL,
"product_id" int NOT NULL,
"price" int NOT NULL,
"quantity" int DEFAULT 0,
"total" int NOT NULL,
"status" text NOT NULL,
"created_at" timestamp DEFAULT (now()),
"updated_at" timestamp DEFAULT (now())
);

ALTER TABLE "orders" ADD FOREIGN KEY ("seller_id") REFERENCES "users" ("id");
ALTER TABLE "orders" ADD FOREIGN KEY ("buyer_id") REFERENCES "users" ("id");
ALTER TABLE "orders" ADD FOREIGN KEY ("product_id") REFERENCES "products" ("id");



--CREATE TRIGGER set_timeStamp
--BEFORE UPDATE ON orders
--FOR EACH ROW
--EXECUTE PROCEDURE trigger_set_timestamp();

-- Estrategia de Soft delete--SOFT DELETION
-- ADICIONAR UMA COLUNA NA TABELA product CHAMADA deleted_at (sempre sera valor nulo)
--ALTER TABLE products ADD COLUMN "deleted_at" timestamp;

-- CRIAR UMA REGRA (RULE) QUE DISPARE QUANDO UM PRODUTO FOR DELETADO( CAMPO deleted_at SERA POPULADO)
--CREATE OR REPLACE RULE delete_product AS 
--ON DELETE TO products
--DO INSTEAD 
--UPDATE products 
--SET deleted_at  = now()
--WHERE products.id = old.id; 

-- CRIAR UMA "VIEW" TRAZENDO TUDO DA TABELA PRODUTO EM QUE O CAMPO deleted_at SEJA  == NULL
--CREATE VIEW products_not_deleted AS
--SELECT * FROM products WHERE deleted_at IS NULL; 


-- RENOMEAR A "PRODUTO" PARA OUTRO "NOME" 
--ALTER TABLE products RENAME TO product_with_deleted;


-- RENOMEAR A "VIEW" PARA "PRODUTO"
--ALTER VIEW products_not_deleted RENAME TO products;