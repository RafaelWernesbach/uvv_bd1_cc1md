-- REMOÇÃO DO SCHEMA "lojas" CASO EXISTA, E TODOS OS OBJETOS DEPENDENTES



DROP SCHEMA IF EXISTS bdt CASCADE;



-- REMOÇÃO DO BANCO DE DADOS "uvv" CASO EXISTA



DROP DATABASE IF EXISTS uvv;



-- REMOÇÃO DO USUÁRIO "RAFAEL" CASO EXISTA



DROP USER IF EXISTS rafael;


-- CRIAÇÃO DO USUÁRIO "RAFAEL"


CREATE USER rafael 
WITH ENCRYPTED PASSWORD 'pset'
SUPERUSER
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
 
-- CRIAÇÃO DO SCHEMA "bdt"

 
CREATE SCHEMA bdt;


-- TRANSFORMANDO O USUÁRIO "RAFAEL" PROPRIETÁRIO DO SCHEMA "bdt"

ALTER SCHEMA bdt OWNER TO rafael;


-- INICÍO DA CRIAÇÃO DAS TABELAS


CREATE TABLE bdt.soft_skill (
                soft_skill_id NUMERIC(9) NOT NULL,
                nome VARCHAR NOT NULL,
                descricao VARCHAR(500),
                CONSTRAINT soft_skill_id PRIMARY KEY (soft_skill_id)
);
COMMENT ON TABLE bdt.soft_skill IS 'tabela que armazena as soft skills';
COMMENT ON COLUMN bdt.soft_skill.soft_skill_id IS 'id das soft_skill';
COMMENT ON COLUMN bdt.soft_skill.nome IS 'nome da soft skill';
COMMENT ON COLUMN bdt.soft_skill.descricao IS 'descrição da soft skill';


CREATE TABLE bdt.hard_skill (
                hard_skill_id NUMERIC(9) NOT NULL,
                nome VARCHAR NOT NULL,
                descricao VARCHAR(500),
                CONSTRAINT hard_skill_id PRIMARY KEY (hard_skill_id)
);
COMMENT ON TABLE bdt.hard_skill IS 'tabela que armazena as hard skills';
COMMENT ON COLUMN bdt.hard_skill.hard_skill_id IS 'id da hard skill';
COMMENT ON COLUMN bdt.hard_skill.nome IS 'nome da hard skill';
COMMENT ON COLUMN bdt.hard_skill.descricao IS 'descrição da hard skill';


CREATE TABLE bdt.endereco (
                endereco_id NUMERIC(9) NOT NULL,
                pais VARCHAR(40) NOT NULL,
                UF VARCHAR(50) NOT NULL,
                cidade VARCHAR(50) NOT NULL,
                logradouro VARCHAR(100) NOT NULL,
                CEP VARCHAR NOT NULL,
                CONSTRAINT endereco_id PRIMARY KEY (endereco_id)
);
COMMENT ON TABLE bdt.endereco IS 'tabela com os endereços dos funcionários';
COMMENT ON COLUMN bdt.endereco.endereco_id IS 'id dos endereços';
COMMENT ON COLUMN bdt.endereco.pais IS 'país do endereço';
COMMENT ON COLUMN bdt.endereco.UF IS 'UF do endereço';
COMMENT ON COLUMN bdt.endereco.cidade IS 'cidade do endereço';
COMMENT ON COLUMN bdt.endereco.logradouro IS 'logradouro do endereço';


CREATE TABLE bdt.departamento (
                departamento_id NUMERIC(3) NOT NULL,
                nome VARCHAR(30) NOT NULL,
                descricao VARCHAR,
                CONSTRAINT departamento_id PRIMARY KEY (departamento_id)
);
COMMENT ON TABLE bdt.departamento IS 'tabela referente aos departamentos';
COMMENT ON COLUMN bdt.departamento.departamento_id IS 'id do departamento';
COMMENT ON COLUMN bdt.departamento.nome IS 'nome do departamento';
COMMENT ON COLUMN bdt.departamento.descricao IS 'descrição dos departamentos';


