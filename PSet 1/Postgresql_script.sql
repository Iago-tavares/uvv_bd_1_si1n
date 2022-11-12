
create user iago with password '123';
alter user iago with SUPERUSER; 


CREATE DATABASE uvv
    WITH
    OWNER = iago
    ENCODING = 'UTF8'
    LC_COLLATE = 'Portuguese_Brazil.1252'
    LC_CTYPE = 'Portuguese_Brazil.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

    grant temporary, connect on database uvv to Public;

    GRANT all on database uvv to iago;

    alter default privileges
    GRANT ALL ON TABLES TO IAGO;

    \c uvv;
    
   create schema hr;
   
  SET SEARCH_PATH TO hr;



CREATE TABLE hr.cargos (
                id_cargo VARCHAR(10) NOT NULL,
                cargo VARCHAR(35) NOT NULL,
                salario_minimo NUMERIC(8,2),
                salario_maximo NUMERIC(8,2),
                CONSTRAINT cargos_pk PRIMARY KEY (id_cargo)
);
COMMENT ON TABLE hr.cargos IS 'tabela que armazena os cargos existentes assim como o salario minimo e maximo para cada cargo.';
COMMENT ON COLUMN hr.cargos.id_cargo IS 'id individual de cada cargo, usado como chave primaria.';
COMMENT ON COLUMN hr.cargos.cargo IS 'nome de cada cargo exercido na empresa.';
COMMENT ON COLUMN hr.cargos.salario_minimo IS 'valor minimo para o salario de cada cargo escrito em numeros decimais.';
COMMENT ON COLUMN hr.cargos.salario_maximo IS 'valor maximo para o salario de cada cargo escrito em numeros decimais.';


CREATE UNIQUE INDEX cargos_idx
 ON hr.cargos
 ( cargo );

CREATE TABLE hr.regioes (
                id_regiao INTEGER NOT NULL,
                nome VARCHAR(25) NOT NULL,
                CONSTRAINT regioes_pk PRIMARY KEY (id_regiao)
);
COMMENT ON TABLE hr.regioes IS 'tabela referrente ao id e nome das regiões.';
COMMENT ON COLUMN hr.regioes.id_regiao IS 'coluna que corresponde ao id unico de cada região como uma PK.';
COMMENT ON COLUMN hr.regioes.nome IS 'coluna que corresponde ao nome unico de cada região.';


CREATE UNIQUE INDEX regioes_idx
 ON hr.regioes
 ( nome );

CREATE TABLE hr.paises (
                id_pais CHAR(2) NOT NULL,
                id_regiao INTEGER,
                nome VARCHAR(50) NOT NULL,
                CONSTRAINT paises_pk PRIMARY KEY (id_pais)
);
COMMENT ON TABLE hr.paises IS 'tabela que armazena informaçoes sobre os paises.';
COMMENT ON COLUMN hr.paises.id_pais IS 'coluna que corresponde ao id unico de cada país como uma PK.';
COMMENT ON COLUMN hr.paises.id_regiao IS 'coluna que faz referrencia ao id da região de cada país, usando como referencia a tabela regioes.';
COMMENT ON COLUMN hr.paises.nome IS 'coluna que corresponde ao nome unico de cada país.';


CREATE UNIQUE INDEX paises_idx
 ON hr.paises
 ( nome );

CREATE TABLE hr.localizacao (
                id_localizacao INTEGER NOT NULL,
                id_pais CHAR(2),
                endereco VARCHAR(50),
                cep VARCHAR(12),
                cidade VARCHAR(50),
                uf VARCHAR(25),
                CONSTRAINT localizacao_pk PRIMARY KEY (id_localizacao)
);
COMMENT ON TABLE hr.localizacao IS 'tabela que armazena informaçoes sobre a localização de facilidades da empresa';
COMMENT ON COLUMN hr.localizacao.id_localizacao IS 'coluna que corresponde ao id unico de cada localização como uma PK.';
COMMENT ON COLUMN hr.localizacao.id_pais IS 'coluna que faz referrencia ao id do país de cada localização, usando como referencia a tabela paises.';
COMMENT ON COLUMN hr.localizacao.endereco IS 'coluna que contem as informaçoes do endereço de cada localização das facilidades da empresa.';
COMMENT ON COLUMN hr.localizacao.cep IS 'coluna que contem as informaçoes do CEP de cada localização das facilidades da empresa.';
COMMENT ON COLUMN hr.localizacao.cidade IS 'coluna que contem as informaçoes da cidade de cada localização das facilidades da empresa.';
COMMENT ON COLUMN hr.localizacao.uf IS 'coluna que contem as informaçoes do  Unidade da Federação de cada localização das facilidades da empresa.';


CREATE TABLE hr.departamentos (
                id_departamento INTEGER NOT NULL,
                id_gerente INTEGER,
                nome VARCHAR(50),
                id_localizacao INTEGER,
                CONSTRAINT departamentos_pk PRIMARY KEY (id_departamento)
);
COMMENT ON TABLE hr.departamentos IS 'tabela que contem informações sobre cada departamento da empresa.';
COMMENT ON COLUMN hr.departamentos.id_departamento IS 'coluna que corresponde ao id unico de cada departamento como uma PK.';
COMMENT ON COLUMN hr.departamentos.id_gerente IS 'coluna que corresponde ao id unico do gerente de cada departamento.';
COMMENT ON COLUMN hr.departamentos.nome IS 'coluna que contem as informaçoes do nome unico de cada departamento da empresa.';
COMMENT ON COLUMN hr.departamentos.id_localizacao IS 'coluna que faz referrencia ao id da localiazação de cada departamento, usando como referencia a tabela localizacao.';


