--
-- PostgreSQL database dump
--

\restrict It5y8cdm6lIfbkbCJ8OpfnwHD1h8kHQ4avQonNVnkHg4WWfZMEDGLlQxDSZb8e0

-- Dumped from database version 16.15
-- Dumped by pg_dump version 16.14 (Ubuntu 16.14-0ubuntu0.24.04.1)

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

--
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE public.clientes DISABLE TRIGGER ALL;

COPY public.clientes (id, nome, documento, email, telefone, dt_nascimento, genero, observacao, end_pais, end_cep, end_estado, end_cidade, end_logradouro, end_numero, end_complemento) FROM stdin;
\.


ALTER TABLE public.clientes ENABLE TRIGGER ALL;

--
-- Data for Name: servicos; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE public.servicos DISABLE TRIGGER ALL;

COPY public.servicos (id, macro_id, nome, descricao, ativo, peso, created_at, updated_at, deleted_at) FROM stdin;
1	\N	Ambulatório 1	Chamada para atendimento na Recepção do Ambulatório 1.	t	1	2026-08-14 23:24:12	\N	\N
2	\N	Ambulatório 2	Chamada para atendimento na Recepção do Ambulatório 2.	t	1	2026-08-14 23:24:12	\N	\N
3	\N	Coleta Exame de Sangue	Chamada para cadastro do paciente antes coleta de sangue no Laboratório.	t	1	2026-08-14 23:24:12	\N	\N
4	\N	Ecocardiograma	Chamada para realização de ecocardiograma.	t	1	2026-08-14 23:24:12	\N	\N
5	\N	Eco-Doppler Vascular	Chamada para realização de eco-doppler vascular (ultrassom vascular).	t	1	2026-08-14 23:24:12	\N	\N
6	\N	Eletroencefalograma (EEG)	Chamada para realização de eletroencefalograma.	t	1	2026-08-14 23:24:12	\N	\N
7	\N	Endoscopia	Chamada para realização de exame de endoscopia.	t	1	2026-08-14 23:24:12	\N	\N
8	\N	Hemodinâmica	Chamada para o serviço de hemodinâmica.	t	1	2026-08-14 23:24:12	\N	\N
9	\N	Internação	Chamada para admissão do paciente na Recepção de Internação.	t	1	2026-08-14 23:24:12	\N	\N
10	\N	Mamografia	Chamada para realização de exame de mamografia.	t	1	2026-08-14 23:24:12	\N	\N
11	\N	Marcação Cirúrgica	Chamada para agendamento de cirurgias.	t	1	2026-08-14 23:24:12	\N	\N
12	\N	PAC	Chamada para atendimento no PAC.	t	1	2026-08-14 23:24:12	\N	\N
13	\N	PAP	Chamada para atendimento no PAP.	t	1	2026-08-14 23:24:12	\N	\N
14	\N	Radiografia	Chamada para realização de exame de radiografia.	t	1	2026-08-14 23:24:12	\N	\N
15	\N	Retirada de Exame Laboratorial	Chamada para retirada de  resultados de exames na recepção do Laboratório e Imagem.	t	1	2026-08-14 23:24:12	\N	\N
16	\N	SETISD	Serviço para testes das chamadas de senhas (SETISD).	t	1	2026-08-14 23:24:12	\N	\N
17	\N	Tomografia Computadorizada	Chamada para realização de exame de tomografia computadorizada.	t	1	2026-08-14 23:24:12	\N	\N
18	\N	Ultrassonografia Geral	Chamada para realização de exame de ultrassonografia.	t	1	2026-08-14 23:24:12	\N	\N
19	\N	Vacina	Chamada para encaminhamento dos pacientes à Sala de Vacina.	t	1	2026-08-14 23:24:12	\N	\N
\.


ALTER TABLE public.servicos ENABLE TRIGGER ALL;

--
-- Data for Name: unidades; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE public.unidades DISABLE TRIGGER ALL;