CREATE TABLE bdt.cargos (
                cargo_id NUMERIC(3) NOT NULL,
                departamento_id NUMERIC(3) NOT NULL,
                nome VARCHAR(30) NOT NULL,
                descricao VARCHAR,
                CONSTRAINT cargo_id PRIMARY KEY (cargo_id)
);
COMMENT ON TABLE bdt.cargos IS 'cargos dos funcionários';
COMMENT ON COLUMN bdt.cargos.cargo_id IS 'id dos cargos';
COMMENT ON COLUMN bdt.cargos.departamento_id IS 'id do departamento';
COMMENT ON COLUMN bdt.cargos.nome IS 'nome do cargo';
COMMENT ON COLUMN bdt.cargos.descricao IS 'descrição dos cargos
';


CREATE TABLE bdt.funcionarios (
                cpf NUMERIC(11) NOT NULL,
                cargo_id NUMERIC(3) NOT NULL,
                endereco_id NUMERIC(9) NOT NULL,
                admissao DATE NOT NULL,
                nome VARCHAR(100) NOT NULL,
                data_de_nascimento DATE NOT NULL,
                especializacao VARCHAR(35),
                nacionalidade VARCHAR(30) NOT NULL,
                CONSTRAINT cpf PRIMARY KEY (cpf)
);
COMMENT ON TABLE bdt.funcionarios IS 'tabela que armazena as informaç~eos dos funcionarios';
COMMENT ON COLUMN bdt.funcionarios.cpf IS 'cpf dos funcionários';
COMMENT ON COLUMN bdt.funcionarios.cargo_id IS 'id dos cargos';
COMMENT ON COLUMN bdt.funcionarios.endereco_id IS 'id dos endereços';
COMMENT ON COLUMN bdt.funcionarios.admissao IS 'data de admissão do funcionário';
COMMENT ON COLUMN bdt.funcionarios.nome IS 'nome dos funcionarios';
COMMENT ON COLUMN bdt.funcionarios.data_de_nascimento IS 'data de nascimento dos funcionários';
COMMENT ON COLUMN bdt.funcionarios.especializacao IS 'especialização caso exista dos funcionarios';
COMMENT ON COLUMN bdt.funcionarios.nacionalidade IS 'nacionalidade do funcionário';


CREATE TABLE bdt.perfil (
                perfil_id NUMERIC(9) NOT NULL,
                cpf NUMERIC(11) NOT NULL,
                nome_do_perfil VARCHAR(100) NOT NULL,
                bio VARCHAR(250),
                foto_do_perfil BYTEA,
                senha VARCHAR(30) NOT NULL,
                nivel NUMERIC(1) NOT NULL,
                CONSTRAINT perfil_id PRIMARY KEY (perfil_id)
);
COMMENT ON TABLE bdt.perfil IS 'perfil do funcionario';
COMMENT ON COLUMN bdt.perfil.perfil_id IS 'id do perfil';
COMMENT ON COLUMN bdt.perfil.cpf IS 'cpf dos funcionários';
COMMENT ON COLUMN bdt.perfil.nome_do_perfil IS 'nome do perfil';
COMMENT ON COLUMN bdt.perfil.bio IS 'biografia/descriçao do perfil';
COMMENT ON COLUMN bdt.perfil.foto_do_perfil IS 'foto de perfil';
COMMENT ON COLUMN bdt.perfil.senha IS 'senha do perfil';
COMMENT ON COLUMN bdt.perfil.nivel IS 'nivel do perfil representa um nivel hirarquico em relação ao acesso das ferramentas e informações do banco de talentos, onde: 

Nivel 1: usuários comuns
Nivel 2: usuários com permissões e ferramentas de moderação
Nivel 3: usuários com cargos de gerencia que possuem permissões e ferramentas de administração e desenvolvimento do software ';


