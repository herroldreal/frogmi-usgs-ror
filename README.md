# Seismic Data App

La aplicación Seismic Data App es una herramienta para obtener y visualizar datos de sismología mundial proporcionados por la USGS (United States Geological Survey).

## Características

- Consulta y visualización de datos de sismología mundial.
- Capacidad para agregar comentarios a los eventos sísmicos.
- Interfaz de usuario intuitiva y fácil de usar.

## Requisitos

Asegúrate de tener instaladas las siguientes herramientas en tu sistema:

- **Ruby**: version 3.3.0
- **Rails**: versión 7.1.3.2
- **Node.js**: versión v20.11.0
- **npm**: versión 10.2.4

## Instalación

1. **Clonar el Repositorio**: Clona este repositorio en tu máquina local utilizando el siguiente comando:

   ```bash
    git clone <url-del-repositorio>
   ```   
2. **Instalar Dependencias Ruby**: Utiliza Bundler para instalar las dependencias de Ruby:

    ```
    bundle install
    ```

3. **Instalar Dependencias Node.js**: Utiliza npm para instalar las dependencias de Node.js:

    ```
    npm install
    ```
4. **Configurar la Base de Datos**: Ejecuta las siguientes tareas de Rails para configurar la base de datos:

    ```
    rails db:create
    rails db:migrate
   ```

## Uso

Para iniciar la aplicación en un entorno de desarrollo, ejecuta el siguiente comando:
```
rails server
```

Esto iniciará el servidor de desarrollo en http://localhost:3000.

## Tareas (Rake)
### Fetch Data

Para obtener y persistir los datos de sismología mundial desde la USGS API, puedes ejecutar la tarea Rake sismic_data:fetch:

```
rails seismic_data:fetch
```
