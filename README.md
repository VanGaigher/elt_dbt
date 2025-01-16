### README

# Projeto: ETL com Python e DBT-core- Criação de Listagem de Trabalhos Remotos

Este projeto é um pipeline de dados que integra a coleta de vagas remotas de trabalho da API Jobicy, realiza transformações de dados usando **dbt** e armazena os resultados em um banco de dados Snowflake. Ele é dividido em duas etapas principais: coleta e transformação.

---

## Estrutura do Projeto

### 1. Coleta de Dados

A coleta dos dados é realizada pela classe `JobicyAPI`, que utiliza a API da Jobicy para buscar listagens de trabalhos remotos relacionados à indústria de interesse.

#### Funcionalidades

- **Extração de Dados:**  
  A classe conecta-se à API Jobicy e armazena os dados em um atributo interno.  
- **Processamento em DataFrame:**  
  Os dados extraídos são convertidos para um DataFrame do pandas, facilitando o processamento e armazenamento.

#### Configurações

A coleta de dados é personalizada pelos seguintes parâmetros:
- `base_url`: URL base da API.
- `industry`: Indústria de interesse (e.g., `data-science`).
- `count`: Número de resultados a serem coletados.

### 2. Armazenamento no Snowflake

A classe `Snowflake` gerencia a conexão e o envio de dados para o banco de dados Snowflake.

#### Funcionalidades

- **Conexão com o Snowflake:**  
  Gerenciada com a biblioteca `sqlalchemy` usando credenciais obtidas de variáveis de ambiente configuradas no `.env`.
- **Inserção de Dados:**  
  Dados são carregados no Snowflake e substituem os registros existentes na tabela definida.

---

### 3. Transformação de Dados com dbt

O dbt processa os dados armazenados no Snowflake, realizando renomeações, conversões de tipos e cálculos adicionais para análise.

#### Etapas

- **Extração (`source`)**:  
  Os dados brutos são importados da tabela `listagem_trabalhos_remotos`.

- **Renomeação e Conversões (`renamed`)**:  
  Renomeia as colunas para um formato mais amigável e converte os campos de salário para tipo `float`.

- **Cálculos Finais (`final`)**:  
  Adiciona cálculos como o salário mensal mínimo e máximo, além de filtrar registros inválidos.

---

## Configuração do Ambiente

Antes de executar o projeto, siga os passos abaixo:

### 1. Configurar Variáveis de Ambiente

Crie um arquivo `.env` na raiz do projeto e adicione as variáveis:

```env
# Credenciais do Snowflake
ACCOUNT=seu_conta_snowflake
USER=seu_usuario
PASSWORD=sua_senha
DATABASE=nome_do_banco
SCHEMA=nome_do_esquema
WAREHOUSE=nome_do_warehouse
```

### 2. Instalar Dependências

Instale as bibliotecas necessárias:

```bash
pip install requests pandas sqlalchemy snowflake-sqlalchemy python-dotenv
```

Além disso, configure o dbt e instale as dependências usando:

```bash
dbt deps
```

### 3. Configuração do Snowflake

Certifique-se de que o Snowflake esteja configurado para aceitar conexões do dbt e da aplicação Python.

---

## Uso

### 1. Coleta e Armazenamento

Execute o script principal para coletar e armazenar os dados no Snowflake:

```bash
python script.py
```

- O script coleta dados de vagas remotas, transforma-os em um DataFrame e os armazena na tabela `listagem_trabalhos_remotos` no Snowflake.

### 2. Transformação com dbt

Execute o comando dbt para processar os dados:

```bash
dbt run
```

Isso gerará uma tabela processada com as transformações aplicadas, como cálculos de salários mensais.

---

## Estrutura de Dados

### Tabela Bruta (`listagem_trabalhos_remotos`)

| Coluna             | Tipo      | Descrição                     |
|--------------------|-----------|-------------------------------|
| ID                | INT       | Identificador único da vaga   |
| URL               | STRING    | URL da vaga                   |
| jobSlug           | STRING    | Slug da vaga                  |
| jobTitle          | STRING    | Título da vaga                |
| companyName       | STRING    | Nome da empresa               |
| companyLogo       | STRING    | URL do logo da empresa        |
| jobIndustry       | STRING    | Indústria da vaga             |
| jobType           | STRING    | Tipo de trabalho              |
| jobGeo            | STRING    | Localização                   |
| jobLevel          | STRING    | Nível de senioridade          |
| jobExcerpt        | STRING    | Resumo da vaga                |
| jobDescription    | STRING    | Descrição da vaga             |
| pubDate           | STRING    | Data de publicação            |
| annualSalaryMin   | FLOAT     | Salário anual mínimo          |
| annualSalaryMax   | FLOAT     | Salário anual máximo          |
| salaryCurrency    | STRING    | Moeda do salário              |

### Tabela Final (`final`)

| Coluna                 | Tipo      | Descrição                     |
|------------------------|-----------|-------------------------------|
| titulo_vaga           | STRING    | Título da vaga                |
| nome_empresa          | STRING    | Nome da empresa               |
| tipo_trabalho         | STRING    | Tipo de trabalho              |
| localizacao           | STRING    | Localização                   |
| senioridade           | STRING    | Nível de senioridade          |
| minimo_salario_mensal | FLOAT     | Salário mensal mínimo         |
| minimo_salario_anual  | FLOAT     | Salário anual mínimo          |
| maximo_salario_mensal | FLOAT     | Salário mensal máximo         |
| max_salario_anual     | FLOAT     | Salário anual máximo          |
| moeda                 | STRING    | Moeda do salário              |

---

## Observações

- Certifique-se de que as credenciais e a configuração do Snowflake estão corretas.
- Ajuste o número de vagas (`count`) e a indústria (`industry`) conforme necessário.
- O dbt depende de um modelo `source` configurado para a tabela bruta.

---

## Licença

Este projeto está sob a licença MIT.


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
