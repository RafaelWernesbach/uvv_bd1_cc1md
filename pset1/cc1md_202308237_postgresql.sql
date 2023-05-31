--                                                                 | PSET01 |



-- ALUNO: RAFAEL CHRISTIAN SILVA WERNESBACH
-- TURMA: CC1MD
-- MATRÍCULA: 202308237
-- EMAIL: nkmnoff@gmail.com



-- REMOÇÃO DO SCHEMA "lojas" CASO EXISTA, E TODOS OS OBJETOS DEPENDENTES



DROP SCHEMA IF EXISTS lojas CASCADE;



-- REMOÇÃO DO BANCO DE DADOS "uvv" CASO EXISTA



DROP DATABASE IF EXISTS uvv;



-- REMOÇÃO DO USUÁRIO "RAFAEL" CASO EXISTA



DROP USER IF EXISTS rafael;



-- CRIAÇÃO DO USUÁRIO "RAFAEL"



CREATE USER rafael 
WITH ENCRYPTED PASSWORD 'pset'
CREATEDB
CREATEROLE
LOGIN
 
;


-- CRIAÇÃO DO BANCO DE DADOS "uvv"



  CREATE DATABASE uvv
  OWNER = rafael
  template = template0
  encoding = UTF8
  lc_collate = 'pt_BR.UTF-8'
  lc_ctype = 'pt_BR.UTF-8'
  ALLOW_CONNECTIONS = TRUE;

 \c "host=localhost dbname=uvv user=rafael password=pset"

 
-- CRIAÇÃO DO SCHEMA "lojas"

 
CREATE SCHEMA lojas;


-- TRANSFORMANDO O USUÁRIO "RAFAEL" PROPRIETÁRIO DO SCHEMA "lojas"


ALTER SCHEMA lojas OWNER TO rafael;


-- INICÍO DA CRIAÇÃO DAS TABELAS





--CRIAÇÃO DA TABELA "lojas"

CREATE TABLE lojas.lojas (

                loja_id                 NUMERIC  (38)   NOT NULL,
                nome                    VARCHAR  (255)  NOT NULL,
                endereco_fisico         VARCHAR  (512)          ,
                endereco_web            VARCHAR  (100)          ,
                latitude                VARCHAR  (19)           ,
                longitude               VARCHAR  (19)           ,
                logo                    BYTEA                   ,
                logo_charset            VARCHAR  (512)          ,
                logo_mime_type          VARCHAR  (512)          ,
                logo_arquivo            VARCHAR  (512)          ,
                logo_ultima_atualizacao DATE                    ,

                CONSTRAINT loja_id 
                PRIMARY KEY (loja_id)
);

-- CRIAÇÃO DA TABELA "clientes"

CREATE TABLE lojas.clientes (

                cliente_id NUMERIC(38)  NOT NULL,
                email      VARCHAR(255) NOT NULL,
                nome       VARCHAR(255) NOT NULL,
                telefone1  VARCHAR(20)          ,                        
                telefone2  VARCHAR(20)          ,
                telefone3  VARCHAR(20)          ,

               CONSTRAINT cliente_id 
               PRIMARY KEY (cliente_id)
);

-- CRIAÇÃO DA TABEÇA "produtos"

CREATE TABLE lojas.produtos (

                produto_id                NUMERIC(38)  NOT NULL,
                nome                      VARCHAR(255) NOT NULL,
                preco_unitario            NUMERIC(10,2)        ,
                detalhes                  BYTEA                ,
                imagem                    BYTEA                ,
                imagem_mime_type          VARCHAR(512)         ,
                imagem_arquivo            VARCHAR(512)         ,
                imagem_charset            VARCHAR(512)         ,
                imagem_ultima_atualizacao DATE                 ,

                CONSTRAINT produto_id 
                PRIMARY KEY (produto_id)
);

-- CRIAÇÃO DA TABELA "envios"

