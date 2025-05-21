# OdontoPrev-DB

API RESTful para gerenciamento de pacientes odontológicos, desenvolvida em Node.js, Express e MongoDB.

## Funcionalidades

- **CRUD de Pacientes:** Crie, consulte, atualize e exclua pacientes.
- **Seed de Pacientes:** Gere pacientes fictícios para testes.
- **Exportação de Dados:** Exporte todos os pacientes para um arquivo JSON.
- **Documentação e Testes:** Coleção Postman inclusa para facilitar testes.

## Instalação

1. **Clone o repositório:**
   ```sh
   git clone https://github.com/seu-usuario/OdontoPrev-DB.git
   cd OdontoPrev-DB
   ```

2. **Instale as dependências:**
    ```sh
    npm install
    ```

3. **Configure o banco de dados:**

- O projeto já está configurado para usar MongoDB Atlas.
- Se necessário, edite a string de conexão em `src/util/db.ts`.

4. **Inicie o servidor:**
    ```sh
    npm start
    ```
    > O servidor estará disponível em http://localhost:3000.

## Rotas Principais

| Método | Rota                  | Descrição                     |
|--------|-----------------------|-------------------------------|
| GET    | `/api/patient`        | Lista todos os pacientes      |
| GET    | `/api/patient/:id`    | Busca paciente por ID         |
| POST   | `/api/patient`        | Cria um novo paciente         |
| PUT    | `/api/patient/:id`    | Atualiza um paciente          |
| DELETE | `/api/patient/:id`    | Remove um paciente            |
| GET    | `/api/export-dataset` | Exporta pacientes para JSON   |
| GET    | `/api/seed-patient`   | Gera 10 pacientes fake        |

## Exemplo de JSON para criar paciente

```json
{
  "name": "João da Silva",
  "birthday": "1990-05-21T00:00:00.000Z",
  "gender": "MALE",
  "riskStatus": "LOW",
  "consultationFrequency": 2,
  "associatedClaims": "Nenhuma"
}
```

## Testes com Postman
- Utilize a coleção Odontoprev - Banco.postman_collection.json para testar todas as rotas.
- Importe a coleção no Postman e ajuste a variável base_url se necessário.