COPY public.unidades (id, nome, descricao, ativo, created_at, updated_at, deleted_at, impressao_cabecalho, impressao_rodape, impressao_exibir_data, impressao_exibir_prioridade, impressao_exibir_nome_unidade, impressao_exibir_nome_servico, impressao_exibir_mensagem_servico, timezone) FROM stdin;
1	Ecocardiografia e Ultrassonografia	Ecocardiografia e Ultrassonografia	t	2026-08-14 23:24:12	\N	\N	Novo SGA		t	t	t	t	t	\N
3	Coleta de Exames Laboratoriais	Coleta de Exames Laboratoriais	t	2026-08-14 23:24:12	\N	\N	UACAP - HU-UFGD		t	t	t	t	t	\N
2	Radiografia e Tomografia	Radiografia e Tomografia	t	2026-08-14 23:24:12	\N	\N	Novo SGA		t	t	t	t	t	\N
\.


ALTER TABLE public.unidades ENABLE TRIGGER ALL;

--
-- Data for Name: agendamentos; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE public.agendamentos DISABLE TRIGGER ALL;

COPY public.agendamentos (id, cliente_id, unidade_id, servico_id, data, hora, data_confirmacao, oid, situacao) FROM stdin;
\.


ALTER TABLE public.agendamentos ENABLE TRIGGER ALL;

--
-- Data for Name: prioridades; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE public.prioridades DISABLE TRIGGER ALL;

COPY public.prioridades (id, nome, descricao, peso, ativo, created_at, updated_at, deleted_at, cor) FROM stdin;
1	Sem prioridade	Atendimento normal	0	t	2026-08-14 23:24:12	\N	\N	\N
2	Portador de Deficiência	Atendimento prioritáro para portadores de deficiência	1	t	2026-08-14 23:24:12	\N	\N	\N
3	Gestante	Atendimento prioritáro para gestantes	1	t	2026-08-14 23:24:12	\N	\N	\N
4	Idoso	Atendimento prioritáro para idosos	1	t	2026-08-14 23:24:12	\N	\N	\N
5	Outros	Qualquer outra prioridade	1	t	2026-08-14 23:24:12	\N	\N	\N
6	Longa espera	Pacientes sem prioridade que estão esperando há muito tempo.	2	t	2026-08-14 23:24:12	\N	\N	\N
\.


ALTER TABLE public.prioridades ENABLE TRIGGER ALL;

--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE public.usuarios DISABLE TRIGGER ALL;

COPY public.usuarios (id, login, nome, sobrenome, email, senha, ativo, ultimo_acesso, ip, session_id, algorithm, admin, salt, created_at, updated_at, deleted_at) FROM stdin;
1	admin	Felipe	Vilhalva	\N	e10adc3949ba59abbe56e057f20f883e	t	2026-07-13 17:55:24	\N	0a255edf5ec2780fe2a380477fe28dd2	md5	t	\N	2026-08-14 23:24:12	\N	\N
4	amanda.alves	Amanda	Alves França	\N	e10adc3949ba59abbe56e057f20f883e	t	2026-07-13 18:15:48	\N	9788cce10a2fdf3845de5fcbcd45dac1	md5	f	\N	2026-08-14 23:24:12	\N	\N
3	ryan.vargas	Ryan	Oliveira Vargas	\N	e10adc3949ba59abbe56e057f20f883e	t	2026-07-13 20:01:08	\N	9788cce10a2fdf3845de5fcbcd45dac1	md5	f	\N	2026-08-14 23:24:12	\N	\N
2	marli.gomes	Marli	Gomes	\N	e10adc3949ba59abbe56e057f20f883e	t	2026-07-27 18:31:30	\N	63ad34184ada630bea383fd1eaec47a6	md5	f	\N	2026-08-14 23:24:12	\N	\N
\.


ALTER TABLE public.usuarios ENABLE TRIGGER ALL;