CREATE TABLE lojas.envios (

                envio_id            NUMERIC(38)  NOT NULL,
                loja_id             NUMERIC(38)  NOT NULL,
                cliente_id          NUMERIC(38)  NOT NULL,
                endereco_entrega    VARCHAR(512) NOT NULL,
                status              VARCHAR(15)  NOT NULL,

                CONSTRAINT envio_id 
                PRIMARY KEY (envio_id)
);

-- CRIAÇÃO DA TABELA "pedidos"

CREATE TABLE lojas.pedidos (

                pedido_id       NUMERIC(38) NOT NULL,
                cliente_id      NUMERIC(38) NOT NULL,
                loja_id         NUMERIC(38) NOT NULL,
                data_hora       TIMESTAMP   NOT NULL,
                status          VARCHAR(15) NOT NULL,

                CONSTRAINT pedido_id 
                PRIMARY KEY (pedido_id)
     
);

-- CRIAÇÃO DA TABELA "estoques"

CREATE TABLE lojas.estoques (
                estoque_id            NUMERIC(38) NOT NULL,
                loja_id               NUMERIC(38) NOT NULL,
                produto_id            NUMERIC(38) NOT NULL,
                quantidade            NUMERIC(38) NOT NULL,
                
                CONSTRAINT estoque_id 
                PRIMARY KEY (estoque_id)
);

-- CRIAÇÃO DA TABELA "pedidos_itens"

CREATE TABLE lojas.pedidos_itens (

                produto_id               NUMERIC(38)   NOT NULL,
                pedido_id                NUMERIC(38)   NOT NULL,
                envio_id                 NUMERIC(38)   NOT NULL,
                numero_da_linha          NUMERIC(38)   NOT NULL,
                preco_unitario           NUMERIC(10,2) NOT NULL,
                quantidade               NUMERIC(38)   NOT NULL,

                CONSTRAINT pedidos_itens_pk 
                PRIMARY KEY (produto_id, pedido_id, envio_id, numero_da_linha)
);

-- RESTRIÇÕES LOGICAS DE ALGUMAS COLUNAS

ALTER TABLE    lojas.pedidos
ADD CONSTRAINT RESTLOG1 
CHECK          (status IN ('CANCELADO', 'COMPLETO', 'ABERTO', 'PAGO', 'REEMBOLSADO','ENVIADO'));

ALTER TABLE    lojas.envios
ADD CONSTRAINT RESTLOG2
CHECK          (status IN ('CRIADO', 'ENVIADO', 'TRANSITO', 'ENTREGUE'));

ALTER TABLE    lojas.lojas
ADD CONSTRAINT RESTLOG3 
CHECK          (endereco_web IS NOT NULL OR endereco_fisico IS NOT NULL);

ALTER TABLE    lojas.produtos
ADD CONSTRAINT RESTLOG4 
CHECK          (preco_unitario >= 0);

ALTER TABLE    lojas.estoques
ADD CONSTRAINT RESTLOG5 
CHECK          (quantidade >= 0);

ALTER TABLE    lojas.pedidos_itens
ADD CONSTRAINT RESTLOG6 
CHECK          (preco_unitario >= 0);

ALTER TABLE    lojas.pedidos_itens
ADD CONSTRAINT RESTLOG7 
CHECK          (quantidade >= 0);





-- Adicionando a restrição FOREIGN KEY (cliente_id)

ALTER TABLE         lojas.pedidos
ADD CONSTRAINT      clientes_pedidos_fk
FOREIGN KEY         (cliente_id)
REFERENCES          lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


-- Adicionando a restrição FOREIGN KEY (cliente_id)

ALTER TABLE         lojas.envios
ADD CONSTRAINT      clientes_envios_fk
FOREIGN KEY         (cliente_id)
REFERENCES          lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


-- Adicionando a restrição FOREIGN KEY (produto_id)

ALTER TABLE         lojas.estoques
ADD CONSTRAINT      produtos_estoques_fk
FOREIGN KEY         (produto_id)
REFERENCES          lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


-- Adicionando a restrição FOREIGN KEY (produto_id)

