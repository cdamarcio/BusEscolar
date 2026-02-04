
# BusEscolar

O **BusEscolar** é uma solução tecnológica robusta desenvolvida para o **Transporte Escolar**. O sistema visa modernizar a logística escolar, garantindo a segurança dos alunos da rede pública e a transparência na gestão de recursos municipais através do monitoramento em tempo real.



## Visão Geral

O projeto foi concebido para resolver desafios críticos na gestão pública:

1. **Segurança Infantil:** Pais acompanham o trajeto e recebem confirmação de embarque.
2. **Otimização de Custos:** Algoritmos de rota reduzem a quilometragem ociosa e o consumo de combustível através de bases de mapas abertas e gratuitas.
3. **Auditoria Governamental:** Dados precisos para prestação de contas junto ao FNDE/PNATE.


## Principais Funcionalidades

### Módulo Motorista (Operacional)

* **Check-in de Segurança:** Verificação obrigatória de itens de manutenção (pneus, cintos, freios) conforme normas de segurança veicular.
* **Rota Dinâmica (OSM):** Navegação baseada em OpenStreetMap que recalcula o trajeto automaticamente caso alunos notifiquem ausência.
* **Chamada Digital:** Registro biométrico ou manual de embarque e desembarque.
* **Protocolo de Varredura:** Alerta sonoro ao final do turno para garantir que o veículo esteja vazio.

### Módulo Pais/Responsáveis

* **Rastreamento Live:** Localização exata do veículo escolar sobre a cartografia do OpenStreetMap.
* **Notificações Push:** Alertas de proximidade (ex: "Ônibus a 2 minutos") e confirmação de chegada na unidade escolar.
* **Gestão de Ausências:** Canal direto para informar faltas, evitando paradas desnecessárias.

### Painel Administrativo (Gestão SME)

* **Monitoramento de Frota:** Controle centralizado de todas as rotas ativas em tempo real.
* **Relatórios Gerenciais:** Dashboards com indicadores de desempenho (KPIs), KM rodado e horas trabalhadas.
* **Cerca Eletrônica (Geofencing):** Notificações automáticas via PostGIS se um veículo sair da rota pré-definida.

## Arquitetura do Sistema

O sistema utiliza uma estrutura de microsserviços para alta disponibilidade:

* **Mobile:** Flutter com `flutter_map` (Integração nativa com OpenStreetMap).
* **Backend:** Node.js com NestJS (Arquitetura escalável).
* **Servidor de Rotas:** **OSRM (Open Source Routing Machine)** para cálculo de trajetos sem custos de API.
* **Banco de Dados:** PostgreSQL com extensão **PostGIS** para inteligência geográfica.
* **Infraestrutura:** Docker Containers hospedados em ambiente Cloud (AWS/Azure).

## Tecnologias Utilizadas

* **Maps:** OpenStreetMap (OSM) / Leaflet / OSRM.
* **Real-time Data:** WebSockets para atualização de posição em milissegundos.
* **Cloud Messaging:** Firebase (FCM) para notificações em tempo real.
* **Database:** PostGIS para processamento de cercas eletrônicas.

## Segurança e Conformidade (LGPD)

O projeto segue rigorosos padrões de proteção de dados:

* **Criptografia:** Dados de menores protegidos por criptografia AES-256.
* **Autenticação:** Integração com sistema de login único governamental ou OAuth2.
* **Privacidade:** O histórico de localização é anonimizado após o período letivo para fins estatísticos e auditoria.

## Licença


Este software é de propriedade da KM PROJETOS. O uso ou reprodução sem autorização do desenvolvedor Márcio Rodrigues de Oliveira é estritamente proibida.