CREATE UNIQUE INDEX departamentos_idx
 ON hr.departamentos
 ( id_gerente, nome );

CREATE TABLE hr.empregados (
                id_empregado INTEGER NOT NULL,
                nome VARCHAR(75) NOT NULL,
                email VARCHAR(35) NOT NULL,
                telefone VARCHAR(20),
                data_contratacao DATE NOT NULL,
                id_cargo VARCHAR(10) NOT NULL,
                salario NUMERIC(8,2),
                comissao NUMERIC(4,2),
                id_departamento INTEGER,
                id_supervisor INTEGER,
                CONSTRAINT empregados_pk PRIMARY KEY (id_empregado)
);
COMMENT ON TABLE hr.empregados IS 'tabela que armazena informações referentes aos empregados da empresa.';
COMMENT ON COLUMN hr.empregados.id_empregado IS 'coluna que corresponde ao id unico de cada empregado como uma PK.';
COMMENT ON COLUMN hr.empregados.nome IS 'coluna que contem as informaçoes do nome de cada empregado da empresa.';
COMMENT ON COLUMN hr.empregados.email IS 'coluna que corresponde ao e-mail pessoal de cada funcionario.';
COMMENT ON COLUMN hr.empregados.telefone IS 'coluna que contem as informaçoes do telefone de cada empregado da empresa.';
COMMENT ON COLUMN hr.empregados.data_contratacao IS 'coluna que contem as informaçoes sobre a data de contratação de cada empregado da empresa.';
COMMENT ON COLUMN hr.empregados.id_cargo IS 'coluna que faz referrencia ao id do cargo exercido por cada empregado, usando como referencia a tabela cargos.';
COMMENT ON COLUMN hr.empregados.salario IS 'coluna que contem as informaçoes sobre os salarios de cada funcionario da empresa.';
COMMENT ON COLUMN hr.empregados.comissao IS 'coluna referrente a comissão recebida por funcionarios do departamento de vendas após realizar uma venda com sucesso';
COMMENT ON COLUMN hr.empregados.id_departamento IS 'coluna que faz referrencia ao id do depattamento ao qual cada empregado pertence, usando como referencia a tabela departamentos.';
COMMENT ON COLUMN hr.empregados.id_supervisor IS 'coluna que corresponde ao id do supervisor dirreto de cada empregado.';


CREATE UNIQUE INDEX empregados_idx
 ON hr.empregados
 ( email );

CREATE TABLE hr.historico_cargos (
                id_empregado INTEGER NOT NULL,
                data_inicial DATE NOT NULL,
                data_final DATE NOT NULL,
                id_departamento INTEGER,
                id_cargo VARCHAR(10) NOT NULL,
                CONSTRAINT historico_cargos_pk PRIMARY KEY (id_empregado, data_inicial)
);
COMMENT ON TABLE hr.historico_cargos IS 'Tabela que armazena o histórico de cargos de um empregado, se houver mudança no cargo ou departamento de um empregado essa tabela deve ser atualizada com o cargo antigo';
COMMENT ON COLUMN hr.historico_cargos.id_empregado IS 'coluna que corresponde ao id unico de cada empregado como uma PK, enquanto referencia a tabela empregados como uma FK';
COMMENT ON COLUMN hr.historico_cargos.data_inicial IS 'coluna que armazena as informações sobre a data em que o empregado começou a exercer sua antiga função.';
COMMENT ON COLUMN hr.historico_cargos.data_final IS 'coluna que armazena as informações sobre a data em que o empregado deixou de exercer sua antiga função.';
COMMENT ON COLUMN hr.historico_cargos.id_departamento IS 'coluna que faz referrencia ao id do depattamento ao qual cada empregado pertence ou pertenceu, usando como referencia a tabela departamentos.';
COMMENT ON COLUMN hr.historico_cargos.id_cargo IS 'id individual de cada cargo, usado como chave primaria.';


ALTER TABLE hr.empregados ADD CONSTRAINT cargos_empregados_fk
FOREIGN KEY (id_cargo)
REFERENCES hr.cargos (id_cargo)
;

ALTER TABLE hr.historico_cargos ADD CONSTRAINT cargos_historico_cargos_fk
FOREIGN KEY (id_cargo)
REFERENCES hr.cargos (id_cargo)
;

ALTER TABLE hr.paises ADD CONSTRAINT regioes_paises_fk
FOREIGN KEY (id_regiao)
REFERENCES hr.regioes (id_regiao)
;

ALTER TABLE hr.localizacao ADD CONSTRAINT paises_localizacao_fk
FOREIGN KEY (id_pais)
REFERENCES hr.paises (id_pais)
;

ALTER TABLE hr.departamentos ADD CONSTRAINT localizacao_departamentos_fk
FOREIGN KEY (id_localizacao)
REFERENCES hr.localizacao (id_localizacao)
;

ALTER TABLE hr.empregados ADD CONSTRAINT departamentos_empregados_fk
FOREIGN KEY (id_departamento)
REFERENCES hr.departamentos (id_departamento)
;