ALTER TABLE         lojas.pedidos_itens
ADD CONSTRAINT      produtos_pedidos_itens_fk
FOREIGN KEY         (produto_id)
REFERENCES          lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


-- Adicionando a restrição FOREIGN KEY (loja_id)

ALTER TABLE          lojas.estoques
ADD CONSTRAINT       lojas_estoques_fk
FOREIGN KEY          (loja_id)
REFERENCES           lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


-- Adicionando a restrição FOREIGN KEY (loja_id)

ALTER TABLE         lojas.pedidos
ADD CONSTRAINT      lojas_pedidos_fk
FOREIGN KEY         (loja_id)
REFERENCES          lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


-- Adicionando a restrição FOREIGN KEY (loja_id)

ALTER TABLE         lojas.envios
ADD CONSTRAINT      lojas_envios_fk
FOREIGN KEY         (loja_id)
REFERENCES          lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


-- Adicionando a restrição FOREIGN KEY (envio_id)

ALTER TABLE         lojas.pedidos_itens
ADD CONSTRAINT      envios_pedidos_itens_fk
FOREIGN KEY         (envio_id)
REFERENCES          lojas.envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


-- Adicionando a restrição FOREIGN KEY (pedido_id)

ALTER TABLE         lojas.pedidos_itens
ADD CONSTRAINT      pedidos_pedidos_itens_fk
FOREIGN KEY         (pedido_id)
REFERENCES          lojas.pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- COMENTARIO DO BANCO DE DADOS

COMMENT ON DATABASE uvv IS 'Banco de dados uvv';


-- COMENTÁRIOS DAS TABELAS


-- TABELA "lojas"

COMMENT ON TABLE lojas.lojas                          IS 'Armazena informações relacionadas as lojas registradas no sistema';
COMMENT ON COLUMN lojas.lojas.loja_id                 IS 'ID da loja';
COMMENT ON COLUMN lojas.lojas.nome                    IS 'Nome da loja';
COMMENT ON COLUMN lojas.lojas.endereco_fisico         IS 'Endereço físico da loja';
COMMENT ON COLUMN lojas.lojas.endereco_web            IS 'Endereço web da loja';
COMMENT ON COLUMN lojas.lojas.latitude                IS 'Latitude geográfica da localização da loja';
COMMENT ON COLUMN lojas.lojas.longitude               IS 'Longitude geográfica da localização da loja';
COMMENT ON COLUMN lojas.lojas.logo                    IS 'Logo da loja';
COMMENT ON COLUMN lojas.lojas.logo_charset            IS 'Charset do arquivo de logo da loja';
COMMENT ON COLUMN lojas.lojas.logo_mime_type          IS 'Tipo MIME do arquivo de logo da loja';
COMMENT ON COLUMN lojas.lojas.logo_arquivo            IS 'Caminho para o arquivo do logo da loja';
COMMENT ON COLUMN lojas.lojas.logo_ultima_atualizacao IS 'Data da última atualização do logo da loja';


-- TABELA "clientes"

COMMENT ON TABLE lojas.clientes             IS 'Armazena informações relacionadas aos clientes cadastrados';
COMMENT ON COLUMN lojas.clientes.cliente_id IS 'ID do cliente';
COMMENT ON COLUMN lojas.clientes.nome       IS 'Nome do cliente';
COMMENT ON COLUMN lojas.clientes.email      IS 'Endereço de e-mail do cliente';
COMMENT ON COLUMN lojas.clientes.telefone1  IS 'Primeiro telefone do cliente';
COMMENT ON COLUMN lojas.clientes.telefone2  IS 'Segundo telefone do cliente';
COMMENT ON COLUMN lojas.clientes.telefone2  IS 'Terceiro telefone do cliente';



-- TABELA "produtos"

