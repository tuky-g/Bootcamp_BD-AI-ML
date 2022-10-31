### [back](./project.md)

# Datasources

## Uso de datos de los dispositivos móviles.

Esta fuente de datos, es una fuente de datos en tiempo real en formato JSON, las distintas antenas de nuestra red recolectaran la información de los dispositivos conectados y enviaran los mensajes con el siguiente schema:

| property   | description                     | data_type   |  example                                             |
|------------|---------------------------------|-------------|------------------------------------------------------|
| timestmap  | Marca de tiempo en segundos     | LONG        | `1600528288`                                         |
| id         | UUID del dispositivo movil      | STRING      | `"550e8400-e29b-41d4-a716-446655440000"`             |
| antenna_id | UUID de la antena               | STRING      | `"550e8400-e29b-41d4-a716-446655440000"`             |
| bytes      | Número de bytes transmitidos    | LONG        | `512`, `158871`                                      |
| app        | Aplicación utilizada            | STRING      | `"SKYPE"`, `"FACEBOOK"`, `"WHATSAPP"`, `"FACETIME"`  |


```json
{"timestmap": 1600528288, "id": "550e8400-e29b-41d4-a716-446655440000", "antenna_id": "550e8400-1234-1234-a716-446655440000", "app": "SKYPE", "bytes": 100}
{"timestmap": 1600528288, "id": "550e8400-e29b-41d4-a716-446655440000", "antenna_id": "550e8400-1234-1234-a716-446655440000", "app": "FACEBOOK", "bytes": 23411}
...
```

## Base de datos con información de los usuarios.

En concreto tendremos una tabla relacional con información sobre usuarios:

### Información de usuarios

| property   | description                            | data_type   |  example                                             |
|------------|----------------------------------------|-------------|------------------------------------------------------|
| id         | UUID del dispositivo movil             | TEXT        | `"550e8400-e29b-41d4-a716-446655440000"`             |
| name       | Nombre del usuario                     | TEXT        | `"Andres"`                                           |
| email      | Número de bytes transmitidos           | TEXT        | `andres@gmail.com`                                   |
| quota      | Número de bytes por hora permitidos    | BIGINT      | `10000000`                                           |

La tabla tendrá el siguiente schema y se puede realizar una carga inicial de datos con los siguientes comandos:

```sql
CREATE TABLE IF NOT EXISTS user_metadata(id TEXT, name TEXT, email TEXT, quota BIGINT)
```

```sql
INSERT INTO user_metadata (id, name, email, quota) VALUES ('00000000-0000-0000-0000-000000000001', 'andres', 'andres@gmail.com', 200000)
INSERT INTO user_metadata (id, name, email, quota) VALUES ('00000000-0000-0000-0000-000000000002', 'paco', 'paco@gmail.com', 300000)
INSERT INTO user_metadata (id, name, email, quota) VALUES ('00000000-0000-0000-0000-000000000003', 'juan', 'juan@gmail.com', 100000)
INSERT INTO user_metadata (id, name, email, quota) VALUES ('00000000-0000-0000-0000-000000000004', 'fede', 'fede@gmail.com', 5000)
INSERT INTO user_metadata (id, name, email, quota) VALUES ('00000000-0000-0000-0000-000000000005', 'gorka', 'gorka@gmail.com', 200000)
INSERT INTO user_metadata (id, name, email, quota) VALUES ('00000000-0000-0000-0000-000000000006', 'luis', 'luis@gmail.com', 200000)
INSERT INTO user_metadata (id, name, email, quota) VALUES ('00000000-0000-0000-0000-000000000007', 'eric', 'eric@gmail.com', 300000)
INSERT INTO user_metadata (id, name, email, quota) VALUES ('00000000-0000-0000-0000-000000000008', 'carlos', 'carlos@gmail.com', 100000)
INSERT INTO user_metadata (id, name, email, quota) VALUES ('00000000-0000-0000-0000-000000000009', 'david', 'david@gmail.com', 300000)
INSERT INTO user_metadata (id, name, email, quota) VALUES ('00000000-0000-0000-0000-000000000010', 'juanchu', 'juanchu@gmail.com', 300000)
INSERT INTO user_metadata (id, name, email, quota) VALUES ('00000000-0000-0000-0000-000000000011', 'charo', 'charo@gmail.com', 300000)
INSERT INTO user_metadata (id, name, email, quota) VALUES ('00000000-0000-0000-0000-000000000012', 'delicidas', 'delicidas@gmail.com', 1000000)
INSERT INTO user_metadata (id, name, email, quota) VALUES ('00000000-0000-0000-0000-000000000013', 'milagros', 'milagros@gmail.com', 200000)
INSERT INTO user_metadata (id, name, email, quota) VALUES ('00000000-0000-0000-0000-000000000014', 'antonio', 'antonio@gmail.com', 1000000)
INSERT INTO user_metadata (id, name, email, quota) VALUES ('00000000-0000-0000-0000-000000000015', 'sergio', 'sergio@gmail.com', 1000000)
INSERT INTO user_metadata (id, name, email, quota) VALUES ('00000000-0000-0000-0000-000000000016', 'maria', 'maria@gmail.com', 1000000)
INSERT INTO user_metadata (id, name, email, quota) VALUES ('00000000-0000-0000-0000-000000000017', 'cristina', 'cristina@gmail.com', 300000)
INSERT INTO user_metadata (id, name, email, quota) VALUES ('00000000-0000-0000-0000-000000000018', 'lucia', 'lucia@gmail.com', 300000)
INSERT INTO user_metadata (id, name, email, quota) VALUES ('00000000-0000-0000-0000-000000000019', 'carlota', 'carlota@gmail.com', 200000)
INSERT INTO user_metadata (id, name, email, quota) VALUES ('00000000-0000-0000-0000-000000000020', 'emilio', 'emilio@gmail.com', 200000)
```

### [back](./project.md)