ALTER TABLE hr.historico_cargos ADD CONSTRAINT departamentos_historico_cargos_fk
FOREIGN KEY (id_departamento)
REFERENCES hr.departamentos (id_departamento)
;

ALTER TABLE hr.empregados ADD CONSTRAINT empregados_empregados_fk
FOREIGN KEY (id_supervisor)
REFERENCES hr.empregados (id_empregado)
;

ALTER TABLE hr.historico_cargos ADD CONSTRAINT empregados_historico_cargos_fk
FOREIGN KEY (id_empregado)
REFERENCES hr.empregados (id_empregado)
;

 /* processo de popular a tabela regioes */

insert into regioes (id_regiao, nome) values
(1, 'Europe'
);
insert into regioes (id_regiao, nome) values
(2, 'Americas'
);
insert into regioes (id_regiao, nome) values
(3, 'Asia'
);
insert into regioes (id_regiao, nome) values
(4, 'Middle East and Africa'
);

 /* processo de popular a tabela paises */ 

INSERT INTO paises (id_pais, id_regiao, nome) values
('AR', 2, 'Argentina'  
);
INSERT INTO paises (id_pais, id_regiao, nome) values
('AU', 3, 'Australia'  
);
INSERT INTO paises (id_pais, id_regiao, nome) values
('BE', 1, 'Belgium'  
);
INSERT INTO paises (id_pais, id_regiao, nome) values
('BR', 2, 'Brazil'  
);
INSERT INTO paises (id_pais, id_regiao, nome) values
('CA', 2, 'Canada'  
);
INSERT INTO paises (id_pais, id_regiao, nome) values
('CH', 1, 'Switzerland'  
);
INSERT INTO paises (id_pais, id_regiao, nome) values
('CN', 3, 'China'  
);
INSERT INTO paises (id_pais, id_regiao, nome) values
('DE', 1, 'Germany'  
);
INSERT INTO paises (id_pais, id_regiao, nome) values
('DK', 1, 'Denmark'  
);
INSERT INTO paises (id_pais, id_regiao, nome) values
('EG', 4, 'Egypt'  
);
INSERT INTO paises (id_pais, id_regiao, nome) values
('FR', 1, 'France'  
);
INSERT INTO paises (id_pais, id_regiao, nome) values
('IL', 4, 'Israel'  
);
INSERT INTO paises (id_pais, id_regiao, nome) values
('IN', 3, 'India'  
);
INSERT INTO paises (id_pais, id_regiao, nome) values
('IT', 1, 'Italy'  
);
INSERT INTO paises (id_pais, id_regiao, nome) values
('JP', 3, 'Japan'  
);
INSERT INTO paises (id_pais, id_regiao, nome) values
('KW', 4, 'Kuwait'  
);
INSERT INTO paises (id_pais, id_regiao, nome) values
('ML', 3, 'Malaysia'  
);
INSERT INTO paises (id_pais, id_regiao, nome) values
('MX', 2, 'Mexico'  
);
INSERT INTO paises (id_pais, id_regiao, nome) values
('NG', 4, 'Nigeria'  
);
INSERT INTO paises (id_pais, id_regiao, nome) values
('NL', 1, 'Netherlands'  
);
INSERT INTO paises (id_pais, id_regiao, nome) values
('SG', 3, 'Singapore'  
);
INSERT INTO paises (id_pais, id_regiao, nome) values
('UK', 1, 'United Kingdom'  
);
INSERT INTO paises (id_pais, id_regiao, nome) values
('US', 2, 'United States of America'  
);
INSERT INTO paises (id_pais, id_regiao, nome) values
('ZM', 4, 'Zambia'  
);
INSERT INTO paises (id_pais, id_regiao, nome) values
('ZW', 4, 'Zimbabwe'  
);

/* processo de popular a tabela localizacao */ 

