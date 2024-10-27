# 🎬 Moviee Catalog API

API RESTful para o gerenciamento de catálogo de filmes, com funcionalidades de importação de filmes via CSV e exibição dos filmes cadastrados com filtros opcionais.

## 📋 Funcionalidades

### 1. Importação de Filmes a partir de Arquivo CSV
- **Rota**: `POST /movies/import`
- **Descrição**: Importa filmes do arquivo \`netflix_titles.csv\` para o banco de dados, assegurando que não haja duplicidades nos registros.
- **Parâmetros**: Arquivo CSV com informações de filmes no mesmo padrão do arquivo `netflix_titles.csv`.

#### Exemplo de Requisição com cURL
```bash
curl -X POST http://localhost:3000/movies/import -F "file=@path/to/netflix_titles.csv"
```

---

### 2. Retorno dos Filmes Cadastrados
- **Rota**: `GET /movies`
- **Descrição**: Lista todos os filmes cadastrados no banco de dados, com suporte a filtros opcionais (ex.: ano, gênero, país).
  
#### Exemplo de Requisição com cURL
```bash
curl -X GET "http://localhost:3000/movies?year=2020&genre=Drama&country=United States"
```

#### Exemplo de Resposta
```json
[
    {
        "id": "840c7cfc-cd1f-4094-9651-688457d97fa4",
        "title": "13 Reasons Why",
        "genre": "TV Show",
        "year": "2020",
        "country": "United States",
        "published_at": "2020-05-07",
        "description": "A classmate receives a series of tapes that unravel the mystery of her tragic choice."
    }
]
```
---

## 🚀 Tecnologias Utilizadas
- **Linguagem**: Ruby 3.0.0
- **Framework**: Rails 6.0.6'
- **Banco de Dados**: Implementado utilizando banco não relacional Mongo DB

---

