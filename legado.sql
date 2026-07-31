--
-- PostgreSQL database dump
--

\restrict qeYPxiUZvkU0ehL3OQWqO3xAWwbBtlBKOthXwKncIqAQnE0iGkvOjckKgZOMg4f

-- Dumped from database version 13.23 (Debian 13.23-1.pgdg13+1)
-- Dumped by pg_dump version 13.23 (Debian 13.23-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: atend_codif; Type: TABLE; Schema: public; Owner: novosga
--

CREATE TABLE legado.atend_codif (
    atendimento_id bigint NOT NULL,
    servico_id integer NOT NULL,
    valor_peso smallint NOT NULL
);


ALTER TABLE legado.atend_codif OWNER TO novosga;

--
-- Name: atend_meta; Type: TABLE; Schema: public; Owner: novosga
--

CREATE TABLE legado.atend_meta (
    atendimento_id bigint NOT NULL,
    name character varying(50) NOT NULL,
    value text
);


ALTER TABLE legado.atend_meta OWNER TO novosga;

--
-- Name: atendimentos; Type: TABLE; Schema: public; Owner: novosga
--

CREATE TABLE legado.atendimentos (
    id bigint NOT NULL,
    unidade_id integer NOT NULL,
    usuario_id integer,
    usuario_tri_id integer NOT NULL,
    servico_id integer NOT NULL,
    prioridade_id integer NOT NULL,
    atendimento_id bigint,
    status smallint NOT NULL,
    sigla_senha character varying(1) NOT NULL,
    num_senha integer NOT NULL,
    num_senha_serv integer NOT NULL,
    nm_cli character varying(100) DEFAULT NULL::character varying,
    num_local smallint NOT NULL,
    dt_cheg timestamp(0) without time zone NOT NULL,
    dt_cha timestamp(0) without time zone,
    dt_ini timestamp(0) without time zone,
    dt_fim timestamp(0) without time zone,
    ident_cli character varying(11) DEFAULT NULL::character varying
);


ALTER TABLE legado.atendimentos OWNER TO novosga;

--
-- Name: atendimentos_id_seq; Type: SEQUENCE; Schema: public; Owner: novosga
--

CREATE SEQUENCE legado.atendimentos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE legado.atendimentos_id_seq OWNER TO novosga;

--
-- Name: atendimentos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: novosga
--

ALTER SEQUENCE legado.atendimentos_id_seq OWNED BY legado.atendimentos.id;


--
-- Name: cargos; Type: TABLE; Schema: public; Owner: novosga
--

CREATE TABLE legado.cargos (
    id integer NOT NULL,
    nome character varying(50) NOT NULL,
    descricao character varying(150) NOT NULL,
    esquerda integer NOT NULL,
    direita integer NOT NULL,
    nivel integer NOT NULL
);


ALTER TABLE legado.cargos OWNER TO novosga;

--
-- Name: cargos_id_seq; Type: SEQUENCE; Schema: public; Owner: novosga
--

CREATE SEQUENCE legado.cargos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE legado.cargos_id_seq OWNER TO novosga;

--
-- Name: cargos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: novosga
--

ALTER SEQUENCE legado.cargos_id_seq OWNED BY legado.cargos.id;


--
-- Name: cargos_mod_perm; Type: TABLE; Schema: public; Owner: novosga
--

CREATE TABLE legado.cargos_mod_perm (
    cargo_id integer NOT NULL,
    modulo_id integer NOT NULL,
    permissao integer NOT NULL
);


ALTER TABLE legado.cargos_mod_perm OWNER TO novosga;

--
-- Name: config; Type: TABLE; Schema: public; Owner: novosga
--

CREATE TABLE legado.config (
    chave character varying(150) NOT NULL,
    valor text NOT NULL,
    tipo integer NOT NULL
);


ALTER TABLE legado.config OWNER TO novosga;

--
-- Name: contador; Type: TABLE; Schema: public; Owner: novosga
--

CREATE TABLE legado.contador (
    unidade_id integer NOT NULL,
    total integer DEFAULT 0 NOT NULL
);


ALTER TABLE legado.contador OWNER TO novosga;

--
-- Name: grupos; Type: TABLE; Schema: public; Owner: novosga
--

CREATE TABLE legado.grupos (
    id integer NOT NULL,
    nome character varying(50) NOT NULL,
    descricao character varying(150) NOT NULL,
    esquerda integer NOT NULL,
    direita integer NOT NULL,
    nivel integer NOT NULL
);


ALTER TABLE legado.grupos OWNER TO novosga;

--
-- Name: grupos_id_seq; Type: SEQUENCE; Schema: public; Owner: novosga
--

CREATE SEQUENCE legado.grupos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE legado.grupos_id_seq OWNER TO novosga;

--
-- Name: grupos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: novosga
--

ALTER SEQUENCE legado.grupos_id_seq OWNED BY legado.grupos.id;


--
-- Name: historico_atend_codif; Type: TABLE; Schema: public; Owner: novosga
--

CREATE TABLE legado.historico_atend_codif (
    atendimento_id bigint NOT NULL,
    servico_id integer NOT NULL,
    valor_peso smallint NOT NULL
);


ALTER TABLE legado.historico_atend_codif OWNER TO novosga;

--
-- Name: historico_atend_meta; Type: TABLE; Schema: public; Owner: novosga
--

CREATE TABLE legado.historico_atend_meta (
    atendimento_id bigint NOT NULL,
    name character varying(50) NOT NULL,
    value text
);


ALTER TABLE legado.historico_atend_meta OWNER TO novosga;

--
-- Name: historico_atendimentos; Type: TABLE; Schema: public; Owner: novosga
--

CREATE TABLE legado.historico_atendimentos (
    id bigint NOT NULL,
    unidade_id integer,
    usuario_id integer,
    usuario_tri_id integer NOT NULL,
    servico_id integer NOT NULL,
    prioridade_id integer NOT NULL,
    atendimento_id bigint,
    status integer NOT NULL,
    sigla_senha character varying(1) NOT NULL,
    num_senha integer NOT NULL,
    num_senha_serv integer NOT NULL,
    nm_cli character varying(100) DEFAULT NULL::character varying,
    num_local smallint NOT NULL,
    dt_cheg timestamp(0) without time zone NOT NULL,
    dt_cha timestamp(0) without time zone,
    dt_ini timestamp(0) without time zone,
    dt_fim timestamp(0) without time zone,
    ident_cli character varying(11) DEFAULT NULL::character varying
);


ALTER TABLE legado.historico_atendimentos OWNER TO novosga;

--
-- Name: locais; Type: TABLE; Schema: public; Owner: novosga
--

CREATE TABLE legado.locais (
    id integer NOT NULL,
    nome character varying(20) NOT NULL
);


ALTER TABLE legado.locais OWNER TO novosga;

--
-- Name: locais_id_seq; Type: SEQUENCE; Schema: public; Owner: novosga
--

CREATE SEQUENCE legado.locais_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE legado.locais_id_seq OWNER TO novosga;

--
-- Name: locais_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: novosga
--

ALTER SEQUENCE legado.locais_id_seq OWNED BY legado.locais.id;


--
-- Name: modulos; Type: TABLE; Schema: public; Owner: novosga
--

CREATE TABLE legado.modulos (
    id integer NOT NULL,
    chave character varying(50) NOT NULL,
    nome character varying(25) NOT NULL,
    descricao character varying(100) NOT NULL,
    tipo smallint NOT NULL,
    status smallint NOT NULL
);


ALTER TABLE legado.modulos OWNER TO novosga;

--
-- Name: modulos_id_seq; Type: SEQUENCE; Schema: public; Owner: novosga
--

CREATE SEQUENCE legado.modulos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE legado.modulos_id_seq OWNER TO novosga;

--
-- Name: modulos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: novosga
--

ALTER SEQUENCE legado.modulos_id_seq OWNED BY legado.modulos.id;


--
-- Name: oauth_access_tokens; Type: TABLE; Schema: public; Owner: novosga
--

CREATE TABLE legado.oauth_access_tokens (
    access_token character varying(40) NOT NULL,
    client_id character varying(80) NOT NULL,
    user_id character varying(255),
    expires timestamp without time zone NOT NULL,
    scope character varying(2000)
);


ALTER TABLE legado.oauth_access_tokens OWNER TO novosga;

--
-- Name: oauth_clients; Type: TABLE; Schema: public; Owner: novosga
--

CREATE TABLE legado.oauth_clients (
    client_id character varying(80) NOT NULL,
    client_secret character varying(80) NOT NULL,
    redirect_uri character varying(2000) NOT NULL,
    grant_types character varying(80),
    scope character varying(100),
    user_id character varying(80)
);


ALTER TABLE legado.oauth_clients OWNER TO novosga;

--
-- Name: oauth_refresh_tokens; Type: TABLE; Schema: public; Owner: novosga
--

CREATE TABLE legado.oauth_refresh_tokens (
    refresh_token character varying(40) NOT NULL,
    client_id character varying(80) NOT NULL,
    user_id character varying(255),
    expires timestamp without time zone NOT NULL,
    scope character varying(2000)
);


ALTER TABLE legado.oauth_refresh_tokens OWNER TO novosga;

--
-- Name: oauth_scopes; Type: TABLE; Schema: public; Owner: novosga
--

CREATE TABLE legado.oauth_scopes (
    scope text,
    is_default boolean
);


ALTER TABLE legado.oauth_scopes OWNER TO novosga;

--
-- Name: paineis; Type: TABLE; Schema: public; Owner: novosga
--

CREATE TABLE legado.paineis (
    unidade_id integer NOT NULL,
    host integer NOT NULL
);


ALTER TABLE legado.paineis OWNER TO novosga;

--
-- Name: paineis_servicos; Type: TABLE; Schema: public; Owner: novosga
--

CREATE TABLE legado.paineis_servicos (
    host integer NOT NULL,
    unidade_id integer NOT NULL,
    servico_id integer NOT NULL
);


ALTER TABLE legado.paineis_servicos OWNER TO novosga;

--
-- Name: painel_senha; Type: TABLE; Schema: public; Owner: novosga
--

CREATE TABLE legado.painel_senha (
    id integer NOT NULL,
    unidade_id integer NOT NULL,
    servico_id integer NOT NULL,
    num_senha integer NOT NULL,
    sig_senha character varying(1) NOT NULL,
    msg_senha character varying(20) NOT NULL,
    local character varying(15) NOT NULL,
    num_local smallint NOT NULL,
    peso smallint NOT NULL,
    prioridade character varying(100),
    nome_cliente character varying(100),
    documento_cliente character varying(30)
);


ALTER TABLE legado.painel_senha OWNER TO novosga;

--
-- Name: painel_senha_id_seq; Type: SEQUENCE; Schema: public; Owner: novosga
--

CREATE SEQUENCE legado.painel_senha_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE legado.painel_senha_id_seq OWNER TO novosga;

--
-- Name: painel_senha_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: novosga
--

ALTER SEQUENCE legado.painel_senha_id_seq OWNED BY legado.painel_senha.id;


--
-- Name: prioridades; Type: TABLE; Schema: public; Owner: novosga
--

CREATE TABLE legado.prioridades (
    id integer NOT NULL,
    nome character varying(64) NOT NULL,
    descricao character varying(100) NOT NULL,
    peso smallint NOT NULL,
    status smallint NOT NULL
);


ALTER TABLE legado.prioridades OWNER TO novosga;

--
-- Name: prioridades_id_seq; Type: SEQUENCE; Schema: public; Owner: novosga
--

CREATE SEQUENCE legado.prioridades_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE legado.prioridades_id_seq OWNER TO novosga;

--
-- Name: prioridades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: novosga
--

ALTER SEQUENCE legado.prioridades_id_seq OWNED BY legado.prioridades.id;


--
-- Name: serv_meta; Type: TABLE; Schema: public; Owner: novosga
--

CREATE TABLE legado.serv_meta (
    servico_id integer NOT NULL,
    name character varying(50) NOT NULL,
    value text
);


ALTER TABLE legado.serv_meta OWNER TO novosga;

--
-- Name: servicos; Type: TABLE; Schema: public; Owner: novosga
--

CREATE TABLE legado.servicos (
    id integer NOT NULL,
    macro_id integer,
    descricao character varying(100) NOT NULL,
    nome character varying(50) NOT NULL,
    status smallint NOT NULL,
    peso smallint NOT NULL
);


ALTER TABLE legado.servicos OWNER TO novosga;

--
-- Name: servicos_id_seq; Type: SEQUENCE; Schema: public; Owner: novosga
--

CREATE SEQUENCE legado.servicos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE legado.servicos_id_seq OWNER TO novosga;

--
-- Name: servicos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: novosga
--

ALTER SEQUENCE legado.servicos_id_seq OWNED BY legado.servicos.id;


--
-- Name: uni_meta; Type: TABLE; Schema: public; Owner: novosga
--

CREATE TABLE legado.uni_meta (
    unidade_id integer NOT NULL,
    name character varying(50) NOT NULL,
    value text
);


ALTER TABLE legado.uni_meta OWNER TO novosga;

--
-- Name: uni_serv; Type: TABLE; Schema: public; Owner: novosga
--

CREATE TABLE legado.uni_serv (
    unidade_id integer NOT NULL,
    servico_id integer NOT NULL,
    local_id integer NOT NULL,
    sigla character varying(1) NOT NULL,
    status smallint NOT NULL,
    peso smallint NOT NULL
);


ALTER TABLE legado.uni_serv OWNER TO novosga;

--
-- Name: unidades; Type: TABLE; Schema: public; Owner: novosga
--

CREATE TABLE legado.unidades (
    id integer NOT NULL,
    grupo_id integer NOT NULL,
    codigo character varying(10) NOT NULL,
    nome character varying(50) NOT NULL,
    status smallint NOT NULL,
    stat_imp smallint NOT NULL,
    msg_imp character varying(100) NOT NULL
);


ALTER TABLE legado.unidades OWNER TO novosga;

--
-- Name: unidades_id_seq; Type: SEQUENCE; Schema: public; Owner: novosga
--

CREATE SEQUENCE legado.unidades_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE legado.unidades_id_seq OWNER TO novosga;

--
-- Name: unidades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: novosga
--

ALTER SEQUENCE legado.unidades_id_seq OWNED BY legado.unidades.id;


--
-- Name: usu_grup_cargo; Type: TABLE; Schema: public; Owner: novosga
--

CREATE TABLE legado.usu_grup_cargo (
    usuario_id integer NOT NULL,
    grupo_id integer NOT NULL,
    cargo_id integer NOT NULL
);


ALTER TABLE legado.usu_grup_cargo OWNER TO novosga;

--
-- Name: usu_meta; Type: TABLE; Schema: public; Owner: novosga
--

CREATE TABLE legado.usu_meta (
    usuario_id integer NOT NULL,
    name character varying(50) NOT NULL,
    value text
);


ALTER TABLE legado.usu_meta OWNER TO novosga;

--
-- Name: usu_serv; Type: TABLE; Schema: public; Owner: novosga
--

CREATE TABLE legado.usu_serv (
    unidade_id integer NOT NULL,
    servico_id integer NOT NULL,
    usuario_id integer NOT NULL
);


ALTER TABLE legado.usu_serv OWNER TO novosga;

--
-- Name: usuarios; Type: TABLE; Schema: public; Owner: novosga
--

CREATE TABLE legado.usuarios (
    id integer NOT NULL,
    login character varying(20) NOT NULL,
    nome character varying(20) NOT NULL,
    sobrenome character varying(100) NOT NULL,
    senha character varying(60) NOT NULL,
    ult_acesso timestamp(0) without time zone,
    status smallint NOT NULL,
    session_id character varying(50)
);


ALTER TABLE legado.usuarios OWNER TO novosga;

--
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: novosga
--

CREATE SEQUENCE legado.usuarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE legado.usuarios_id_seq OWNER TO novosga;

--
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: novosga
--

ALTER SEQUENCE legado.usuarios_id_seq OWNED BY legado.usuarios.id;


--
-- Name: view_historico_atend_codif; Type: VIEW; Schema: public; Owner: novosga
--

CREATE VIEW legado.view_historico_atend_codif AS
 SELECT atend_codif.atendimento_id,
    atend_codif.servico_id,
    atend_codif.valor_peso
   FROM legado.atend_codif
UNION ALL
 SELECT historico_atend_codif.atendimento_id,
    historico_atend_codif.servico_id,
    historico_atend_codif.valor_peso
   FROM legado.historico_atend_codif;


ALTER TABLE legado.view_historico_atend_codif OWNER TO novosga;

--
-- Name: view_historico_atend_meta; Type: VIEW; Schema: public; Owner: novosga
--

CREATE VIEW legado.view_historico_atend_meta AS
 SELECT atend_meta.atendimento_id,
    atend_meta.name,
    atend_meta.value
   FROM legado.atend_meta
UNION ALL
 SELECT historico_atend_meta.atendimento_id,
    historico_atend_meta.name,
    historico_atend_meta.value
   FROM legado.historico_atend_meta;


ALTER TABLE legado.view_historico_atend_meta OWNER TO novosga;

--
-- Name: view_historico_atendimentos; Type: VIEW; Schema: public; Owner: novosga
--

CREATE VIEW legado.view_historico_atendimentos AS
 SELECT atendimentos.id,
    atendimentos.unidade_id,
    atendimentos.usuario_id,
    atendimentos.usuario_tri_id,
    atendimentos.servico_id,
    atendimentos.prioridade_id,
    atendimentos.atendimento_id,
    atendimentos.status,
    atendimentos.sigla_senha,
    atendimentos.num_senha,
    atendimentos.num_senha_serv,
    atendimentos.nm_cli,
    atendimentos.num_local,
    atendimentos.dt_cheg,
    atendimentos.dt_cha,
    atendimentos.dt_ini,
    atendimentos.dt_fim,
    atendimentos.ident_cli
   FROM legado.atendimentos
UNION ALL
 SELECT historico_atendimentos.id,
    historico_atendimentos.unidade_id,
    historico_atendimentos.usuario_id,
    historico_atendimentos.usuario_tri_id,
    historico_atendimentos.servico_id,
    historico_atendimentos.prioridade_id,
    historico_atendimentos.atendimento_id,
    historico_atendimentos.status,
    historico_atendimentos.sigla_senha,
    historico_atendimentos.num_senha,
    historico_atendimentos.num_senha_serv,
    historico_atendimentos.nm_cli,
    historico_atendimentos.num_local,
    historico_atendimentos.dt_cheg,
    historico_atendimentos.dt_cha,
    historico_atendimentos.dt_ini,
    historico_atendimentos.dt_fim,
    historico_atendimentos.ident_cli
   FROM legado.historico_atendimentos;


ALTER TABLE legado.view_historico_atendimentos OWNER TO novosga;

--
-- Name: atendimentos id; Type: DEFAULT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.atendimentos ALTER COLUMN id SET DEFAULT nextval('legado.atendimentos_id_seq'::regclass);


--
-- Name: cargos id; Type: DEFAULT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.cargos ALTER COLUMN id SET DEFAULT nextval('legado.cargos_id_seq'::regclass);


--
-- Name: grupos id; Type: DEFAULT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.grupos ALTER COLUMN id SET DEFAULT nextval('legado.grupos_id_seq'::regclass);


--
-- Name: locais id; Type: DEFAULT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.locais ALTER COLUMN id SET DEFAULT nextval('legado.locais_id_seq'::regclass);


--
-- Name: modulos id; Type: DEFAULT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.modulos ALTER COLUMN id SET DEFAULT nextval('legado.modulos_id_seq'::regclass);


--
-- Name: painel_senha id; Type: DEFAULT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.painel_senha ALTER COLUMN id SET DEFAULT nextval('legado.painel_senha_id_seq'::regclass);


--
-- Name: prioridades id; Type: DEFAULT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.prioridades ALTER COLUMN id SET DEFAULT nextval('legado.prioridades_id_seq'::regclass);


--
-- Name: servicos id; Type: DEFAULT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.servicos ALTER COLUMN id SET DEFAULT nextval('legado.servicos_id_seq'::regclass);


--
-- Name: unidades id; Type: DEFAULT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.unidades ALTER COLUMN id SET DEFAULT nextval('legado.unidades_id_seq'::regclass);


--
-- Name: usuarios id; Type: DEFAULT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.usuarios ALTER COLUMN id SET DEFAULT nextval('legado.usuarios_id_seq'::regclass);


--
-- Data for Name: atend_codif; Type: TABLE DATA; Schema: public; Owner: novosga
--

COPY legado.atend_codif (atendimento_id, servico_id, valor_peso) FROM stdin;
1	3	1
2	3	1
7	3	1
8	3	1
\.


--
-- Data for Name: atend_meta; Type: TABLE DATA; Schema: public; Owner: novosga
--

COPY legado.atend_meta (atendimento_id, name, value) FROM stdin;
\.


--
-- Data for Name: atendimentos; Type: TABLE DATA; Schema: public; Owner: novosga
--

COPY legado.atendimentos (id, unidade_id, usuario_id, usuario_tri_id, servico_id, prioridade_id, atendimento_id, status, sigla_senha, num_senha, num_senha_serv, nm_cli, num_local, dt_cheg, dt_cha, dt_ini, dt_fim, ident_cli) FROM stdin;
1	3	3	3	3	1	\N	8	C	1	1		1	2026-07-13 18:16:16	2026-07-13 18:16:55	2026-07-13 18:19:18	2026-07-13 18:20:04	
2	3	3	3	3	1	\N	8	C	2	2	fulano 1	1	2026-07-13 18:16:44	2026-07-13 18:20:06	2026-07-13 18:20:10	2026-07-13 18:20:26	45678987654
3	3	3	3	3	1	\N	5	C	3	3	fulano 2	1	2026-07-13 18:35:36	2026-07-13 18:35:42	\N	2026-07-13 18:36:11	52315181815
4	3	3	3	3	1	\N	5	C	4	4	fulano 3	1	2026-07-13 18:37:10	2026-07-13 18:37:16	\N	2026-07-13 20:26:12	52151561231
5	3	3	3	3	1	\N	5	C	5	5	Felipe	1	2026-07-13 20:26:02	2026-07-13 20:26:13	\N	2026-07-13 20:28:03	56235151414
6	3	3	3	3	1	\N	5	C	6	6	felipe	1	2026-07-13 20:30:43	2026-07-13 20:30:49	\N	2026-07-13 20:31:51	51241241241
7	3	3	3	3	1	\N	8	C	7	7	felipe	1	2026-07-13 20:32:25	2026-07-13 20:32:30	2026-07-13 20:42:03	2026-07-13 20:42:12	13131231313
8	3	3	3	3	1	\N	8	C	8	8	felipe	1	2026-07-13 20:42:21	2026-07-13 20:42:25	2026-07-13 20:43:56	2026-07-13 20:44:01	14124124141
9	3	3	3	3	1	\N	5	C	9	9	adasdasdsa	1	2026-07-13 20:44:08	2026-07-13 20:44:14	\N	2026-07-13 20:45:41	12521412421
\.


--
-- Data for Name: cargos; Type: TABLE DATA; Schema: public; Owner: novosga
--

COPY legado.cargos (id, nome, descricao, esquerda, direita, nivel) FROM stdin;
2	Recepcionista	Cargo de funcionário(a) das Recepções.	2	3	1
1	Administrador	Administrador geral do sistema	1	6	0
3	Chefia	Chefia de setor.	4	5	1
\.


--
-- Data for Name: cargos_mod_perm; Type: TABLE DATA; Schema: public; Owner: novosga
--

COPY legado.cargos_mod_perm (cargo_id, modulo_id, permissao) FROM stdin;
1	1	3
1	2	3
1	3	3
1	4	3
1	5	3
1	6	3
1	7	3
1	8	3
1	9	3
1	10	3
1	11	3
1	12	3
1	13	3
1	14	3
2	2	3
2	12	3
2	8	3
2	11	3
3	4	3
\.


--
-- Data for Name: config; Type: TABLE DATA; Schema: public; Owner: novosga
--

COPY legado.config (chave, valor, tipo) FROM stdin;
version	1.5.0	1
auth	a:3:{s:4:"type";s:2:"db";s:2:"db";a:0:{}s:4:"ldap";a:7:{s:4:"host";s:0:"";s:4:"port";s:0:"";s:6:"baseDn";s:0:"";s:14:"loginAttribute";s:0:"";s:8:"username";s:0:"";s:8:"password";s:0:"";s:6:"filter";s:0:"";}}	3
numeracao	2	2
\.


--
-- Data for Name: contador; Type: TABLE DATA; Schema: public; Owner: novosga
--

COPY legado.contador (unidade_id, total) FROM stdin;
2	0
3	9
\.


--
-- Data for Name: grupos; Type: TABLE DATA; Schema: public; Owner: novosga
--

COPY legado.grupos (id, nome, descricao, esquerda, direita, nivel) FROM stdin;
4	Recepção de Ultrassonografia/Ecocardiografia	Grupo de atendimento da Recepção de Ultrassonografia/Ecocardiografia, ligada à Unidade de Diagnóstico por Imagem.	4	5	3
5	Recepção do Laboratório de Análises Clínicas	Grupo de atendimento da recepção de coleta de exames laboratoriais, da Unidade de Laboratório de Análises Clínicas.	6	7	3
1	Raíz	Grupo Raíz	1	12	0
2	HU-UFGD	Grupo raiz do HU-UFGD.	2	11	1
3	Setor de Apoio Diagnóstico	Grupo de atendimento das Unidades ligadas ao Setor de Apoio Diagnóstico.	3	10	2
6	Recepção de Radiografia/Tomografia	Grupo de atendimento da Recepção de Radiografia/Tomografia, ligada à Unidade de Diagnóstico por Imagem.	8	9	3
\.


--
-- Data for Name: historico_atend_codif; Type: TABLE DATA; Schema: public; Owner: novosga
--

COPY legado.historico_atend_codif (atendimento_id, servico_id, valor_peso) FROM stdin;
\.


--
-- Data for Name: historico_atend_meta; Type: TABLE DATA; Schema: public; Owner: novosga
--

COPY legado.historico_atend_meta (atendimento_id, name, value) FROM stdin;
\.


--
-- Data for Name: historico_atendimentos; Type: TABLE DATA; Schema: public; Owner: novosga
--

COPY legado.historico_atendimentos (id, unidade_id, usuario_id, usuario_tri_id, servico_id, prioridade_id, atendimento_id, status, sigla_senha, num_senha, num_senha_serv, nm_cli, num_local, dt_cheg, dt_cha, dt_ini, dt_fim, ident_cli) FROM stdin;
\.


--
-- Data for Name: locais; Type: TABLE DATA; Schema: public; Owner: novosga
--

COPY legado.locais (id, nome) FROM stdin;
1	Guichê
2	Sala
3	Mesa
\.


--
-- Data for Name: modulos; Type: TABLE DATA; Schema: public; Owner: novosga
--

COPY legado.modulos (id, chave, nome, descricao, tipo, status) FROM stdin;
1	sga.admin	Administração	Configurações gerais do sistema	1	1
2	sga.atendimento	Atendimento	Efetue o atendimento às senhas distribuídas dos serviços que você atende	0	1
3	sga.cargos	Cargos	Gerencie os cargos do sistema	1	1
4	sga.estatisticas	Estatísticas	Visualize e exporte estastísticas e relatórios sobre o sistema	1	1
5	sga.grupos	Grupos	Gerencie os grupos do sistema	1	1
6	sga.locais	Locais	Gerencie os locais de atendimento	1	1
7	sga.modulos	Módulos	Gerencie os módulos instalados	1	1
8	sga.monitor	Monitor	Gerencie as senhas aguardando atendimento	0	1
9	sga.prioridades	Prioridades	Gerencie os prioridades do sistema	1	1
10	sga.servicos	Serviços	Gerencie os serviços do sistema	1	1
11	sga.triagem	Triagem	Gerencie a distribuíção das senhas da unidade atual	0	1
12	sga.unidade	Configuração	Módulo para gerenciamento da unidade atual	0	1
13	sga.unidades	Unidades	Gerencie as unidades do sistema	1	1
14	sga.usuarios	Usuários	Gerencie os usuários do sistema	1	1
\.


--
-- Data for Name: oauth_access_tokens; Type: TABLE DATA; Schema: public; Owner: novosga
--

COPY legado.oauth_access_tokens (access_token, client_id, user_id, expires, scope) FROM stdin;
\.


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: public; Owner: novosga
--

COPY legado.oauth_clients (client_id, client_secret, redirect_uri, grant_types, scope, user_id) FROM stdin;
\.


--
-- Data for Name: oauth_refresh_tokens; Type: TABLE DATA; Schema: public; Owner: novosga
--

COPY legado.oauth_refresh_tokens (refresh_token, client_id, user_id, expires, scope) FROM stdin;
\.


--
-- Data for Name: oauth_scopes; Type: TABLE DATA; Schema: public; Owner: novosga
--

COPY legado.oauth_scopes (scope, is_default) FROM stdin;
\.


--
-- Data for Name: paineis; Type: TABLE DATA; Schema: public; Owner: novosga
--

COPY legado.paineis (unidade_id, host) FROM stdin;
\.


--
-- Data for Name: paineis_servicos; Type: TABLE DATA; Schema: public; Owner: novosga
--

COPY legado.paineis_servicos (host, unidade_id, servico_id) FROM stdin;
\.


--
-- Data for Name: painel_senha; Type: TABLE DATA; Schema: public; Owner: novosga
--

COPY legado.painel_senha (id, unidade_id, servico_id, num_senha, sig_senha, msg_senha, local, num_local, peso, prioridade, nome_cliente, documento_cliente) FROM stdin;
1	3	3	1	C	Convencional	Guichê	1	0	Sem prioridade		
2	3	3	2	C	Convencional	Guichê	1	0	Sem prioridade	fulano 1	45678987654
3	3	3	2	C	Convencional	Guichê	1	0	Sem prioridade	fulano 1	45678987654
4	3	3	3	C	Convencional	Guichê	1	0	Sem prioridade	fulano 2	52315181815
5	3	3	4	C	Convencional	Guichê	1	0	Sem prioridade	fulano 3	52151561231
6	3	3	5	C	Convencional	Guichê	1	0	Sem prioridade	Felipe	56235151414
7	3	3	5	C	Convencional	Guichê	1	0	Sem prioridade	Felipe	56235151414
8	3	3	5	C	Convencional	Guichê	1	0	Sem prioridade	Felipe	56235151414
9	3	3	6	C	Convencional	Guichê	1	0	Sem prioridade	felipe	51241241241
10	3	3	7	C	Convencional	Guichê	1	0	Sem prioridade	felipe	13131231313
11	3	3	8	C	Convencional	Guichê	1	0	Sem prioridade	felipe	14124124141
12	3	3	8	C	Convencional	Guichê	1	0	Sem prioridade	felipe	14124124141
13	3	3	8	C	Convencional	Guichê	1	0	Sem prioridade	felipe	14124124141
14	3	3	9	C	Convencional	Guichê	1	0	Sem prioridade	adasdasdsa	12521412421
\.


--
-- Data for Name: prioridades; Type: TABLE DATA; Schema: public; Owner: novosga
--

COPY legado.prioridades (id, nome, descricao, peso, status) FROM stdin;
1	Sem prioridade	Atendimento normal	0	1
2	Portador de Deficiência	Atendimento prioritáro para portadores de deficiência	1	1
3	Gestante	Atendimento prioritáro para gestantes	1	1
4	Idoso	Atendimento prioritáro para idosos	1	1
5	Outros	Qualquer outra prioridade	1	1
6	Longa espera	Pacientes sem prioridade que estão esperando há muito tempo.	2	1
\.


--
-- Data for Name: serv_meta; Type: TABLE DATA; Schema: public; Owner: novosga
--

COPY legado.serv_meta (servico_id, name, value) FROM stdin;
\.


--
-- Data for Name: servicos; Type: TABLE DATA; Schema: public; Owner: novosga
--

COPY legado.servicos (id, macro_id, descricao, nome, status, peso) FROM stdin;
1	\N	Chamada para atendimento na Recepção do Ambulatório 1.	Ambulatório 1	1	1
2	\N	Chamada para atendimento na Recepção do Ambulatório 2.	Ambulatório 2	1	1
3	\N	Chamada para cadastro do paciente antes coleta de sangue no Laboratório.	Coleta Exame de Sangue	1	1
4	\N	Chamada para realização de ecocardiograma.	Ecocardiograma	1	1
5	\N	Chamada para realização de eco-doppler vascular (ultrassom vascular).	Eco-Doppler Vascular	1	1
6	\N	Chamada para realização de eletroencefalograma.	Eletroencefalograma (EEG)	1	1
7	\N	Chamada para realização de exame de endoscopia.	Endoscopia	1	1
8	\N	Chamada para o serviço de hemodinâmica.	Hemodinâmica	1	1
9	\N	Chamada para admissão do paciente na Recepção de Internação.	Internação	1	1
10	\N	Chamada para realização de exame de mamografia.	Mamografia	1	1
11	\N	Chamada para agendamento de cirurgias.	Marcação Cirúrgica	1	1
12	\N	Chamada para atendimento no PAC.	PAC	1	1
13	\N	Chamada para atendimento no PAP.	PAP	1	1
14	\N	Chamada para realização de exame de radiografia.	Radiografia	1	1
15	\N	Chamada para retirada de  resultados de exames na recepção do Laboratório e Imagem.	Retirada de Exame Laboratorial	1	1
16	\N	Serviço para testes das chamadas de senhas (SETISD).	SETISD	1	1
17	\N	Chamada para realização de exame de tomografia computadorizada.	Tomografia Computadorizada	1	1
18	\N	Chamada para realização de exame de ultrassonografia.	Ultrassonografia Geral	1	1
19	\N	Chamada para encaminhamento dos pacientes à Sala de Vacina.	Vacina	1	1
\.


--
-- Data for Name: uni_meta; Type: TABLE DATA; Schema: public; Owner: novosga
--

COPY legado.uni_meta (unidade_id, name, value) FROM stdin;
\.


--
-- Data for Name: uni_serv; Type: TABLE DATA; Schema: public; Owner: novosga
--

COPY legado.uni_serv (unidade_id, servico_id, local_id, sigla, status, peso) FROM stdin;
3	1	1	A	0	1
3	2	1	A	0	1
3	4	1	A	0	1
3	5	1	A	0	1
3	6	1	A	0	1
3	7	1	A	0	1
3	8	1	A	0	1
3	9	1	A	0	1
3	10	1	A	0	1
3	11	1	A	0	1
3	12	1	A	0	1
3	13	1	A	0	1
3	14	1	A	0	1
3	16	1	A	0	1
3	17	1	A	0	1
3	18	1	A	0	1
3	19	1	A	0	1
3	3	1	C	1	1
3	15	1	R	1	1
2	1	1	A	0	1
2	2	1	A	0	1
2	3	1	A	0	1
2	4	1	A	0	1
2	5	1	A	0	1
2	6	1	A	0	1
2	7	1	A	0	1
2	8	1	A	0	1
2	9	1	A	0	1
2	10	1	A	0	1
2	11	1	A	0	1
2	12	1	A	0	1
2	13	1	A	0	1
2	14	1	A	0	1
2	15	1	A	0	1
2	16	1	A	0	1
2	17	1	A	0	1
2	18	1	A	0	1
2	19	1	A	0	1
\.


--
-- Data for Name: unidades; Type: TABLE DATA; Schema: public; Owner: novosga
--

COPY legado.unidades (id, grupo_id, codigo, nome, status, stat_imp, msg_imp) FROM stdin;
1	4	2	Ecocardiografia e Ultrassonografia	1	1	Novo SGA
3	5	1	Coleta de Exames Laboratoriais	1	1	UACAP - HU-UFGD
2	6	3	Radiografia e Tomografia	1	1	Novo SGA
\.


--
-- Data for Name: usu_grup_cargo; Type: TABLE DATA; Schema: public; Owner: novosga
--

COPY legado.usu_grup_cargo (usuario_id, grupo_id, cargo_id) FROM stdin;
1	1	1
2	6	2
3	5	2
4	5	2
\.


--
-- Data for Name: usu_meta; Type: TABLE DATA; Schema: public; Owner: novosga
--

COPY legado.usu_meta (usuario_id, name, value) FROM stdin;
1	atendimento.local	1
1	atendimento.tipo	1
2	unidade	2
1	unidade	3
3	unidade	3
3	atendimento.local	1
3	atendimento.tipo	1
4	unidade	3
4	atendimento.local	2
4	atendimento.tipo	1
\.


--
-- Data for Name: usu_serv; Type: TABLE DATA; Schema: public; Owner: novosga
--

COPY legado.usu_serv (unidade_id, servico_id, usuario_id) FROM stdin;
3	3	3
3	15	3
3	3	4
3	15	4
\.


--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: novosga
--

COPY legado.usuarios (id, login, nome, sobrenome, senha, ult_acesso, status, session_id) FROM stdin;
1	admin	Felipe	Vilhalva	e10adc3949ba59abbe56e057f20f883e	2026-07-13 17:55:24	1	0a255edf5ec2780fe2a380477fe28dd2
4	amanda.alves	Amanda	Alves França	e10adc3949ba59abbe56e057f20f883e	2026-07-13 18:15:48	1	9788cce10a2fdf3845de5fcbcd45dac1
3	ryan.vargas	Ryan	Oliveira Vargas	e10adc3949ba59abbe56e057f20f883e	2026-07-13 20:01:08	1	9788cce10a2fdf3845de5fcbcd45dac1
2	marli.gomes	Marli	Gomes	e10adc3949ba59abbe56e057f20f883e	2026-07-27 18:31:30	1	63ad34184ada630bea383fd1eaec47a6
\.


--
-- Name: atendimentos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: novosga
--

SELECT pg_catalog.setval('legado.atendimentos_id_seq', 9, true);


--
-- Name: cargos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: novosga
--

SELECT pg_catalog.setval('legado.cargos_id_seq', 3, true);


--
-- Name: grupos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: novosga
--

SELECT pg_catalog.setval('legado.grupos_id_seq', 6, true);


--
-- Name: locais_id_seq; Type: SEQUENCE SET; Schema: public; Owner: novosga
--

SELECT pg_catalog.setval('legado.locais_id_seq', 3, true);


--
-- Name: modulos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: novosga
--

SELECT pg_catalog.setval('legado.modulos_id_seq', 14, true);


--
-- Name: painel_senha_id_seq; Type: SEQUENCE SET; Schema: public; Owner: novosga
--

SELECT pg_catalog.setval('legado.painel_senha_id_seq', 14, true);


--
-- Name: prioridades_id_seq; Type: SEQUENCE SET; Schema: public; Owner: novosga
--

SELECT pg_catalog.setval('legado.prioridades_id_seq', 6, true);


--
-- Name: servicos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: novosga
--

SELECT pg_catalog.setval('legado.servicos_id_seq', 19, true);


--
-- Name: unidades_id_seq; Type: SEQUENCE SET; Schema: public; Owner: novosga
--

SELECT pg_catalog.setval('legado.unidades_id_seq', 3, true);


--
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: novosga
--

SELECT pg_catalog.setval('legado.usuarios_id_seq', 4, true);


--
-- Name: atend_codif atend_codif_pkey; Type: CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.atend_codif
    ADD CONSTRAINT atend_codif_pkey PRIMARY KEY (atendimento_id, servico_id);


--
-- Name: atend_meta atend_meta_pkey; Type: CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.atend_meta
    ADD CONSTRAINT atend_meta_pkey PRIMARY KEY (atendimento_id, name);


--
-- Name: atendimentos atendimentos_pkey; Type: CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.atendimentos
    ADD CONSTRAINT atendimentos_pkey PRIMARY KEY (id);


--
-- Name: cargos_mod_perm cargos_mod_perm_pkey; Type: CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.cargos_mod_perm
    ADD CONSTRAINT cargos_mod_perm_pkey PRIMARY KEY (cargo_id, modulo_id);


--
-- Name: cargos cargos_pkey; Type: CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.cargos
    ADD CONSTRAINT cargos_pkey PRIMARY KEY (id);


--
-- Name: config config_pkey; Type: CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.config
    ADD CONSTRAINT config_pkey PRIMARY KEY (chave);


--
-- Name: contador contador_pkey; Type: CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.contador
    ADD CONSTRAINT contador_pkey PRIMARY KEY (unidade_id);


--
-- Name: grupos grupos_pkey; Type: CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.grupos
    ADD CONSTRAINT grupos_pkey PRIMARY KEY (id);


--
-- Name: historico_atend_codif historico_atend_codif_pkey; Type: CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.historico_atend_codif
    ADD CONSTRAINT historico_atend_codif_pkey PRIMARY KEY (atendimento_id, servico_id);


--
-- Name: historico_atendimentos historico_atendimentos_pkey; Type: CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.historico_atendimentos
    ADD CONSTRAINT historico_atendimentos_pkey PRIMARY KEY (id);


--
-- Name: locais locais_pkey; Type: CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.locais
    ADD CONSTRAINT locais_pkey PRIMARY KEY (id);


--
-- Name: modulos modulos_pkey; Type: CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.modulos
    ADD CONSTRAINT modulos_pkey PRIMARY KEY (id);


--
-- Name: oauth_access_tokens oauth_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.oauth_access_tokens
    ADD CONSTRAINT oauth_access_tokens_pkey PRIMARY KEY (access_token);


--
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (client_id);


--
-- Name: oauth_refresh_tokens oauth_refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.oauth_refresh_tokens
    ADD CONSTRAINT oauth_refresh_tokens_pkey PRIMARY KEY (refresh_token);


--
-- Name: paineis paineis_pkey; Type: CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.paineis
    ADD CONSTRAINT paineis_pkey PRIMARY KEY (host);


--
-- Name: paineis_servicos paineis_servicos_pkey; Type: CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.paineis_servicos
    ADD CONSTRAINT paineis_servicos_pkey PRIMARY KEY (host, servico_id);


--
-- Name: painel_senha painel_senha_pkey; Type: CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.painel_senha
    ADD CONSTRAINT painel_senha_pkey PRIMARY KEY (id);


--
-- Name: prioridades prioridades_pkey; Type: CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.prioridades
    ADD CONSTRAINT prioridades_pkey PRIMARY KEY (id);


--
-- Name: serv_meta serv_meta_pkey; Type: CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.serv_meta
    ADD CONSTRAINT serv_meta_pkey PRIMARY KEY (servico_id, name);


--
-- Name: servicos servicos_pkey; Type: CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.servicos
    ADD CONSTRAINT servicos_pkey PRIMARY KEY (id);


--
-- Name: uni_meta uni_meta_pkey; Type: CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.uni_meta
    ADD CONSTRAINT uni_meta_pkey PRIMARY KEY (unidade_id, name);


--
-- Name: uni_serv uni_serv_pkey; Type: CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.uni_serv
    ADD CONSTRAINT uni_serv_pkey PRIMARY KEY (unidade_id, servico_id);


--
-- Name: unidades unidades_pkey; Type: CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.unidades
    ADD CONSTRAINT unidades_pkey PRIMARY KEY (id);


--
-- Name: usu_grup_cargo usu_grup_cargo_pkey; Type: CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.usu_grup_cargo
    ADD CONSTRAINT usu_grup_cargo_pkey PRIMARY KEY (usuario_id, grupo_id);


--
-- Name: usu_meta usu_meta_pkey; Type: CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.usu_meta
    ADD CONSTRAINT usu_meta_pkey PRIMARY KEY (usuario_id, name);


--
-- Name: usu_serv usu_serv_pkey; Type: CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.usu_serv
    ADD CONSTRAINT usu_serv_pkey PRIMARY KEY (unidade_id, servico_id, usuario_id);


--
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- Name: codigo; Type: INDEX; Schema: public; Owner: novosga
--

CREATE UNIQUE INDEX codigo ON legado.unidades USING btree (codigo);


--
-- Name: direita; Type: INDEX; Schema: public; Owner: novosga
--

CREATE INDEX direita ON legado.grupos USING btree (direita);


--
-- Name: esqdir; Type: INDEX; Schema: public; Owner: novosga
--

CREATE INDEX esqdir ON legado.grupos USING btree (esquerda, direita);


--
-- Name: esquerda; Type: INDEX; Schema: public; Owner: novosga
--

CREATE INDEX esquerda ON legado.grupos USING btree (esquerda);


--
-- Name: fki_atendimentos_ibfk_3; Type: INDEX; Schema: public; Owner: novosga
--

CREATE INDEX fki_atendimentos_ibfk_3 ON legado.atendimentos USING btree (status);


--
-- Name: local_serv_nm; Type: INDEX; Schema: public; Owner: novosga
--

CREATE UNIQUE INDEX local_serv_nm ON legado.locais USING btree (nome);


--
-- Name: login; Type: INDEX; Schema: public; Owner: novosga
--

CREATE UNIQUE INDEX login ON legado.usuarios USING btree (login);


--
-- Name: modulos_chave; Type: INDEX; Schema: public; Owner: novosga
--

CREATE UNIQUE INDEX modulos_chave ON legado.modulos USING btree (chave);


--
-- Name: atend_codif atend_codif_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.atend_codif
    ADD CONSTRAINT atend_codif_ibfk_1 FOREIGN KEY (atendimento_id) REFERENCES legado.atendimentos(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: atend_codif atend_codif_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.atend_codif
    ADD CONSTRAINT atend_codif_ibfk_2 FOREIGN KEY (servico_id) REFERENCES legado.servicos(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: atend_meta atend_meta_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.atend_meta
    ADD CONSTRAINT atend_meta_ibfk_1 FOREIGN KEY (atendimento_id) REFERENCES legado.atendimentos(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: atendimentos atendimentos_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.atendimentos
    ADD CONSTRAINT atendimentos_ibfk_1 FOREIGN KEY (prioridade_id) REFERENCES legado.prioridades(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: atendimentos atendimentos_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.atendimentos
    ADD CONSTRAINT atendimentos_ibfk_2 FOREIGN KEY (unidade_id, servico_id) REFERENCES legado.uni_serv(unidade_id, servico_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: atendimentos atendimentos_ibfk_4; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.atendimentos
    ADD CONSTRAINT atendimentos_ibfk_4 FOREIGN KEY (usuario_id) REFERENCES legado.usuarios(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: atendimentos atendimentos_ibfk_5; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.atendimentos
    ADD CONSTRAINT atendimentos_ibfk_5 FOREIGN KEY (usuario_tri_id) REFERENCES legado.usuarios(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: atendimentos atendimentos_ibfk_6; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.atendimentos
    ADD CONSTRAINT atendimentos_ibfk_6 FOREIGN KEY (atendimento_id) REFERENCES legado.atendimentos(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: cargos_mod_perm cargos_mod_perm_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.cargos_mod_perm
    ADD CONSTRAINT cargos_mod_perm_ibfk_1 FOREIGN KEY (cargo_id) REFERENCES legado.cargos(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: cargos_mod_perm cargos_mod_perm_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.cargos_mod_perm
    ADD CONSTRAINT cargos_mod_perm_ibfk_2 FOREIGN KEY (modulo_id) REFERENCES legado.modulos(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: contador contador_unidade_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.contador
    ADD CONSTRAINT contador_unidade_id_fkey FOREIGN KEY (unidade_id) REFERENCES legado.unidades(id);


--
-- Name: historico_atend_codif historico_atend_codif_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.historico_atend_codif
    ADD CONSTRAINT historico_atend_codif_ibfk_1 FOREIGN KEY (atendimento_id) REFERENCES legado.historico_atendimentos(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: historico_atend_codif historico_atend_codif_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.historico_atend_codif
    ADD CONSTRAINT historico_atend_codif_ibfk_2 FOREIGN KEY (servico_id) REFERENCES legado.servicos(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: historico_atend_meta historico_atend_meta_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.historico_atend_meta
    ADD CONSTRAINT historico_atend_meta_ibfk_1 FOREIGN KEY (atendimento_id) REFERENCES legado.historico_atendimentos(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: historico_atendimentos historico_atendimentos_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.historico_atendimentos
    ADD CONSTRAINT historico_atendimentos_ibfk_1 FOREIGN KEY (prioridade_id) REFERENCES legado.prioridades(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: historico_atendimentos historico_atendimentos_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.historico_atendimentos
    ADD CONSTRAINT historico_atendimentos_ibfk_2 FOREIGN KEY (unidade_id, servico_id) REFERENCES legado.uni_serv(unidade_id, servico_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: historico_atendimentos historico_atendimentos_ibfk_4; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.historico_atendimentos
    ADD CONSTRAINT historico_atendimentos_ibfk_4 FOREIGN KEY (usuario_id) REFERENCES legado.usuarios(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: historico_atendimentos historico_atendimentos_ibfk_5; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.historico_atendimentos
    ADD CONSTRAINT historico_atendimentos_ibfk_5 FOREIGN KEY (usuario_tri_id) REFERENCES legado.usuarios(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: historico_atendimentos historico_atendimentos_ibfk_6; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.historico_atendimentos
    ADD CONSTRAINT historico_atendimentos_ibfk_6 FOREIGN KEY (atendimento_id) REFERENCES legado.historico_atendimentos(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: paineis paineis_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.paineis
    ADD CONSTRAINT paineis_ibfk_1 FOREIGN KEY (unidade_id) REFERENCES legado.unidades(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: paineis_servicos paineis_servicos_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.paineis_servicos
    ADD CONSTRAINT paineis_servicos_ibfk_1 FOREIGN KEY (host) REFERENCES legado.paineis(host) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: paineis_servicos paineis_servicos_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.paineis_servicos
    ADD CONSTRAINT paineis_servicos_ibfk_2 FOREIGN KEY (unidade_id, servico_id) REFERENCES legado.uni_serv(unidade_id, servico_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: painel_senha painel_senha_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.painel_senha
    ADD CONSTRAINT painel_senha_ibfk_1 FOREIGN KEY (unidade_id) REFERENCES legado.unidades(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: painel_senha painel_senha_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.painel_senha
    ADD CONSTRAINT painel_senha_ibfk_2 FOREIGN KEY (servico_id) REFERENCES legado.servicos(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: serv_meta serv_meta_servico_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.serv_meta
    ADD CONSTRAINT serv_meta_servico_id_fkey FOREIGN KEY (servico_id) REFERENCES legado.servicos(id);


--
-- Name: servicos servicos_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.servicos
    ADD CONSTRAINT servicos_ibfk_1 FOREIGN KEY (macro_id) REFERENCES legado.servicos(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: uni_meta uni_meta_unidade_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.uni_meta
    ADD CONSTRAINT uni_meta_unidade_id_fkey FOREIGN KEY (unidade_id) REFERENCES legado.unidades(id);


--
-- Name: uni_serv uni_serv_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.uni_serv
    ADD CONSTRAINT uni_serv_ibfk_1 FOREIGN KEY (unidade_id) REFERENCES legado.unidades(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: uni_serv uni_serv_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.uni_serv
    ADD CONSTRAINT uni_serv_ibfk_2 FOREIGN KEY (servico_id) REFERENCES legado.servicos(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: uni_serv uni_serv_ibfk_3; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.uni_serv
    ADD CONSTRAINT uni_serv_ibfk_3 FOREIGN KEY (local_id) REFERENCES legado.locais(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: unidades unidades_grupo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.unidades
    ADD CONSTRAINT unidades_grupo_id_fkey FOREIGN KEY (grupo_id) REFERENCES legado.grupos(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: usu_grup_cargo usu_grup_cargo_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.usu_grup_cargo
    ADD CONSTRAINT usu_grup_cargo_ibfk_1 FOREIGN KEY (usuario_id) REFERENCES legado.usuarios(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: usu_grup_cargo usu_grup_cargo_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.usu_grup_cargo
    ADD CONSTRAINT usu_grup_cargo_ibfk_2 FOREIGN KEY (grupo_id) REFERENCES legado.grupos(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: usu_grup_cargo usu_grup_cargo_ibfk_3; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.usu_grup_cargo
    ADD CONSTRAINT usu_grup_cargo_ibfk_3 FOREIGN KEY (cargo_id) REFERENCES legado.cargos(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: usu_meta usu_meta_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.usu_meta
    ADD CONSTRAINT usu_meta_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES legado.usuarios(id);


--
-- Name: usu_serv usu_serv_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.usu_serv
    ADD CONSTRAINT usu_serv_ibfk_1 FOREIGN KEY (servico_id, unidade_id) REFERENCES legado.uni_serv(servico_id, unidade_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: usu_serv usu_serv_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: novosga
--

ALTER TABLE ONLY legado.usu_serv
    ADD CONSTRAINT usu_serv_ibfk_2 FOREIGN KEY (usuario_id) REFERENCES legado.usuarios(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

\unrestrict qeYPxiUZvkU0ehL3OQWqO3xAWwbBtlBKOthXwKncIqAQnE0iGkvOjckKgZOMg4f

