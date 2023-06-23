-- BD1 CC1MD | PROJETO INTEGRADO |

-- ALUNOS: 
--         RAFAEL CHRISTIAN SILVA WERNESBACH
--         CAUÃ AGRISI MERISIO
--         SANDRO RICARDO MAGALHÃES FILHO
--         ANDRÉ VENTURINI DA PENHA (TRANCOU)
 
 
 
 -- INICIO DA CRIAÇÃO DE TABELAS
 
 
 
 
 
-- CRIAÇÃO DA TABELA "soft_skill"

CREATE TABLE public.soft_skill (

                soft_skill_id NUMERIC(9) NOT NULL,
                nome          VARCHAR    NOT NULL,
                descricao     VARCHAR(500)       ,
                
                
                CONSTRAINT soft_skill_id
                PRIMARY KEY (soft_skill_id)
);



-- CRIAÇÃO DA TABELA "hard_skill"

CREATE TABLE public.hard_skill (

                hard_skill_id NUMERIC(9)  NOT NULL,
                nome          VARCHAR     NOT NULL,
                descricao     VARCHAR(500)        ,
                
                
                CONSTRAINT hard_skill_id
                PRIMARY KEY (hard_skill_id)
);



-- CRIAÇÃO DA TABELA "endereco"

CREATE TABLE public.endereco (

                endereco_id NUMERIC(9)   NOT NULL,
                pais        VARCHAR(40)  NOT NULL,
                UF          VARCHAR(50)  NOT NULL,
                cidade      VARCHAR(50)  NOT NULL,
                logradouro  VARCHAR(100) NOT NULL,
                CEP         VARCHAR      NOT NULL,
                
                
                CONSTRAINT endereco_id
                PRIMARY KEY (endereco_id)
);



-- CRIAÇÃO DA TABELA "departamento"

CREATE TABLE public.departamento (

                departamento_id NUMERIC(3)  NOT NULL,
                nome            VARCHAR(30) NOT NULL,
                descricao       VARCHAR             ,
                
                
                CONSTRAINT departamento_id 
                PRIMARY KEY (departamento_id)
);



-- CRIAÇÃO DA TABELA "cargos"

CREATE TABLE public.cargos (

                cargo_id  NUMERIC(3)  NOT NULL,
                nome      VARCHAR(30) NOT NULL,
                descricao VARCHAR             ,
                
                
                CONSTRAINT cargo_id 
                PRIMARY KEY (cargo_id)
);



-- CRIAÇÃO DA TABELA "departamento"

CREATE TABLE public.cargos_departamento (

                cargos_departamento_id NUMERIC(9) NOT NULL,
                cargo_id               NUMERIC(3) NOT NULL,
                departamento_id        NUMERIC(3) NOT NULL,
                
                
                CONSTRAINT cargos_departamento_id
                PRIMARY KEY (cargos_departamento_id, cargo_id, departamento_id)
);



-- CRIAÇÃO DA TABELA "funcionarios"

CREATE TABLE public.funcionarios (

                cpf                NUMERIC(11)  NOT NULL,
                cargo_id           NUMERIC(3)   NOT NULL,
                endereco_id        NUMERIC(9)   NOT NULL,
                admissao           DATE         NOT NULL,
                nome               VARCHAR(100) NOT NULL,
                foto_do_perfil BYTEA,
                data_de_nascimento DATE         NOT NULL,
                senha              VARCHAR(30)  NOT NULL,
                nivel              NUMERIC(1)   NOT NULL,
                especializacao     VARCHAR(35),
                nacionalidade      VARCHAR(30)  NOT NULL,
                
                
                CONSTRAINT cpf 
                PRIMARY KEY (cpf)
);



-- CRIAÇÃO DA TABELA "funcionarios_hardskill"

CREATE TABLE public.funcionarios_hardskill (

                funcionarios_hardskill_id NUMERIC(9)  NOT NULL,
                hard_skill_id             NUMERIC(9)  NOT NULL,
                cpf                       NUMERIC(11) NOT NULL,
                
                
                CONSTRAINT funcionarios_hardskill_id
                PRIMARY KEY (funcionarios_hardskill_id, hard_skill_id, cpf)
);



-- CRIAÇÃO DA TABELA "funcionarios_softskill"

CREATE TABLE public.funcionarios_softskill (

                funcionarios_softskill_id NUMERIC(9)  NOT NULL,
                soft_skill_id             NUMERIC(9)  NOT NULL,
                cpf                       NUMERIC(11) NOT NULL,
                
                
                CONSTRAINT funcionarios_softskill_id
                PRIMARY KEY (funcionarios_softskill_id, soft_skill_id, cpf)
);



