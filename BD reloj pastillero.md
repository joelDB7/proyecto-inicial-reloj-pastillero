actua como administrador dre base de datos:proyecto reloj pastillero que entidades se necesitan para su gestion
Aquí tienes el diagrama de red (ERD) completo del proyecto reloj pastillero con las **13 entidades** y sus relaciones.
<img width="1023" height="651" alt="image" src="https://github.com/user-attachments/assets/a0942ffb-ee1a-45de-b231-9def6e836292" />

**Resumen de grupos y cardinalidades clave:**

`USUARIO` es el núcleo del sistema: se conecta con perfil médico, prescripciones, dispositivos, cuidadores y registros de toma.

`PRESCRIPCION` actúa como puente entre el médico, el medicamento y los horarios de toma.

`HORARIO_TOMA` dispara las alarmas y genera los registros de cumplimiento.

`DISPOSITIVO` contiene los compartimentos físicos, cada uno con su inventario y el medicamento asignado.

`CUIDADOR` recibe notificaciones cuando el usuario no toma su medicamento a tiempo.

---

**Convenciones usadas:**
| Símbolo | Significado |
|---|---|
| `||--o{` | Uno a muchos (obligatorio–opcional) |
| `PK` | Llave primaria |
| `FK` | Llave foránea |

##fin 
las entidades con sus atributos y tipos de forma en tabla para cada una de las entidades
## tablas
<img width="755" height="352" alt="image" src="https://github.com/user-attachments/assets/17fe5685-2c65-405a-b48c-70f4071d6c9a" />
<img width="744" height="290" alt="image" src="https://github.com/user-attachments/assets/f7943ba4-7844-426e-9a52-850f1a52c1e4" />
<img width="738" height="592" alt="image" src="https://github.com/user-attachments/assets/8b775861-9048-4968-86bc-8b949d7d80df" />
<img width="747" height="655" alt="image" src="https://github.com/user-attachments/assets/e4cd70da-8ce7-449d-9ba0-9da723da2b41" />
<img width="768" height="613" alt="image" src="https://github.com/user-attachments/assets/8c828cc7-56de-4481-b83a-855a3a2c0325" />
<img width="782" height="579" alt="image" src="https://github.com/user-attachments/assets/af2af57d-6861-443b-95fb-ad50573a2a51" />
<img width="760" height="585" alt="image" src="https://github.com/user-attachments/assets/e17fde88-bad8-4f1d-8a24-ce1715e91f4c" />
<img width="763" height="330" alt="image" src="https://github.com/user-attachments/assets/719715e5-5501-44c7-9e04-0f94ade7ebf6" />
##fin