COMMENT ON TABLE lojas.produtos                            IS 'Armazena informações relacionadas aos produtos das lojas cadastradas';
COMMENT ON COLUMN lojas.produtos.produto_id                IS 'ID do produto';
COMMENT ON COLUMN lojas.produtos.nome                      IS 'Nome do produto';
COMMENT ON COLUMN lojas.produtos.preco_unitario            IS 'Preço unitário do produto';
COMMENT ON COLUMN lojas.produtos.detalhes                  IS 'Detalhes do produto';
COMMENT ON COLUMN lojas.produtos.imagem                    IS 'Imagem do produto';
COMMENT ON COLUMN lojas.produtos.imagem_mime_type          IS 'MIME da imagem do produto';
COMMENT ON COLUMN lojas.produtos.imagem_arquivo            IS 'arquivo da imagem do produto';
COMMENT ON COLUMN lojas.produtos.imagem_charset            IS 'Charset do arquivo da imagem do produto';
COMMENT ON COLUMN lojas.produtos.imagem_ultima_atualizacao IS 'última atualização da imagem do produto';


-- TABELA "envios"

COMMENT ON TABLE lojas.envios                   IS 'Armazena informações relacionadas aos envios dos pedidos';
COMMENT ON COLUMN lojas.envios.envio_id         IS 'ID do envio';
COMMENT ON COLUMN lojas.envios.loja_id          IS 'ID da loja';
COMMENT ON COLUMN lojas.envios.cliente_id       IS 'ID do cliente';
COMMENT ON COLUMN lojas.envios.endereco_entrega IS 'Endereço de entrega';
COMMENT ON COLUMN lojas.envios.status           IS 'Status de envio';


-- TABELA "pedidos"

COMMENT ON TABLE lojas.pedidos              IS 'Armazena informações relacionadas aos pedidos das lojas cadastradas';
COMMENT ON COLUMN lojas.pedidos.pedido_id   IS 'ID do pedido';
COMMENT ON COLUMN lojas.pedidos.cliente_id  IS 'ID do cliente';
COMMENT ON COLUMN lojas.pedidos.loja_id     IS 'ID da loja';
COMMENT ON COLUMN lojas.pedidos.data_hora   IS 'Data e hora em que o pedido foi realizado';
COMMENT ON COLUMN lojas.pedidos.status      IS 'Status do pedido';


-- TABELA "estoques"

COMMENT ON TABLE lojas.estoques             IS 'Armazena informações relacionadas ao estoque de produtos das lojas cadastradas';
COMMENT ON COLUMN lojas.estoques.estoque_id IS 'ID do estoque';
COMMENT ON COLUMN lojas.estoques.loja_id    IS 'ID da loja';
COMMENT ON COLUMN lojas.estoques.produto_id IS 'ID do produto';
COMMENT ON COLUMN lojas.estoques.quantidade IS 'Quantidade do produto no estoque';


-- TABELA "pedidos_itens"

COMMENT ON TABLE lojas.pedidos_itens                  IS 'Armazena informações relacionadas aos itens dos pedidos';
COMMENT ON COLUMN lojas.pedidos_itens.produto_id      IS 'ID do produto';
COMMENT ON COLUMN lojas.pedidos_itens.pedido_id       IS 'ID do pedido';
COMMENT ON COLUMN lojas.pedidos_itens.envio_id        IS 'ID do envio';
COMMENT ON COLUMN lojas.pedidos_itens.numero_da_linha IS 'Número da linha do pedido';
COMMENT ON COLUMN lojas.pedidos_itens.preco_unitario  IS 'Preço unitário do item do pedido';
COMMENT ON COLUMN lojas.pedidos_itens.quantidade      IS 'Quantidade de itens do pedido';



-- CONSIDERAÇÕES FINAIS:



-- Reservei este espaço para expressar minhas considerações em relação ao PSET01.

-- O trabalho se mostrou desafiador do começo ao fim, acredito que a parte mais facil tenha sido a elaboração do diagrama 
-- relacional de forma correta, o que ja me custou alguns dias, entretanto a conclusão do script global foi realizadora, posso afirmar
-- através deste trabalho pude ampliar meus conhecimentos e me tornar capaz de resolver problemas complexos por conta própria.
