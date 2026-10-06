# Zomato AI Data Engineering (Paraphrased README)

This project is an end-to-end batch data pipeline, built by following a [YouTube tutorial](https://youtu.be/kYwaNMQ3XT8?si=Ge8ilVxkmGQS6iIg). It starts with raw Zomato-style food delivery CSVs (think Uber Eats) and ends with AI-driven analytics.

**Flow:** Food delivery dataset → Amazon S3 → Snowflake → dbt → Airflow → OpenAI

Data is first stored in an S3 data lake, then pulled into Snowflake through a storage integration. From there, dbt reshapes it across three medallion layers: raw Bronze tables loaded with `COPY INTO`, cleaned Silver staging views, and finished Gold marts holding dimensions, incremental fact tables, and aggregates. A single daily Airflow DAG runs the whole process. An OpenAI-powered layer sits on top of the warehouse and does three things: it converts free-text reviews into structured columns, lets you chat with reviews through RAG, and translates plain-English questions into SQL. Streamlit hosts the dashboards and AI apps.

The Zomato dataset can be downloaded from this [Google Drive folder](https://drive.google.com/drive/folders/1FEnGWMHhHzzTUCZOw1-YnH2v3DMuM-rs?usp=sharing).

## Architecture Overview

| Layer | Location | Contents |
|---|---|---|
| **Source** | Local `data/` folder | Four real dimension CSVs (restaurants, users, food, menu) plus three synthetic fact files: 10M orders, about 23M order items, and 300K free-text reviews |
| **Lake** | Amazon S3 | A single bucket with one `raw/<table>/` folder per CSV |
| **Bronze** | Snowflake `ZOMATO.RAW` | Data loaded from S3 via `COPY INTO`, using a keyless storage integration |
| **Silver** | Snowflake `ZOMATO.STAGING` | dbt views that clean, type, and rename each source |
| **Gold** | Snowflake `ZOMATO.MARTS` | Dimensions, incremental facts (via MERGE), business marts |
| **AI** | Snowflake `ZOMATO.AI` | Reviews enriched by an LLM (sentiment and topic), RAG chat, and text-to-SQL |
| **Orchestration** | Airflow (in Docker) | One daily DAG: load, transform, enrich, then build the AI mart |

## How to Run It

### 1. Snowflake and AWS setup

Create the Snowflake objects: warehouse `ZOMATO_WH`, database `ZOMATO`, schemas `RAW`, `STAGING`, `MARTS`, and `AI`, and the role `DBT_ROLE`. Also set up the S3 storage integration. To do this, run scripts `snowflake/01` through `05` in Snowsight. The AWS-side configuration is in `aws/iam/`.

### 2. dbt

```bash
cd zomato
export SNOWFLAKE_ACCOUNT=... SNOWFLAKE_USER=... SNOWFLAKE_PASSWORD=...
dbt debug && dbt build --exclude tag:ai
```

### 3. Airflow

```bash
cd airflow
cp example.env .env          # fill in SNOWFLAKE_*, OPENAI_API_KEY, SAMPLE_N
docker compose build && docker compose up -d
```

Then open http://localhost:8080, un-pause the `zomato_batch` DAG, and trigger it.

### 4. AI apps

```bash
export OPENAI_API_KEY=sk-...
python ai/enrich_reviews.py
streamlit run ai/rag_chat.py      # chat with reviews
streamlit run ai/text_to_sql.py   # chat with the warehouse
```