--
-- Data for Name: atendimentos; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE public.atendimentos DISABLE TRIGGER ALL;

COPY public.atendimentos (id, cliente_id, unidade_id, servico_id, prioridade_id, usuario_id, usuario_tri_id, atendimento_id, num_local, dt_age, dt_cheg, dt_cha, dt_ini, dt_fim, tempo_espera, tempo_permanencia, tempo_atendimento, tempo_deslocamento, status, resolucao, observacao, senha_sigla, senha_numero, local_id) FROM stdin;
\.


ALTER TABLE public.atendimentos ENABLE TRIGGER ALL;

--
-- Data for Name: atendimentos_codificados; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE public.atendimentos_codificados DISABLE TRIGGER ALL;

COPY public.atendimentos_codificados (servico_id, atendimento_id, valor_peso) FROM stdin;
\.


ALTER TABLE public.atendimentos_codificados ENABLE TRIGGER ALL;

--
-- Data for Name: atendimentos_metadata; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE public.atendimentos_metadata DISABLE TRIGGER ALL;

COPY public.atendimentos_metadata (namespace, name, atendimento_id, value) FROM stdin;
\.


ALTER TABLE public.atendimentos_metadata ENABLE TRIGGER ALL;

--
-- Data for Name: clientes_metadata; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE public.clientes_metadata DISABLE TRIGGER ALL;

COPY public.clientes_metadata (namespace, name, cliente_id, value) FROM stdin;
\.


ALTER TABLE public.clientes_metadata ENABLE TRIGGER ALL;

--
-- Data for Name: contador; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE public.contador DISABLE TRIGGER ALL;

COPY public.contador (unidade_id, servico_id, numero) FROM stdin;
3	4	1
3	16	1
2	19	1
3	1	1
3	14	1
2	5	1
2	13	1
3	3	1
2	15	1
3	7	1
3	9	1
2	2	1
2	18	1
2	12	1
2	10	1
3	8	1
2	17	1
2	11	1
3	6	1
3	15	1
2	7	1
2	9	1
2	14	1
3	5	1
3	13	1
2	3	1
3	19	1
2	1	1
2	4	1
2	16	1
2	6	1
3	17	1
3	11	1
3	2	1
3	18	1
2	8	1
3	10	1
3	12	1
\.


ALTER TABLE public.contador ENABLE TRIGGER ALL;

--
-- Data for Name: departamentos; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE public.departamentos DISABLE TRIGGER ALL;

COPY public.departamentos (id, nome, descricao, ativo, created_at, updated_at) FROM stdin;
4	Recepção de Ultrassonografia/Ecocardiografia	Grupo de atendimento da Recepção de Ultrassonografia/Ecocardiografia, ligada à Unidade de Diagnóstico por Imagem.	t	2026-08-14 23:24:12	\N
5	Recepção do Laboratório de Análises Clínicas	Grupo de atendimento da recepção de coleta de exames laboratoriais, da Unidade de Laboratório de Análises Clínicas.	t	2026-08-14 23:24:12	\N
1	Raíz	Grupo Raíz	t	2026-08-14 23:24:12	\N
2	HU-UFGD	Grupo raiz do HU-UFGD.	t	2026-08-14 23:24:12	\N
3	Setor de Apoio Diagnóstico	Grupo de atendimento das Unidades ligadas ao Setor de Apoio Diagnóstico.	t	2026-08-14 23:24:12	\N
6	Recepção de Radiografia/Tomografia	Grupo de atendimento da Recepção de Radiografia/Tomografia, ligada à Unidade de Diagnóstico por Imagem.	t	2026-08-14 23:24:12	\N
\.


ALTER TABLE public.departamentos ENABLE TRIGGER ALL;

--
-- Data for Name: historico_atendimentos; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE public.historico_atendimentos DISABLE TRIGGER ALL;