-- CRIAÇÃO DA TABELA "associacoes"

CREATE TABLE public.associacoes (

                associacoes_id NUMERIC(9) NOT NULL ,
                cargo_id       NUMERIC(3) NOT NULL ,
                cpf            NUMERIC(11) NOT NULL,
                endereco_id    NUMERIC(9) NOT NULL ,
                
                
                CONSTRAINT associacoes_id
                PRIMARY KEY (associacoes_id)
);



-- CRIAÇÃO DA TABELA "email"

CREATE TABLE public.email (

                email_id NUMERIC(9)  NOT NULL,
                cpf      NUMERIC(11) NOT NULL,
                email    VARCHAR     NOT NULL,
                
                
                CONSTRAINT email_id 
                PRIMARY KEY (email_id, cpf)
);



-- CRIAÇÃO DA TABELA "telefone"

CREATE TABLE public.telefone (

                telefone_id NUMERIC(9)  NOT NULL,
                cpf         NUMERIC(11) NOT NULL,
                numero      NUMERIC(9)  NOT NULL,
                DDD         NUMERIC(2)  NOT NULL,
                DDI         NUMERIC(3)  NOT NULL,
                
                
                CONSTRAINT telefone_id 
                PRIMARY KEY (telefone_id, cpf)
);



-- CRIAÇÃO DA TABELA "formacao"

CREATE TABLE public.formacao (

                formacao_id           NUMERIC(9)  NOT NULL,
                cpf                   NUMERIC(11) NOT NULL,
                instituicao_de_ensino VARCHAR     NOT NULL,
                curso                 VARCHAR     NOT NULL,
                ano_de_conclusao      VARCHAR     NOT NULL,
                
                
                CONSTRAINT formacao_id
                PRIMARY KEY (formacao_id)         
);




-- FIM DA CRIAÇÃO DE TABELAS 





-- INICIO DA CRIAÇÃO DAS RESTRIÇÕES LÓGICAS




--Restrição da coluna "senha" na tabela "funcionarios", onde a senha deve possuir no mínimo 8 caracteres.

ALTER TABLE    funcionarios
ADD CONSTRAINT RESTLOG01 
CHECK          (LENGTH(senha) >= 8);



-- Restrição da coluna "nivel" na tabela "funcionarios", onde só existem 3 niveis como foi descrito no comentário da coluna.

ALTER TABLE    funcionarios
ADD CONSTRAINT RESTOLOG02 
CHECK          (nivel IN ('1', '2', '3'));



-- FIM DA CRIAÇÃO DAS RESTRIÇÕES LÓGICAS





-- INICIO DA CRIAÇÃO DE RESTRIÇÕES DE CHAVE