CREATE TABLE bdt.perfil_softskill (
                perfil_softskill_id NUMERIC(9) NOT NULL,
                perfil_id NUMERIC(9) NOT NULL,
                soft_skill_id NUMERIC(9) NOT NULL,
                CONSTRAINT perfil_softskill_id PRIMARY KEY (perfil_softskill_id, perfil_id, soft_skill_id)
);
COMMENT ON TABLE bdt.perfil_softskill IS 'tabela intermediaria entre as tabelas soft_skill e perfil';
COMMENT ON COLUMN bdt.perfil_softskill.perfil_softskill_id IS 'id da perfil_softskill';
COMMENT ON COLUMN bdt.perfil_softskill.perfil_id IS 'id do perfil';
COMMENT ON COLUMN bdt.perfil_softskill.soft_skill_id IS 'id das soft_skill';


CREATE TABLE bdt.perfil_hardskill (
                perfil_hardskill_id NUMERIC(9) NOT NULL,
                perfil_id NUMERIC(9) NOT NULL,
                hard_skill_id NUMERIC(9) NOT NULL,
                CONSTRAINT perfil_hardskill_id PRIMARY KEY (perfil_hardskill_id, perfil_id, hard_skill_id)
);
COMMENT ON TABLE bdt.perfil_hardskill IS 'tabela intermediaria entre as tabelas perfil e hard_skill';
COMMENT ON COLUMN bdt.perfil_hardskill.perfil_hardskill_id IS 'id do perfil_hardskill';
COMMENT ON COLUMN bdt.perfil_hardskill.perfil_id IS 'id do perfil';
COMMENT ON COLUMN bdt.perfil_hardskill.hard_skill_id IS 'id da hard skill';


CREATE TABLE bdt.formacao (
                formacao_id VARCHAR(9) NOT NULL,
                cpf NUMERIC(11) NOT NULL,
                instituicao_de_ensino VARCHAR NOT NULL,
                curso VARCHAR NOT NULL,
                ano_de_conclusao VARCHAR NOT NULL,
                CONSTRAINT formacao_id PRIMARY KEY (formacao_id)
);
COMMENT ON TABLE bdt.formacao IS 'formação dos funcionarios';
COMMENT ON COLUMN bdt.formacao.formacao_id IS 'id da formação';
COMMENT ON COLUMN bdt.formacao.cpf IS 'cpf dos funcionários';
COMMENT ON COLUMN bdt.formacao.instituicao_de_ensino IS 'nome da instiuição de ensino';
COMMENT ON COLUMN bdt.formacao.curso IS 'curso realizado';
COMMENT ON COLUMN bdt.formacao.ano_de_conclusao IS 'ano em que o curso foi concluido';


ALTER TABLE bdt.perfil_softskill ADD CONSTRAINT soft_skill_perfil_softskill_fk
FOREIGN KEY (soft_skill_id)
REFERENCES bdt.soft_skill (soft_skill_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE bdt.perfil_hardskill ADD CONSTRAINT hard_skill_perfil_hardskill_fk
FOREIGN KEY (hard_skill_id)
REFERENCES bdt.hard_skill (hard_skill_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE bdt.funcionarios ADD CONSTRAINT endereco_funcionarios_fk
FOREIGN KEY (endereco_id)
REFERENCES bdt.endereco (endereco_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE bdt.cargos ADD CONSTRAINT departamento_cargos_fk
FOREIGN KEY (departamento_id)
REFERENCES bdt.departamento (departamento_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE bdt.funcionarios ADD CONSTRAINT cargos_funcionarios_fk
FOREIGN KEY (cargo_id)
REFERENCES bdt.cargos (cargo_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE bdt.formacao ADD CONSTRAINT funcionarios_formacao_fk
FOREIGN KEY (cpf)
REFERENCES bdt.funcionarios (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE bdt.perfil ADD CONSTRAINT funcionarios_perfil_fk
FOREIGN KEY (cpf)
REFERENCES bdt.funcionarios (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE bdt.perfil_hardskill ADD CONSTRAINT perfil_perfil_hardskill_fk
FOREIGN KEY (perfil_id)
REFERENCES bdt.perfil (perfil_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE bdt.perfil_softskill ADD CONSTRAINT perfil_perfil_softskill_fk
FOREIGN KEY (perfil_id)
REFERENCES bdt.perfil (perfil_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;