COPY public.historico_atendimentos (id, cliente_id, unidade_id, servico_id, prioridade_id, usuario_id, usuario_tri_id, atendimento_id, num_local, dt_age, dt_cheg, dt_cha, dt_ini, dt_fim, tempo_espera, tempo_permanencia, tempo_atendimento, tempo_deslocamento, status, resolucao, observacao, senha_sigla, senha_numero, local_id) FROM stdin;
\.


ALTER TABLE public.historico_atendimentos ENABLE TRIGGER ALL;

--
-- Data for Name: historico_atendimentos_codificados; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE public.historico_atendimentos_codificados DISABLE TRIGGER ALL;

COPY public.historico_atendimentos_codificados (servico_id, atendimento_id, valor_peso) FROM stdin;
\.


ALTER TABLE public.historico_atendimentos_codificados ENABLE TRIGGER ALL;

--
-- Data for Name: historico_atendimentos_metadata; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE public.historico_atendimentos_metadata DISABLE TRIGGER ALL;

COPY public.historico_atendimentos_metadata (namespace, name, atendimento_id, value) FROM stdin;
\.


ALTER TABLE public.historico_atendimentos_metadata ENABLE TRIGGER ALL;

--
-- Data for Name: locais; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE public.locais DISABLE TRIGGER ALL;

COPY public.locais (id, nome, created_at, updated_at) FROM stdin;
1	Guichê	2026-08-14 23:24:12	\N
2	Sala	2026-08-14 23:24:12	\N
3	Mesa	2026-08-14 23:24:12	\N
\.


ALTER TABLE public.locais ENABLE TRIGGER ALL;

--
-- Data for Name: perfis; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE public.perfis DISABLE TRIGGER ALL;

COPY public.perfis (id, nome, descricao, modulos, created_at, updated_at) FROM stdin;
2	Recepcionista	Cargo de funcionário(a) das Recepções.	\N	2026-08-14 23:24:12	\N
1	Administrador	Administrador geral do sistema	\N	2026-08-14 23:24:12	\N
3	Chefia	Chefia de setor.	\N	2026-08-14 23:24:12	\N
\.


ALTER TABLE public.perfis ENABLE TRIGGER ALL;

--
-- Data for Name: lotacoes; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE public.lotacoes DISABLE TRIGGER ALL;

COPY public.lotacoes (id, usuario_id, unidade_id, perfil_id) FROM stdin;
1	2	2	2
2	3	3	2
3	4	3	2
\.


ALTER TABLE public.lotacoes ENABLE TRIGGER ALL;

--
-- Data for Name: metadata; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE public.metadata DISABLE TRIGGER ALL;

COPY public.metadata (namespace, name, value) FROM stdin;
\.


ALTER TABLE public.metadata ENABLE TRIGGER ALL;

--
-- Data for Name: oauth2_client; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE public.oauth2_client DISABLE TRIGGER ALL;

COPY public.oauth2_client (identifier, name, secret, redirect_uris, grants, scopes, active, allow_plain_text_pkce) FROM stdin;
\.


ALTER TABLE public.oauth2_client ENABLE TRIGGER ALL;

--
-- Data for Name: oauth2_access_token; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE public.oauth2_access_token DISABLE TRIGGER ALL;

COPY public.oauth2_access_token (identifier, client, expiry, user_identifier, scopes, revoked) FROM stdin;
\.


ALTER TABLE public.oauth2_access_token ENABLE TRIGGER ALL;

--
-- Data for Name: oauth2_authorization_code; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE public.oauth2_authorization_code DISABLE TRIGGER ALL;

COPY public.oauth2_authorization_code (identifier, client, expiry, user_identifier, scopes, revoked) FROM stdin;
\.


ALTER TABLE public.oauth2_authorization_code ENABLE TRIGGER ALL;

--
-- Data for Name: oauth2_refresh_token; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE public.oauth2_refresh_token DISABLE TRIGGER ALL;