-- Restrição de chave estrangeira para o ID da soft skill na tabela "soft_skill"
ALTER TABLE    public.funcionarios_softskill 
ADD CONSTRAINT soft_skill_perfil_softskill_fk
FOREIGN KEY    (soft_skill_id)
REFERENCES     public.soft_skill (soft_skill_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;



-- Adiciona uma restrição de chave estrangeira para o ID da hard skill na tabela "hard_skill".
ALTER TABLE    public.funcionarios_hardskill 
ADD CONSTRAINT hard_skill_perfil_hardskill_fk
FOREIGN KEY    (hard_skill_id)
REFERENCES     public.hard_skill (hard_skill_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;



-- Adiciona uma restrição de chave estrangeira para o ID do endereço na tabela "endereco".
ALTER TABLE    public.funcionarios 
ADD CONSTRAINT endereco_funcionarios_fk
FOREIGN KEY    (endereco_id)
REFERENCES     public.endereco (endereco_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;



-- Adiciona uma restrição de chave estrangeira para o ID do endereço na tabela "endereco".
ALTER TABLE    public.associacoes 
ADD CONSTRAINT endereco_associacoes_fk
FOREIGN KEY    (endereco_id)
REFERENCES     public.endereco (endereco_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;



-- Adiciona uma restrição de chave estrangeira para o ID do departamento na tabela "departamento".
ALTER TABLE    public.cargos_departamento 
ADD CONSTRAINT departamento_cargos_departamento_fk
FOREIGN KEY    (departamento_id)
REFERENCES     public.departamento (departamento_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;



-- Adiciona uma restrição de chave estrangeira para o ID do cargo na tabela "cargos".
ALTER TABLE    public.funcionarios 
ADD CONSTRAINT cargos_funcionarios_fk
FOREIGN KEY    (cargo_id)
REFERENCES     public.cargos (cargo_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;



-- Adiciona uma restrição de chave estrangeira para o ID do cargo na tabela "cargos".
ALTER TABLE    public.cargos_departamento 
ADD CONSTRAINT cargos_cargos_departamento_fk
FOREIGN KEY    (cargo_id)
REFERENCES     public.cargos (cargo_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;



-- Adiciona uma restrição de chave estrangeira para o ID do cargo na tabela "cargos".
ALTER TABLE    public.associacoes 
ADD CONSTRAINT cargos_associacoes_fk
FOREIGN KEY    (cargo_id)
REFERENCES     public.cargos (cargo_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;



-- Adiciona uma restrição de chave estrangeira para o CPF do funcionário na tabela "funcionarios".
ALTER TABLE    public.formacao
ADD CONSTRAINT funcionarios_formacao_fk
FOREIGN KEY    (cpf)
REFERENCES     public.funcionarios (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;



-- Adiciona uma restrição de chave estrangeira para o CPF do funcionário na tabela "funcionarios".
ALTER TABLE    public.telefone
ADD CONSTRAINT funcionarios_telefone_fk
FOREIGN KEY    (cpf)
REFERENCES     public.funcionarios (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;



-- Adiciona uma restrição de chave estrangeira para o CPF do funcionário na tabela "funcionarios".
ALTER TABLE    public.email 
ADD CONSTRAINT funcionarios_email_fk
FOREIGN KEY    (cpf)
REFERENCES     public.funcionarios (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;



-- Adiciona uma restrição de chave estrangeira para o CPF do funcionário na tabela "funcionarios".
ALTER TABLE    public.associacoes
ADD CONSTRAINT funcionarios_associacoes_fk
FOREIGN KEY    (cpf)
REFERENCES     public.funcionarios (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;



-- Adiciona uma restrição de chave estrangeira para o CPF do funcionário na tabela "funcionarios".
ALTER TABLE    public.funcionarios_softskill
ADD CONSTRAINT funcionarios_funcionarios_softskill_fk
FOREIGN KEY    (cpf)
REFERENCES     public.funcionarios (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;



-- Adiciona uma restrição de chave estrangeira para o CPF do funcionário na tabela "funcionarios".
ALTER TABLE    public.funcionarios_hardskill
ADD CONSTRAINT funcionarios_funcionarios_hardskill_fk
FOREIGN KEY    (cpf)
REFERENCES     public.funcionarios (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;




-- SESSÃO DE COMENTÁRIOS




COMMENT ON TABLE public.soft_skill                IS 'tabela que armazena as soft skills';
COMMENT ON COLUMN public.soft_skill.soft_skill_id IS 'id das soft_skill';
COMMENT ON COLUMN public.soft_skill.nome          IS 'nome da soft skill';
COMMENT ON COLUMN public.soft_skill.descricao     IS 'descrição da soft skill';


COMMENT ON TABLE public.hard_skill                IS 'tabela que armazena as hard skills';
COMMENT ON COLUMN public.hard_skill.hard_skill_id IS 'id da hard skill';
COMMENT ON COLUMN public.hard_skill.nome          IS 'nome da hard skill';
COMMENT ON COLUMN public.hard_skill.descricao     IS 'descrição da hard skill';


COMMENT ON TABLE public.endereco              IS 'tabela com os endereços dos funcionários';
COMMENT ON COLUMN public.endereco.endereco_id IS 'id dos endereços';
COMMENT ON COLUMN public.endereco.pais        IS 'país do endereço';
COMMENT ON COLUMN public.endereco.UF          IS 'UF do endereço';
COMMENT ON COLUMN public.endereco.cidade      IS 'cidade do endereço';
COMMENT ON COLUMN public.endereco.logradouro  IS 'logradouro do endereço';


COMMENT ON TABLE public.departamento                  IS 'tabela referente aos departamentos';
COMMENT ON COLUMN public.departamento.departamento_id IS 'id do departamento';
COMMENT ON COLUMN public.departamento.nome            IS 'nome do departamento';
COMMENT ON COLUMN public.departamento.descricao       IS 'descrição dos departamentos';


COMMENT ON TABLE public.cargos            IS 'cargos dos funcionários';
COMMENT ON COLUMN public.cargos.cargo_id  IS 'id dos cargos';
COMMENT ON COLUMN public.cargos.nome      IS 'nome do cargo';
COMMENT ON COLUMN public.cargos.descricao IS 'descrição dos cargos';


COMMENT ON TABLE public.cargos_departamento                         IS 'tabela intermediária entre cargos e departamento';
COMMENT ON COLUMN public.cargos_departamento.cargos_departamento_id IS 'pk da tabela intermediaria';
COMMENT ON COLUMN public.cargos_departamento.cargo_id               IS 'id dos cargos';
COMMENT ON COLUMN public.cargos_departamento.departamento_id        IS 'id do departamento';


COMMENT ON TABLE public.funcionarios                     IS 'tabela que armazena as informaç~eos dos funcionarios';
COMMENT ON COLUMN public.funcionarios.cpf                IS 'cpf dos funcionários';
COMMENT ON COLUMN public.funcionarios.cargo_id           IS 'id dos cargos';
COMMENT ON COLUMN public.funcionarios.endereco_id        IS 'id dos endereços';
COMMENT ON COLUMN public.funcionarios.admissao           IS 'data de admissão do funcionário';
COMMENT ON COLUMN public.funcionarios.nome               IS 'nome dos funcionarios';
COMMENT ON COLUMN public.funcionarios.foto_do_perfil     IS 'foto de perfil';
COMMENT ON COLUMN public.funcionarios.data_de_nascimento IS 'data de nascimento dos funcionários';
COMMENT ON COLUMN public.funcionarios.senha              IS 'senha do perfil';
COMMENT ON COLUMN public.funcionarios.nivel              IS 'nivel do perfil representa um nivel hirarquico em relação ao acesso das ferramentas e informações do banco de talentos, onde: 
                                                             Nivel 1: usuários comuns
                                                             Nivel 2: usuários com permissões e ferramentas de moderação
                                                             Nivel 3: usuários com cargos de gerencia que possuem permissões e ferramentas de administração e desenvolvimento do software';
COMMENT ON COLUMN public.funcionarios.especializacao     IS 'especialização caso exista dos funcionarios';
COMMENT ON COLUMN public.funcionarios.nacionalidade      IS 'nacionalidade do funcionário';


COMMENT ON TABLE public.funcionarios_hardskill                            IS 'tabela intermediaria entre as tabelas funcionários e hard_skill';
COMMENT ON COLUMN public.funcionarios_hardskill.funcionarios_hardskill_id IS 'id do funcionarios_hardskill';
COMMENT ON COLUMN public.funcionarios_hardskill.hard_skill_id             IS 'id da hard skill';
COMMENT ON COLUMN public.funcionarios_hardskill.cpf                       IS 'cpf dos funcionários';


COMMENT ON TABLE public.funcionarios_softskill                            IS 'tabela intermediaria entre as tabelas soft_skill e perfil';
COMMENT ON COLUMN public.funcionarios_softskill.funcionarios_softskill_id IS 'id da funcionarios_softskill';
COMMENT ON COLUMN public.funcionarios_softskill.soft_skill_id             IS 'id das soft_skill';
COMMENT ON COLUMN public.funcionarios_softskill.cpf                       IS 'cpf dos funcionários';


COMMENT ON TABLE public.associacoes              IS 'tabela para a resolução de dependencias transitivas';
COMMENT ON COLUMN public.associacoes.cargo_id    IS 'id dos cargos';
COMMENT ON COLUMN public.associacoes.cpf         IS 'cpf dos funcionários';
COMMENT ON COLUMN public.associacoes.endereco_id IS 'id dos endereços';


COMMENT ON TABLE public.email           IS 'tabela para armazenar os emails';
COMMENT ON COLUMN public.email.email_id IS 'id dos emails';
COMMENT ON COLUMN public.email.cpf      IS 'cpf dos funcionários';
COMMENT ON COLUMN public.email.email    IS 'emails cadastrados';


COMMENT ON TABLE public.telefone              IS 'tabela para armazenar os telefones dos funcionários';
COMMENT ON COLUMN public.telefone.telefone_id IS 'id dos telefones cadastrados';
COMMENT ON COLUMN public.telefone.cpf         IS 'cpf dos funcionários';
COMMENT ON COLUMN public.telefone.numero      IS 'numero dos telefones';
COMMENT ON COLUMN public.telefone.DDD         IS 'ddd dos telefones';
COMMENT ON COLUMN public.telefone.DDI         IS 'DDI dos telefones ';


COMMENT ON TABLE public.formacao                        IS 'formação dos funcionarios';
COMMENT ON COLUMN public.formacao.formacao_id           IS 'id da formação';
COMMENT ON COLUMN public.formacao.cpf                   IS 'cpf dos funcionários';
COMMENT ON COLUMN public.formacao.instituicao_de_ensino IS 'nome da instiuição de ensino';
COMMENT ON COLUMN public.formacao.curso                 IS 'curso realizado';
COMMENT ON COLUMN public.formacao.ano_de_conclusao      IS 'ano em que o curso foi concluido';