INSERT INTO localizacao ( id_localizacao, id_pais, 
endereco, cep, cidade,uf) values 
(1000, 'IT', '1297 Via Cola di Rie', '00989', 'Roma', ''
);
INSERT INTO localizacao ( id_localizacao, id_pais, 
endereco, cep, cidade,uf) values 
(1100, 'IT', '93091 Calle della Testa', '10934', 'Venice', ''
);
INSERT INTO localizacao ( id_localizacao, id_pais, 
endereco, cep, cidade,uf) values 
(1200, 'JP', '2017 Shinjuku-ku', '1689', 'Tokyo', 'Tokyo Prefecture'
);
INSERT INTO localizacao ( id_localizacao, id_pais, 
endereco, cep, cidade,uf) values 
(1300, 'JP', '9450 Kamiya-cho', '6823', 'Hiroshima', ''
);
INSERT INTO localizacao ( id_localizacao, id_pais, 
endereco, cep, cidade,uf) values 
(1400, 'US', '2014 Jabberwocky Rd', '26192', 'Southlake', 'Texas'
);
INSERT INTO localizacao ( id_localizacao, id_pais, 
endereco, cep, cidade,uf) values 
(1500, 'US', '2011 Interiors Blvd', '99236', 'South San Francisco', 'California'
);
INSERT INTO localizacao ( id_localizacao, id_pais, 
endereco, cep, cidade,uf) values 
(1600, 'US', '2007 Zagora St', '50090', 'South Brunswick', 'New Jersey'
);
INSERT INTO localizacao ( id_localizacao, id_pais, 
endereco, cep, cidade,uf) values 
(1700, 'US', '2004 Charade Rd', '98199', 'Seattle', 'Washington'
);
INSERT INTO localizacao ( id_localizacao, id_pais, 
endereco, cep, cidade,uf) values 
(1800, 'CA', '147 Spadina Ave', 'M5V 2L7', 'Toronto', 'Ontario'
);
INSERT INTO localizacao ( id_localizacao, id_pais, 
endereco, cep, cidade,uf) values 
(1900, 'CA', '6092 Boxwood St', 'YSW 9T2', 'Whitehorse', 'Yukon'
);
INSERT INTO localizacao ( id_localizacao, id_pais, 
endereco, cep, cidade,uf) values 
(2000, 'CN', '40-5-12 Laogianggen', '190518', 'Beijing', ''
);
INSERT INTO localizacao ( id_localizacao, id_pais, 
endereco, cep, cidade,uf) values 
(2100, 'IN', '1298 Vileparle (E)', '490231', 'Bombay', 'Maharashtra'
);
INSERT INTO localizacao ( id_localizacao, id_pais, 
endereco, cep, cidade,uf) values 
(2200, 'AU', '12-98 Victoria Street', '2901', 'Sydney', 'New South Wales'
);
INSERT INTO localizacao ( id_localizacao, id_pais, 
endereco, cep, cidade,uf) values 
(2300, 'SG', '198 Clementi North', '540198', 'Singapore', ''
);
INSERT INTO localizacao ( id_localizacao, id_pais, 
endereco, cep, cidade,uf) values 
(2400, 'UK', '8204 Arthur St', '', 'London', ''
);
INSERT INTO localizacao ( id_localizacao, id_pais, 
endereco, cep, cidade,uf) values 
(2500, 'UK', 'Magdalen Centre, The Oxford Science Park', 'OX9 9ZB', 'Oxford', 'Oxford'
);
INSERT INTO localizacao ( id_localizacao, id_pais, 
endereco, cep, cidade,uf) values 
(2600, 'UK', '9702 Chester Road', '09629850293', 'Stretford', 'Manchester'
);
INSERT INTO localizacao ( id_localizacao, id_pais, 
endereco, cep, cidade,uf) values 
(2700, 'DE', 'Schwanthalerstr. 7031', '80925', 'Munich', 'Bavaria'
);
INSERT INTO localizacao ( id_localizacao, id_pais, 
endereco, cep, cidade,uf) values 
(2800, 'BR', 'Rua Frei Caneca 1360 ', '01307-002', 'Sao Paulo', 'Sao Paulo'
);
INSERT INTO localizacao ( id_localizacao, id_pais, 
endereco, cep, cidade,uf) values 
(2900, 'CH', '20 Rue des Corps-Saints', '1730', 'Geneva', 'Geneve'
);
INSERT INTO localizacao ( id_localizacao, id_pais, 
endereco, cep, cidade,uf) values 
(3000, 'CH', 'Murtenstrasse 921', '3095', 'Bern', 'BE'
);
INSERT INTO localizacao ( id_localizacao, id_pais, 
endereco, cep, cidade,uf) values 
(3100, 'NL', 'Pieter Breughelstraat 837', '3029SK', 'Utrecht', 'Utrecht'
);
INSERT INTO localizacao ( id_localizacao, id_pais, 
endereco, cep, cidade,uf) values 
(3200, 'MX', 'Mariano Escobedo 9991', '11932', 'Mexico City', 'Distrito Federal,'
);

/* processo de popular a tabela departamento */ 

