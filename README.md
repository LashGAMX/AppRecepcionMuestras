# RECEPCIÓN DE MUESTRAS

Aplicación móvil desarrollada en Flutter para recepción de muestras

## CONFIGURACIÓN DEL PROYECTO

La configuración del proyecto no debería ser muy compleja. Se usaron ciertas librerias

- Shared Preferences: Para manejar variables de sesión

## ESTRUCTURA DEL PROYECTO

Las interfaces y funcionalidad del proyecto se encuentra prácticamente en la carpeta de lib. Esta
carpeta tiene tres subcarpetas llamadas "api", "models" y "pages".

Empezando por pages, ahí se encuentran las interfaces de la aplicación. Al inicio de cada archivo 
hay ciertas variables declaradas con la posibilidad de ser nulas. Estas irán cambiando de valor 
dependiendo de las funciones que vaya ejecutando el usuario y son los datos que van cambiando en la
vista del usuario. Después se encuentran funciones que generalmente son las que van a cambiar el
valor de las variables y finalmente se encuentran los Widgets que son la parte visual de la página,
es ahí donde se invocan las funciones para cambiar los valores de las variables.

En api se encuentra un archivo cuya intención es la de tener todas las funciones HTTP, es decir que 
se comunican con el servidor en Laravel. Primero se hace la petición, y después se verifica que el 
servidor haya regresado algunos de los códigos de estado que aparecen en las funciones, eso para 
contemplar los diferentes errores que puede retornar el servidor, en lugar de que solo sea en caso 
de éxito. Si hay éxito en la petición se regresan los datos que mandó el servidor.

Después están los modelos. Cuando se hace una petición HTTP en flutter el servidor regresa datos en
JSON, la mejor opción para visualizar los datos que te regresa el servidor, es creando un objeto de 
Flutter que reciba los valores que devuelve el servidor en sus variables. Para esto se crearon 
diferentes modelos con la intención de recibir los valores. Los modelos se usan en las funciones
de API cuando el servidor regresa los datos, se crea un objeto de su modelo correspondiente,
guardando los valores en sus variables y dicho modelo es el que se regresa en la función. Así
cuando se regresa este objeto al invocarlo en las páginas a través de una función, los valores de
sus variables se les asigna a las de la página.