COPY public.oauth2_refresh_token (identifier, access_token, expiry, revoked) FROM stdin;
\.


ALTER TABLE public.oauth2_refresh_token ENABLE TRIGGER ALL;

--
-- Data for Name: paineis; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE public.paineis DISABLE TRIGGER ALL;

COPY public.paineis (id, nome, public_id, unidade_id) FROM stdin;
\.


ALTER TABLE public.paineis ENABLE TRIGGER ALL;

--
-- Data for Name: paineis_metadata; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE public.paineis_metadata DISABLE TRIGGER ALL;

COPY public.paineis_metadata (namespace, name, painel_id, value) FROM stdin;
\.


ALTER TABLE public.paineis_metadata ENABLE TRIGGER ALL;

--
-- Data for Name: painel_senha; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE public.painel_senha DISABLE TRIGGER ALL;

COPY public.painel_senha (id, servico_id, unidade_id, num_senha, sig_senha, msg_senha, local, num_local, peso, prioridade, nome_cliente, documento_cliente, cor_prioridade) FROM stdin;
\.


ALTER TABLE public.painel_senha ENABLE TRIGGER ALL;

--
-- Data for Name: painel_servicos; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE public.painel_servicos DISABLE TRIGGER ALL;

COPY public.painel_servicos (id, painel_id, servico_id) FROM stdin;
\.


ALTER TABLE public.painel_servicos ENABLE TRIGGER ALL;

--
-- Data for Name: servicos_metadata; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE public.servicos_metadata DISABLE TRIGGER ALL;

COPY public.servicos_metadata (namespace, name, servico_id, value) FROM stdin;
\.


ALTER TABLE public.servicos_metadata ENABLE TRIGGER ALL;

--
-- Data for Name: servicos_unidades; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE public.servicos_unidades DISABLE TRIGGER ALL;

COPY public.servicos_unidades (servico_id, unidade_id, local_id, departamento_id, sigla, ativo, peso, numero_inicial, numero_final, incremento, mensagem, tipo, maximo) FROM stdin;
1	3	1	\N	A	f	1	1	\N	1	\N	\N	\N
2	3	1	\N	A	f	1	1	\N	1	\N	\N	\N
4	3	1	\N	A	f	1	1	\N	1	\N	\N	\N
5	3	1	\N	A	f	1	1	\N	1	\N	\N	\N
6	3	1	\N	A	f	1	1	\N	1	\N	\N	\N
7	3	1	\N	A	f	1	1	\N	1	\N	\N	\N
8	3	1	\N	A	f	1	1	\N	1	\N	\N	\N
9	3	1	\N	A	f	1	1	\N	1	\N	\N	\N
10	3	1	\N	A	f	1	1	\N	1	\N	\N	\N
11	3	1	\N	A	f	1	1	\N	1	\N	\N	\N
12	3	1	\N	A	f	1	1	\N	1	\N	\N	\N
13	3	1	\N	A	f	1	1	\N	1	\N	\N	\N
14	3	1	\N	A	f	1	1	\N	1	\N	\N	\N
16	3	1	\N	A	f	1	1	\N	1	\N	\N	\N
17	3	1	\N	A	f	1	1	\N	1	\N	\N	\N
18	3	1	\N	A	f	1	1	\N	1	\N	\N	\N
19	3	1	\N	A	f	1	1	\N	1	\N	\N	\N
3	3	1	\N	C	t	1	1	\N	1	\N	\N	\N
15	3	1	\N	R	t	1	1	\N	1	\N	\N	\N
1	2	1	\N	A	f	1	1	\N	1	\N	\N	\N
2	2	1	\N	A	f	1	1	\N	1	\N	\N	\N
3	2	1	\N	A	f	1	1	\N	1	\N	\N	\N
4	2	1	\N	A	f	1	1	\N	1	\N	\N	\N
5	2	1	\N	A	f	1	1	\N	1	\N	\N	\N
6	2	1	\N	A	f	1	1	\N	1	\N	\N	\N
7	2	1	\N	A	f	1	1	\N	1	\N	\N	\N
8	2	1	\N	A	f	1	1	\N	1	\N	\N	\N
9	2	1	\N	A	f	1	1	\N	1	\N	\N	\N
10	2	1	\N	A	f	1	1	\N	1	\N	\N	\N
11	2	1	\N	A	f	1	1	\N	1	\N	\N	\N
12	2	1	\N	A	f	1	1	\N	1	\N	\N	\N
13	2	1	\N	A	f	1	1	\N	1	\N	\N	\N
14	2	1	\N	A	f	1	1	\N	1	\N	\N	\N
15	2	1	\N	A	f	1	1	\N	1	\N	\N	\N
16	2	1	\N	A	f	1	1	\N	1	\N	\N	\N
17	2	1	\N	A	f	1	1	\N	1	\N	\N	\N
18	2	1	\N	A	f	1	1	\N	1	\N	\N	\N
19	2	1	\N	A	f	1	1	\N	1	\N	\N	\N
\.