INSERT INTO departamentos ( id_departamento, id_gerente, nome, id_localizacao) values 
(10, 200,  'Administration', 1700
);
INSERT INTO departamentos ( id_departamento, id_gerente, nome, id_localizacao) values 
(20, 201,  'Marketing', 1800
);
INSERT INTO departamentos ( id_departamento, id_gerente, nome, id_localizacao) values 
(30, 114,  'Purchasing', 1700
);
INSERT INTO departamentos ( id_departamento, id_gerente, nome, id_localizacao) values 
(40, 203,  'Human Resources', 2400
);
INSERT INTO departamentos ( id_departamento, id_gerente, nome, id_localizacao) values 
(50, 121,  'Shipping', 1500
);
INSERT INTO departamentos ( id_departamento, id_gerente, nome, id_localizacao) values 
(60, 103,  'IT', 1400
);
INSERT INTO departamentos ( id_departamento, id_gerente, nome, id_localizacao) values 
(70, 204,  'Public Relations', 2700
);
INSERT INTO departamentos ( id_departamento, id_gerente, nome, id_localizacao) values 
(80, 145,  'Sales', 2500
);
INSERT INTO departamentos ( id_departamento, id_gerente, nome, id_localizacao) values 
(90, 100,  'Executive', 1700
);
INSERT INTO departamentos ( id_departamento, id_gerente, nome, id_localizacao) values 
(100, 108,  'Finance', 1700
);
INSERT INTO departamentos ( id_departamento, id_gerente, nome, id_localizacao) values 
(110, 205,  'Accounting', 1700
);
INSERT INTO departamentos ( id_departamento, id_gerente, nome, id_localizacao) values 
(120, null ,   'Treasury', 1700
);
INSERT INTO departamentos ( id_departamento, id_gerente, nome, id_localizacao) values 
(130, null ,   'Corporate Tax', 1700
);
INSERT INTO departamentos ( id_departamento, id_gerente, nome, id_localizacao) values 
(140, null ,   'Control And Credit', 1700
);
INSERT INTO departamentos ( id_departamento, id_gerente, nome, id_localizacao) values 
(150, null ,   'Shareholder Services', 1700
);
INSERT INTO departamentos ( id_departamento, id_gerente, nome, id_localizacao) values 
(160, null ,   'Benefits', 1700
);
INSERT INTO departamentos ( id_departamento, id_gerente, nome, id_localizacao) values 
(170, null ,   'Manufacturing', 1700
);
INSERT INTO departamentos ( id_departamento, id_gerente, nome, id_localizacao) values 
(180, null ,   'Construction', 1700
);
INSERT INTO departamentos ( id_departamento, id_gerente, nome, id_localizacao) values 
(190, null ,   'Contracting', 1700
);
INSERT INTO departamentos ( id_departamento, id_gerente, nome, id_localizacao) values 
(200, null ,   'Operations', 1700
);
INSERT INTO departamentos ( id_departamento, id_gerente, nome, id_localizacao) values 
(210, null ,   'IT Support', 1700
);
INSERT INTO departamentos ( id_departamento, id_gerente, nome, id_localizacao) values 
(220, null ,   'NOC', 1700
);
INSERT INTO departamentos ( id_departamento, id_gerente, nome, id_localizacao) values 
(230, null ,   'IT Helpdesk', 1700
);
INSERT INTO departamentos ( id_departamento, id_gerente, nome, id_localizacao) values 
(240, null ,   'Government Sales', 1700
);
INSERT INTO departamentos ( id_departamento, id_gerente, nome, id_localizacao) values 
(250, null ,   'Retail Sales', 1700
);
INSERT INTO departamentos ( id_departamento, id_gerente, nome, id_localizacao) values 
(260, null ,   'Recruiting', 1700
);
INSERT INTO departamentos ( id_departamento, id_gerente, nome, id_localizacao) values 
(270, null ,   'Payroll', 1700
);

/* processo de popular a tabela cargos */ 

INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) values
('AD_PRES', 'President', 20080, 40000
);
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) values
('AD_VP', 'Administration Vice President', 15000, 30000
);
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) values
('AD_ASST', 'Administration Assistant', 3000, 6000
);
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) values
('FI_MGR', 'Finance Manager', 8200, 16000
);
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) values
('FI_ACCOUNT', 'Accountant', 4200, 9000
);
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) values
('AC_MGR', 'Accounting Manager', 8200, 16000
);
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) values
('AC_ACCOUNT', 'Public Accountant', 4200, 9000
);
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) values
('SA_MAN', 'Sales Manager', 10000, 20080
);
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) values
('SA_REP', 'Sales Representative', 6000, 12008
);
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) values
('PU_MAN', 'Purchasing Manager', 8000, 15000
);
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) values
('PU_CLERK', 'Purchasing Clerk', 2500, 5500
);
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) values
('ST_MAN', 'Stock Manager', 5500, 8500
);
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) values
('ST_CLERK', 'Stock Clerk', 2008, 5000
);
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) values
('SH_CLERK', 'Shipping Clerk', 2500, 5500
);
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) values
('IT_PROG', 'Programmer', 4000, 10000
);
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) values
('MK_MAN', 'Marketing Manager', 9000, 15000
);
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) values
('MK_REP', 'Marketing Representative', 4000, 9000
);
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) values
('HR_REP', 'Human Resources Representative', 4000, 9000
);
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) values
('PR_REP', 'Public Relations Representative', 4500, 10500
);

/* processo de popular a tabela empregados */ 

INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(100, 'Steven King', 'SKING', '515.123.4567', '2003-06-17', 'AD_PRES', 24000, null, null, 90);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(101, 'Neena Kochhar', 'NKOCHHAR', '515.123.4568', '2005-09-21', 'AD_VP', 17000, null, 100, 90);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(102, 'Lex De Haan', 'LDEHAAN', '515.123.4569', '2001-01-13', 'AD_VP', 17000, null, 100, 90);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(103, 'Alexander Hunold', 'AHUNOLD', '590.423.4567', '2006-01-03', 'IT_PROG', 9000, null, 102, 60);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(104, 'Bruce Ernst', 'BERNST', '590.423.4568', '2007-05-21', 'IT_PROG', 6000, null, 103, 60);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(105, 'David Austin', 'DAUSTIN', '590.423.4569', '2005-06-25', 'IT_PROG', 4800, null, 103, 60);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(106, 'Valli Pataballa', 'VPATABAL', '590.423.4560', '2006-02-05', 'IT_PROG', 4800, null, 103, 60);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(107, 'Diana Lorentz', 'DLORENTZ', '590.423.5567', '2007-02-07', 'IT_PROG', 4200, null, 103, 60);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(108, 'Nancy Greenberg', 'NGREENBE', '515.124.4569', '2002-08-17', 'FI_MGR', 12008, null, 101, 100);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(109, 'Daniel Faviet', 'DFAVIET', '515.124.4169', '2002-08-16', 'FI_ACCOUNT', 9000, null, 108, 100);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(110, 'John Chen', 'JCHEN', '515.124.4269', '2005-09-28', 'FI_ACCOUNT', 8200, null, 108, 100);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(111, 'Ismael Sciarra', 'ISCIARRA', '515.124.4369', '2005-09-30', 'FI_ACCOUNT', 7700, null, 108, 100);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(112, 'Jose Manuel Urman', 'JMURMAN', '515.124.4469', '2006-03-07', 'FI_ACCOUNT', 7800, null, 108, 100);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(113, 'Luis Popp', 'LPOPP', '515.124.4567', '2007-12-07', 'FI_ACCOUNT', 6900, null, 108, 100);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(114, 'Den Raphaely', 'DRAPHEAL', '515.127.4561', '2002-12-07', 'PU_MAN', 11000, null, 100, 30);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(115, 'Alexander Khoo', 'AKHOO', '515.127.4562', '2003-05-18', 'PU_CLERK', 3100, null, 114, 30);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(116, 'Shelli Baida', 'SBAIDA', '515.127.4563', '2005-12-24', 'PU_CLERK', 2900, null, 114, 30);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(117, 'Sigal Tobias', 'STOBIAS', '515.127.4564', '2005-07-24', 'PU_CLERK', 2800, null, 114, 30);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(118, 'Guy Himuro', 'GHIMURO', '515.127.4565', '2006-11-15', 'PU_CLERK', 2600, null, 114, 30);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(119, 'Karen Colmenares', 'KCOLMENA', '515.127.4566', '2007-08-10', 'PU_CLERK', 2500, null, 114, 30);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(120, 'Matthew Weiss', 'MWEISS', '650.123.1234', '2004-07-18', 'ST_MAN', 8000, null, 100, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(121, 'Adam Fripp', 'AFRIPP', '650.123.2234', '2005-04-10', 'ST_MAN', 8200, null, 100, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(122, 'Payam Kaufling', 'PKAUFLIN', '650.123.3234', '2003-05-01', 'ST_MAN', 7900, null, 100, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(123, 'Shanta Vollman', 'SVOLLMAN', '650.123.4234', '2005-10-10', 'ST_MAN', 6500, null, 100, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(124, 'Kevin Mourgos', 'KMOURGOS', '650.123.5234', '2007-11-16', 'ST_MAN', 5800, null, 100, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(125, 'Julia Nayer', 'JNAYER', '650.124.1214', '2005-07-16', 'ST_CLERK', 3200, null, 120, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(126, 'Irene Mikkilineni', 'IMIKKILI', '650.124.1224', '2006-09-28', 'ST_CLERK', 2700, null, 120, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(127, 'James Landry', 'JLANDRY', '650.124.1334', '2007-01-14', 'ST_CLERK', 2400, null, 120, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(128, 'Steven Markle', 'SMARKLE', '650.124.1434', '2008-03-08', 'ST_CLERK', 2200, null, 120, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(129, 'Laura Bissot', 'LBISSOT', '650.124.5234', '2005-08-20', 'ST_CLERK', 3300, null, 121, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(130, 'Mozhe Atkinson', 'MATKINSO', '650.124.6234', '2005-10-30', 'ST_CLERK', 2800, null, 121, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(131, 'James Marlow', 'JAMRLOW', '650.124.7234', '2005-02-16', 'ST_CLERK', 2500, null, 121, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(132, 'TJ Olson', 'TJOLSON', '650.124.8234', '2007-04-10', 'ST_CLERK', 2100, null, 121, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(133, 'Jason Mallin', 'JMALLIN', '650.127.1934', '2004-06-14', 'ST_CLERK', 3300, null, 122, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(134, 'Michael Rogers', 'MROGERS', '650.127.1834', '2006-08-26', 'ST_CLERK', 2900, null, 122, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(135, 'Ki Gee', 'KGEE', '650.127.1734', '2007-12-12', 'ST_CLERK', 2400, null, 122, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(136, 'Hazel Philtanker', 'HPHILTAN', '650.127.1634', '2008-02-06', 'ST_CLERK', 2200, null, 122, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(137, 'Renske Ladwig', 'RLADWIG', '650.121.1234', '2003-07-14', 'ST_CLERK', 3600, null, 123, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(138, 'Stephen Stiles', 'SSTILES', '650.121.2034', '2005-10-26', 'ST_CLERK', 3200, null, 123, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(139, 'John Seo', 'JSEO', '650.121.2019', '2006-02-12', 'ST_CLERK', 2700, null, 123, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(140, 'Joshua Patel', 'JPATEL', '650.121.1834', '2006-04-06', 'ST_CLERK', 2500, null, 123, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(141, 'Trenna Rajs', 'TRAJS', '650.121.8009', '2003-10-17', 'ST_CLERK', 3500, null, 124, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(142, 'Curtis Davies', 'CDAVIES', '650.121.2994', '2005-01-29', 'ST_CLERK', 3100, null, 124, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(143, 'Randall Matos', 'RMATOS', '650.121.2874', '2006-03-15', 'ST_CLERK', 2600, null, 124, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(144, 'Peter Vargas', 'PVARGAS', '650.121.2004', '2006-07-09', 'ST_CLERK', 2500, null, 124, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(145, 'John Russell', 'JRUSSEL', '011.44.1344.429268', '2004-10-01', 'SA_MAN', 14000, .4, 100, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(146, 'Karen Partners', 'KPARTNER', '011.44.1344.467268', '2005-01-05', 'SA_MAN', 13500, .3, 100, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(147, 'Alberto Errazuriz', 'AERRAZUR', '011.44.1344.429278', '2005-03-10', 'SA_MAN', 12000, .3, 100, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(148, 'Gerald Cambrault', 'GCAMBRAU', '011.44.1344.619268', '2007-10-15', 'SA_MAN', 11000, .3, 100, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(149, 'Eleni Zlotkey', 'EZLOTKEY', '011.44.1344.429018', '2008-01-29', 'SA_MAN', 10500, .2, 100, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(150, 'Peter Tucker', 'PTUCKER', '011.44.1344.129268', '2005-01-30', 'SA_REP', 10000, .3, 145, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(151, 'David Bernstein', 'DBERNSTE', '011.44.1344.345268', '2005-03-24', 'SA_REP', 9500, .25, 145, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(152, 'Peter Hall', 'PHALL', '011.44.1344.478968', '2005-08-20', 'SA_REP', 9000, .25, 145, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(153, 'Christopher Olsen', 'COLSEN', '011.44.1344.498718', '2006-03-30', 'SA_REP', 8000, .2, 145, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(154, 'Nanette Cambrault', 'NCAMBRAU', '011.44.1344.987668', '2006-12-09', 'SA_REP', 7500, .2, 145, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(155, 'Oliver Tuvault', 'OTUVAULT', '011.44.1344.486508', '2007-11-23', 'SA_REP', 7000, .15, 145, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(156, 'Janette King', 'JKING', '011.44.1345.429268', '2004-01-30', 'SA_REP', 10000, .35, 146, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(157, 'Patrick Sully', 'PSULLY', '011.44.1345.929268', '2004-03-04', 'SA_REP', 9500, .35, 146, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(158, 'Allan McEwen', 'AMCEWEN', '011.44.1345.829268', '2004-08-01', 'SA_REP', 9000, .35, 146, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(159, 'Lindsey Smith', 'LSMITH', '011.44.1345.729268', '2005-03-10', 'SA_REP', 8000, .3, 146, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(160, 'Louise Doran', 'LDORAN', '011.44.1345.629268', '2005-12-15', 'SA_REP', 7500, .3, 146, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(161, 'Sarath Sewall', 'SSEWALL', '011.44.1345.529268', '2006-11-03', 'SA_REP', 7000, .25, 146, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(162, 'Clara Vishney', 'CVISHNEY', '011.44.1346.129268', '2005-11-11', 'SA_REP', 10500, .25, 147, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(163, 'Danielle Greene', 'DGREENE', '011.44.1346.229268', '2007-03-19', 'SA_REP', 9500, .15, 147, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(164, 'Mattea Marvins', 'MMARVINS', '011.44.1346.329268', '2008-01-24', 'SA_REP', 7200, .1, 147, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(165, 'David Lee', 'DLEE', '011.44.1346.529268', '2008-02-23', 'SA_REP', 6800, .1, 147, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(166, 'Sundar Ande', 'SANDE', '011.44.1346.629268', '2008-03-24', 'SA_REP', 6400, .1, 147, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(167, 'Amit Banda', 'ABANDA', '011.44.1346.729268', '2008-04-21', 'SA_REP', 6200, .1, 147, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(168, 'Lisa Ozer', 'LOZER', '011.44.1343.929268', '2005-03-11', 'SA_REP', 11500, .25, 148, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(169, 'Harrison Bloom', 'HBLOOM', '011.44.1343.829268', '2006-03-23', 'SA_REP', 10000, .2, 148, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(170, 'Tayler Fox', 'TFOX', '011.44.1343.729268', '2006-01-24', 'SA_REP', 9600, .2, 148, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(171, 'William Smith', 'WSMITH', '011.44.1343.629268', '2007-02-23', 'SA_REP', 7400, .15, 148, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(172, 'Elizabeth Bates', 'EBATES', '011.44.1343.529268', '2007-03-24', 'SA_REP', 7300, .15, 148, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(173, 'Sundita Kumar', 'SKUMAR', '011.44.1343.329268', '2008-04-21', 'SA_REP', 6100, .1, 148, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(174, 'Ellen Abel', 'EABEL', '011.44.1644.429267', '2004-05-11', 'SA_REP', 11000, .3, 149, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(175, 'Alyssa Hutton', 'AHUTTON', '011.44.1644.429266', '2005-03-19', 'SA_REP', 8800, .25, 149, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(176, 'Jonathon Taylor', 'JTAYLOR', '011.44.1644.429265', '2006-03-24', 'SA_REP', 8600, .2, 149, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(177, 'Jack Livingston', 'JLIVINGS', '011.44.1644.429264', '2006-04-23', 'SA_REP', 8400, .2, 149, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(178, 'Kimberely Grant', 'KGRANT', '011.44.1644.429263', '2007-05-24', 'SA_REP', 7000, .15, 149, null);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(179, 'Charles Johnson', 'CJOHNSON', '011.44.1644.429262', '2008-01-04', 'SA_REP', 6200, .1, 149, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(180, 'Winston Taylor', 'WTAYLOR', '650.507.9876', '2006-01-24', 'SH_CLERK', 3200, null, 120, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(181, 'Jean Fleaur', 'JFLEAUR', '650.507.9877', '2006-02-23', 'SH_CLERK', 3100, null, 120, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(182, 'Martha Sullivan', 'MSULLIVA', '650.507.9878', '2007-06-21', 'SH_CLERK', 2500, null, 120, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(183, 'Girard Geoni', 'GGEONI', '650.507.9879', '2008-02-03', 'SH_CLERK', 2800, null, 120, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(184, 'Nandita Sarchand', 'NSARCHAN', '650.509.1876', '2004-01-27', 'SH_CLERK', 4200, null, 121, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(185, 'Alexis Bull', 'ABULL', '650.509.2876', '2005-02-20', 'SH_CLERK', 4100, null, 121, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(186, 'Julia Dellinger', 'JDELLING', '650.509.3876', '2006-06-24', 'SH_CLERK', 3400, null, 121, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(187, 'Anthony Cabrio', 'ACABRIO', '650.509.4876', '2007-02-07', 'SH_CLERK', 3000, null, 121, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(188, 'Kelly Chung', 'KCHUNG', '650.505.1876', '2005-06-14', 'SH_CLERK', 3800, null, 122, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(189, 'Jennifer Dilly', 'JDILLY', '650.505.2876', '2005-08-13', 'SH_CLERK', 3600, null, 122, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(190, 'Timothy Gates', 'TGATES', '650.505.3876', '2006-07-11', 'SH_CLERK', 2900, null, 122, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(191, 'Randall Perkins', 'RPERKINS', '650.505.4876', '2007-12-19', 'SH_CLERK', 2500, null, 122, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(192, 'Sarah Bell', 'SBELL', '650.501.1876', '2004-02-04', 'SH_CLERK', 4000, null, 123, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(193, 'Britney Everett', 'BEVERETT', '650.501.2876', '2005-03-03', 'SH_CLERK', 3900, null, 123, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(194, 'Samuel McCain', 'SMCCAIN', '650.501.3876', '2006-07-01', 'SH_CLERK', 3200, null, 123, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(195, 'Vance Jones', 'VJONES', '650.501.4876', '2007-03-17', 'SH_CLERK', 2800, null, 123, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(196, 'Alana Walsh', 'AWALSH', '650.507.9811', '2006-04-24', 'SH_CLERK', 3100, null, 124, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(197, 'Kevin Feeney', 'KFEENEY', '650.507.9822', '2006-05-23', 'SH_CLERK', 3000, null, 124, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(198, 'Donald OConnell', 'DOCONNEL', '650.507.9833', '2007-06-21', 'SH_CLERK', 2600, null, 124, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(199, 'Douglas Grant', 'DGRANT', '650.507.9844', '2008-01-13', 'SH_CLERK', 2600, null, 124, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(200, 'Jennifer Whalen', 'JWHALEN', '515.123.4444', '2003-09-17', 'AD_ASST', 4400, null, 101, 10);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(201, 'Michael Hartstein', 'MHARTSTE', '515.123.5555', '2004-02-17', 'MK_MAN', 13000, null, 100, 20);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(202, 'Pat Fay', 'PFAY', '603.123.6666', '2005-08-17', 'MK_REP', 6000, null, 201, 20);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(203, 'Susan Mavris', 'SMAVRIS', '515.123.7777', '2002-06-07', 'HR_REP', 6500, null, 101, 40);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(204, 'Hermann Baer', 'HBAER', '515.123.8888', '2002-06-07', 'PR_REP', 10000, null, 101, 70);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(205, 'Shelley Higgins', 'SHIGGINS', '515.123.8080', '2002-06-07', 'AC_MGR', 12008, null, 101, 110);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(206, 'William Gietz', 'WGIETZ', '515.123.8181', '2002-06-07', 'AC_ACCOUNT', 8300, null, 205, 110);

/* processo de popular a tabela historico_cargos */ 

insert into historico_cargos (id_empregado, id_cargo, data_inicial, data_final, id_departamento) values
( 102, 'IT_PROG', '2001-01-13','2006-07-24', 60
);
insert into historico_cargos (id_empregado, id_cargo, data_inicial, data_final, id_departamento) values
( 101, 'AC_ACCOUNT', '1997-09-21','2001-10-27', 110
);
insert into historico_cargos (id_empregado, id_cargo, data_inicial, data_final, id_departamento) values
( 101, 'AC_MGR', '2001-10-28','2005-03-15', 110
);
insert into historico_cargos (id_empregado, id_cargo, data_inicial, data_final, id_departamento) values
( 201, 'MK_REP', '2004-02-17','2007-12-19', 20
);
insert into historico_cargos (id_empregado, id_cargo, data_inicial, data_final, id_departamento) values
( 114, 'ST_CLERK', '2006-03-24','2007-12-31', 50
);
insert into historico_cargos (id_empregado, id_cargo, data_inicial, data_final, id_departamento) values
( 122, 'ST_CLERK', '2007-01-01','2007-12-31', 50
);
insert into historico_cargos (id_empregado, id_cargo, data_inicial, data_final, id_departamento) values
( 200, 'AD_ASST', '1995-09-17','2001-06-17', 90
);
insert into historico_cargos (id_empregado, id_cargo, data_inicial, data_final, id_departamento) values
( 176, 'SA_REP', '2006-03-24','2006-12-31', 80
);
insert into historico_cargos (id_empregado, id_cargo, data_inicial, data_final, id_departamento) values
( 176, 'SA_MAN', '2007-01-01','2007-12-31', 80
);
insert into historico_cargos (id_empregado, id_cargo, data_inicial, data_final, id_departamento) values
( 200, 'AC_ACCOUNT', '2002-07-01','2006-12-31', 90
);