ALTER TABLE public.servicos_unidades ENABLE TRIGGER ALL;

--
-- Data for Name: servicos_usuarios; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE public.servicos_usuarios DISABLE TRIGGER ALL;

COPY public.servicos_usuarios (servico_id, unidade_id, usuario_id, peso) FROM stdin;
3	3	3	1
15	3	3	1
3	3	4	1
15	3	4	1
\.


ALTER TABLE public.servicos_usuarios ENABLE TRIGGER ALL;

--
-- Data for Name: unidades_metadata; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE public.unidades_metadata DISABLE TRIGGER ALL;

COPY public.unidades_metadata (namespace, name, unidade_id, value) FROM stdin;
\.


ALTER TABLE public.unidades_metadata ENABLE TRIGGER ALL;

--
-- Data for Name: usuarios_metadata; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE public.usuarios_metadata DISABLE TRIGGER ALL;

COPY public.usuarios_metadata (namespace, name, usuario_id, value) FROM stdin;
\.


ALTER TABLE public.usuarios_metadata ENABLE TRIGGER ALL;

--
-- Data for Name: webhooks; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE public.webhooks DISABLE TRIGGER ALL;

COPY public.webhooks (id, name, url, headers, events, enabled, created_at, updated_at) FROM stdin;
\.


ALTER TABLE public.webhooks ENABLE TRIGGER ALL;

--
-- Name: agendamentos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.agendamentos_id_seq', 1, false);


--
-- Name: atendimentos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.atendimentos_id_seq', 1, false);


--
-- Name: clientes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.clientes_id_seq', 1, false);


--
-- Name: departamentos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.departamentos_id_seq', 6, true);


--
-- Name: historico_atendimentos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.historico_atendimentos_id_seq', 1, false);


--
-- Name: locais_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.locais_id_seq', 3, true);


--
-- Name: lotacoes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.lotacoes_id_seq', 3, true);


--
-- Name: paineis_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.paineis_id_seq', 1, false);


--
-- Name: painel_senha_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.painel_senha_id_seq', 1, false);


--
-- Name: painel_servicos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.painel_servicos_id_seq', 1, false);


--
-- Name: perfis_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.perfis_id_seq', 3, true);


--
-- Name: prioridades_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.prioridades_id_seq', 6, true);


--
-- Name: servicos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.servicos_id_seq', 19, true);


--
-- Name: unidades_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.unidades_id_seq', 3, true);


--
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.usuarios_id_seq', 4, true);


--
-- Name: webhooks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.webhooks_id_seq', 1, false);


--
-- PostgreSQL database dump complete
--

\unrestrict It5y8cdm6lIfbkbCJ8OpfnwHD1h8kHQ4avQonNVnkHg4WWfZMEDGLlQxDSZb8e0

