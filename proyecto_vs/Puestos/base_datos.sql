DROP DATABASE IF EXISTS puestos;
CREATE DATABASE puestos CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE puestos;

CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    cargo VARCHAR(100),
    area VARCHAR(100) NOT NULL,
    dia_casa VARCHAR(50) NOT NULL,
    horario VARCHAR(50) NOT NULL,
    foto VARCHAR(255),
    estado BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE puesto (
    id_puesto INT AUTO_INCREMENT PRIMARY KEY,
    codigo_puesto VARCHAR(10) NOT NULL UNIQUE,
    numero_puesto VARCHAR(20),
    ubicacion VARCHAR(100),
    id_usuario INT,
    reservable BOOLEAN DEFAULT TRUE,
    estado BOOLEAN DEFAULT TRUE,
    observacion VARCHAR(255),
    motivo VARCHAR(255),
    CONSTRAINT fk_puesto_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE reserva (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_puesto INT NOT NULL,
    fecha DATE NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'reservada',
    clave_reserva VARCHAR(255) NOT NULL DEFAULT '',
    CONSTRAINT fk_reserva_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    CONSTRAINT fk_reserva_puesto FOREIGN KEY (id_puesto) REFERENCES puesto(id_puesto),
    UNIQUE KEY uq_puesto_fecha (id_puesto, fecha),
    UNIQUE KEY uq_usuario_fecha (id_usuario, fecha)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE reserva ADD COLUMN IF NOT EXISTS clave_reserva VARCHAR(255) NOT NULL DEFAULT '';

INSERT INTO usuario (nombre, cargo, area, dia_casa, horario, foto) VALUES
('Jesus David Rivera', NULL, 'Inteligencia Artificial', 'No tiene', '8:00 AM - 5:00 PM', 'iconos/Inteligencia artificial/jesus.webp'),
('Nicolas Zapata', NULL, 'Inteligencia Artificial', 'Miercoles', '8:00 AM - 5:00 PM', 'iconos/Inteligencia artificial/nicolas.webp'),
('Anderson Alvarez', NULL, 'Inteligencia Artificial', 'No tiene', '8:00 AM - 5:00 PM', 'iconos/Inteligencia artificial/andersonalvarez.webp'),
('Luis Alejandro Torres', NULL, 'Inteligencia Artificial', 'Jueves', '8:00 AM - 5:00 PM', 'iconos/Inteligencia artificial/alejandro.webp'),
('Natalia Perez', NULL, 'Inteligencia Artificial', 'Miercoles', '8:00 AM - 5:00 PM', 'iconos/Inteligencia artificial/natalia.jpg'),
('Segrera', NULL, 'Inteligencia Artificial', 'Varía', '8:00 AM - 5:00 PM', 'iconos/Inteligencia artificial/segrera.webp'),

('Carolina Perez', NULL, 'Transversal', 'Jueves', '8:00 AM - 5:00 PM', 'iconos/transversales/carolina.webp'),
('Laura Ramirez', NULL, 'Transversal', 'No tiene', '8:00 AM - 5:00 PM', 'iconos/transversales/ramirez.webp'),
('Kelly Muñoz', NULL, 'Transversal', 'No tiene', '8:00 AM - 5:00 PM', 'iconos/transversales/kelly.webp'),
('Jennifer Sotelo Perez', NULL, 'Transversal', 'No tiene', '8:00 AM - 5:00 PM', 'iconos/transversales/jennnifer.webp'),
('Ronald Jimenez Pelaez', NULL, 'Gestion de Software', 'Martes', '8:00 AM - 5:00 PM', 'iconos/gestion de software/ronald.webp'),

('Joan Sebastian Vivas Caicedo', NULL, 'Bi Datas', 'Viernes', '8:00 AM - 5:00 PM', 'iconos/Bi datas/caicedo.jpg'),
('Christian Andrés Ramirez', NULL, 'Bi Datas', 'Jueves', '8:00 AM - 5:00 PM', 'iconos/Bi datas/christian.jpg'),
('Duvan Esteban Jaramillo', NULL, 'Bi Datas', 'Lunes', '8:00 AM - 5:00 PM', 'iconos/Bi datas/jaramillo.webp'),
('Jose David Cartagena', NULL, 'Bi Datas', 'Martes', '8:00 AM - 5:00 PM', 'iconos/Bi datas/martinez.webp'),
('Jhon Eferson Castaño', NULL, 'Bi Datas', 'Jueves', '8:00 AM - 5:00 PM', 'iconos/Bi datas/efer.webp'),
('Elkin Amador', NULL, 'Bi Datas', 'Viernes', '8:00 AM - 5:00 PM', 'iconos/Bi datas/amador.jpg'),

('Anderson Yepes', NULL, 'Front', 'Lunes', '7:30 AM - 4:30 PM', 'iconos/front/anderson.webp'),
('David Velasquez', NULL, 'Gestion de Software', 'Viernes', '8:00 AM - 5:00 PM', 'iconos/gestion de software/david.webp'),
('Juan Manuel Lopez', NULL, 'Gestion de Software', 'Lunes', '8:00 AM - 5:00 PM', 'iconos/gestion de software/manuel.webp'),
('Karol Navia', NULL, 'Gestion de Software', 'Miercoles', '8:00 AM - 5:00 PM', 'iconos/gestion de software/navia.webp'),
('Andres Ramirez', NULL, 'Gestion de Software', 'Jueves', '8:00 AM - 5:00 PM', 'iconos/gestion de software/andres.webp'),
('Edwar', NULL, 'Gestion de Software', 'Miercoles', '8:00 AM - 5:00 PM', 'iconos/gestion de software/edwar.webp'),
('Sebastian Pertuz', NULL, 'Gestion de Software', 'Martes', '8:00 AM - 5:00 PM', 'iconos/gestion de software/pertuz.jpg'),
('Luis Zuluaga', NULL, 'Gestion de Software', 'Viernes', '8:00 AM - 5:00 PM', 'iconos/gestion de software/luis.webp'),

('Theodoro Dikuyama', NULL, 'Front', 'Martes', '8:00 AM - 5:00 PM', 'iconos/front/theodoro.webp'),
('Sebastian Giraldo', NULL, 'Front', 'Viernes', '8:00 AM - 5:00 PM', 'iconos/front/giraldo.webp'),
('Yuly Gomez', NULL, 'Front', 'Viernes', '8:00 AM - 5:00 PM', 'iconos/front/yuly.webp'),
('Karen Herrera', NULL, 'Front', 'Viernes', '8:00 AM - 5:00 PM', 'iconos/front/karen.webp'),
('Jose Solorzano', NULL, 'SiteBuilder', 'Viernes', '8:00 AM - 5:00 PM', 'iconos/SiteBuilder/solorzano.webp'),
('Jonathan Peña', NULL, 'SiteBuilder', 'Martes', '8:00 AM - 5:00 PM', 'iconos/SiteBuilder/jonathan.webp'),
('Elkin Murilllo', NULL, 'SiteBuilder', 'Jueves', '8:00 AM - 5:00 PM', 'iconos/SiteBuilder/elkin.webp'),
('Santiago Peña', NULL, 'Diseño', 'Miercoles', '8:00 AM - 5:00 PM', 'iconos/diseño/santiago.png'),
('Jonathan Uribe', NULL, 'Diseño', 'Lunes', '8:00 AM - 5:00 PM', 'iconos/diseño/uribe.webp'),
('Esteban Lasso', NULL, 'Diseño', 'Jueves', '8:00 AM - 5:00 PM', 'iconos/diseño/lasso.webp'),
('Jose Martinez', NULL, 'Diseño', 'Lunes', '8:00 AM - 5:00 PM', 'iconos/diseño/josemartinez.webp'),
('Laura Rojas', NULL, 'Diseño', 'Miercoles', '8:00 AM - 5:00 PM', 'iconos/diseño/laura.webp'),
('Natalia Urrego', NULL, 'Diseño', 'Viernes', '8:00 AM - 5:00 PM', 'iconos/diseño/natalia.webp'),

('Yulian', NULL, 'Incidentes', 'Aleatorio', '8:00 AM - 5:00 PM', 'iconos/incidentes/yulian.webp'),
('Laura Molina Estrada', NULL, 'Incidentes', 'Miercoles', '8:00 AM - 5:00 PM', 'iconos/incidentes/lauram.webp'),
('Jeison Martinez', NULL, 'Front', 'Jueves', '8:00 AM - 5:00 PM', 'iconos/front/jeison.webp'),
('Gabriel Carmona', NULL, 'Incidentes', 'Aleatorio', '8:00 AM - 5:00 PM', 'iconos/incidentes/gabriel.webp'),
('Juan Jose Marin', NULL, 'Front', 'Miercoles', '8:00 AM - 5:00 PM', 'iconos/front/marin.webp'),
('Diego Alejandro Bedoya', NULL, 'Integraciones', 'Viernes', '8:00 AM - 5:00 PM', 'iconos/integraciones/diego.webp'),
('Carlos Damian Cano', NULL, 'Front', 'Viernes', '8:00 AM - 5:00 PM', 'iconos/front/damian.webp'),
('Juan Esteban Lopez', NULL, 'Integraciones', 'Jueves', '8:00 AM - 5:00 PM', 'iconos/integraciones/esteban.webp'),
('Davison Arley Valencia', NULL, 'Integraciones', 'Miercoles', '8:00 AM - 5:00 PM', 'iconos/integraciones/davison.webp'),
('Julian Bedoya', NULL, 'Integraciones', 'Martes', '8:00 AM - 5:00 PM', 'iconos/integraciones/julian.webp'),
('David Alvarez', NULL, 'Backend', 'Jueves', '8:00 AM - 5:00 PM', 'iconos/backend/juanalvarez.webp'),
('Juan Sebastian Fonseca', NULL, 'Backend', 'Jueves', '8:00 AM - 5:00 PM', 'iconos/backend/fonseca.webp'),
('Juan Manuel Salazar', NULL, 'Backend', 'Lunes', '8:00 AM - 5:00 PM', 'iconos/backend/salazar.webp'),
('Yonier Ospina Hincapie', NULL, 'Front', 'Martes', '8:00 AM - 5:00 PM', 'iconos/front/yonier.webp'),
('Juan David Taborda', NULL, 'Backend', 'Lunes', '8:00 AM - 5:00 PM', 'iconos/backend/taborda.webp'),
('David Torres', NULL, 'Backend', 'No tiene', '8:00 AM - 5:00 PM', 'iconos/backend/torres.webp'),


('Jorge', NULL, 'Incidentes', 'Varía', '8:00 AM - 5:00 PM', 'iconos/incidentes/jorge.webp'),
('Camilo', NULL, 'Incidentes', 'Varía', '8:00 AM - 5:00 PM', 'iconos/incidentes/camilo.webp'),
('Samuel', NULL, 'Incidentes', 'Varía', '8:00 AM - 5:00 PM', 'iconos/incidentes/samuel.webp'),
('Sebastian Rico', NULL, 'Integraciones', 'Lunes', '8:00 AM - 5:00 PM', 'iconos/integraciones/rico.webp'),
('Nicolas Guato', NULL, 'Integraciones', 'Viernes', '8:00 AM - 5:00 PM', 'iconos/integraciones/guato.jpg'),
('Brayan Tabares', NULL, 'Transversal', 'Martes', '8:00 AM - 5:00 PM', 'iconos/transversales/andrey.webp'),
('Guillermo Cárdenas', NULL, 'Monitoreo', 'Viernes', '8:00 AM - 5:00 PM', 'iconos/monitoreo/guille.webp'),
('Karla Ramirez', NULL, 'Transversal', 'Jueves', '8:00 AM - 5:00 PM', 'iconos/transversales/karla.webp');

UPDATE usuario
SET dia_casa = 'Viernes'
WHERE nombre = 'Yuly Gomez';

INSERT INTO puesto (codigo_puesto, numero_puesto, ubicacion, id_usuario, reservable, estado, observacion, motivo)
SELECT 'P001','Puesto 06','Puestos izquierda',id_usuario,TRUE,TRUE,'No trabaja desde casa, no reservable.',NULL FROM usuario WHERE nombre='Jesus David Rivera'
UNION ALL
SELECT 'P002','Puesto 03','Puestos izquierda',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Nicolas Zapata'
UNION ALL
SELECT 'P003','Puesto 05','Puestos izquierda',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Anderson Alvarez'
UNION ALL
SELECT 'P004','Puesto 02','Puestos izquierda',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Luis Alejandro Torres'
UNION ALL
SELECT 'P006','Puesto 01','Puestos izquierda',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Natalia Perez'
UNION ALL
SELECT 'P007','Puesto 03','Puestos izquierda 2',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Carolina Perez'
UNION ALL
SELECT 'P008','Puesto 05','Puestos izquierda 2',id_usuario,TRUE,TRUE,'No trabaja desde casa',NULL FROM usuario WHERE nombre='Laura Ramirez'
UNION ALL
SELECT 'P009','Puesto 02','Puestos izquierda 2',id_usuario,TRUE,TRUE,'No trabaja desde casa',NULL FROM usuario WHERE nombre='Kelly Muñoz'
UNION ALL
SELECT 'P010','Puesto 04','Puestos izquierda 2',id_usuario,TRUE,TRUE,'No trabaja desde casa',NULL FROM usuario WHERE nombre='Jennifer Sotelo Perez'
UNION ALL
SELECT 'P011','Puesto 01','Puestos izquierda 2',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Ronald Jimenez Pelaez'
UNION ALL
SELECT 'P012','Puesto 01','Columna central',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Joan Sebastian Vivas Caicedo'
UNION ALL
SELECT 'P013','Puesto 16','Columna central',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Christian Andrés Ramirez'
UNION ALL
SELECT 'P014','Puesto 02','Columna central',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Duvan Esteban Jaramillo'
UNION ALL
SELECT 'P015','Puesto 15','Columna central',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Jose David Cartagena'
UNION ALL
SELECT 'P016','Puesto 03','Columna central',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Jhon Eferson Castaño'
UNION ALL
SELECT 'P017','Puesto 14','Columna central',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Elkin Amador'
UNION ALL
SELECT 'P018','Puesto 13','Columna central',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Anderson Yepes'
UNION ALL
SELECT 'P019','Puesto 05','Columna central',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='David Velasquez'
UNION ALL
SELECT 'P020','Puesto 12','Columna central',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Juan Manuel Lopez'
UNION ALL
SELECT 'P021','Puesto 06','Columna central',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Karol Navia'
UNION ALL
SELECT 'P022','Puesto 11','Columna central',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Andres Ramirez'
UNION ALL
SELECT 'P023','Puesto 10','Columna central',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Edwar'
UNION ALL
SELECT 'P024','Puesto 08','Columna central',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Sebastian Pertuz'
UNION ALL
SELECT 'P025','Puesto 09','Columna central',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Luis Zuluaga'
UNION ALL
SELECT 'P026','Puesto 01','Columna derecha',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Theodoro Dikuyama'
UNION ALL
SELECT 'P027','Puesto 16','Columna derecha',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Sebastian Giraldo'
UNION ALL
SELECT 'P028','Puesto 15','Columna derecha',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Yuly Gomez'
UNION ALL
SELECT 'P029','Puesto 14','Columna derecha',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Karen Herrera'
UNION ALL
SELECT 'P030','Puesto 04','Columna derecha',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Jose Solorzano'
UNION ALL
SELECT 'P031','Puesto 13','Columna derecha',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Jonathan Peña'
UNION ALL
SELECT 'P032','Puesto 05','Columna derecha',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Elkin Murilllo'
UNION ALL
SELECT 'P033','Puesto 12','Columna derecha',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Santiago Peña'
UNION ALL
SELECT 'P034','Puesto 06','Columna derecha',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Jonathan Uribe'
UNION ALL
SELECT 'P035','Puesto 11','Columna derecha',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Esteban Lasso'
UNION ALL
SELECT 'P036','Puesto 07','Columna derecha',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Jose Martinez'
UNION ALL
SELECT 'P037','Puesto 10','Columna derecha',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Laura Rojas'
UNION ALL
SELECT 'P038','Puesto 09','Columna derecha',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Natalia Urrego'
UNION ALL
SELECT 'P039','Puesto 01','Columna derecha 2',id_usuario,TRUE,TRUE,'Puede ser cualquier día desde casa. Varias personas pueden tomarlo en la misma semana.',NULL FROM usuario WHERE nombre='Yulian'
UNION ALL
SELECT 'P040','Puesto 16','Columna derecha 2',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Laura Molina Estrada'
UNION ALL
SELECT 'P041','Puesto 02','Columna derecha 2',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Jeison Martinez'
UNION ALL
SELECT 'P042','Puesto 15','Columna derecha 2',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Gabriel Carmona'
UNION ALL
SELECT 'P043','Puesto 03','Columna derecha 2',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Juan Jose Marin'
UNION ALL
SELECT 'P044','Puesto 14','Columna derecha 2',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Diego Alejandro Bedoya'
UNION ALL
SELECT 'P045','Puesto 04','Columna derecha 2',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Carlos Damian Cano'
UNION ALL
SELECT 'P046','Puesto 13','Columna derecha 2',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Juan Esteban Lopez'
UNION ALL
SELECT 'P047','Puesto 05','Columna derecha 2',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Davison Arley Valencia'
UNION ALL
SELECT 'P048','Puesto 12','Columna derecha 2',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Julian Bedoya'
UNION ALL
SELECT 'P049','Puesto 11','Columna derecha 2',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='David Alvarez'
UNION ALL
SELECT 'P050','Puesto 07','Columna derecha 2',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Juan Sebastian Fonseca'
UNION ALL
SELECT 'P051','Puesto 10','Columna derecha 2',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Juan Manuel Salazar'
UNION ALL
SELECT 'P052','Puesto 08','Columna derecha 2',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Yonier Ospina Hincapie'
UNION ALL
SELECT 'P053','Puesto 09','Columna derecha 2',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Juan David Taborda'
UNION ALL
SELECT 'P005','Puesto 04','Puestos izquierda',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Segrera'
UNION ALL
SELECT 'P054','Puesto 10','Puestos superiores',id_usuario,TRUE,TRUE,'Puede llegar a tener 4 personas a la semana, no recomendado.',NULL FROM usuario WHERE nombre='Jorge'
UNION ALL
SELECT 'P055','Puesto 09','Puestos superiores',id_usuario,TRUE,TRUE,'Puede llegar a tener 4 personas a la semana, no recomendado.',NULL FROM usuario WHERE nombre='Camilo'
UNION ALL
SELECT 'P056','Puesto 08','Columna extrema',id_usuario,TRUE,TRUE,'Puede llegar a tener 4 personas a la semana.',NULL FROM usuario WHERE nombre='Samuel'
UNION ALL
SELECT 'P057','Puesto 05','Columna extrema',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Sebastian Rico'
UNION ALL
SELECT 'P058','Puesto 04','Columna extrema',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Nicolas Guato'
UNION ALL
SELECT 'P059','Puesto 03','Columna extrema',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Brayan Tabares'
UNION ALL
SELECT 'P060','Puesto 02','Columna extrema',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Guillermo Cárdenas'
UNION ALL
SELECT 'P061','Puesto 01','Columna extrema',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='Karla Ramirez';

INSERT INTO usuario (nombre, cargo, area, dia_casa, horario, foto)
VALUES
('Daniel Tamayo','Líder general','Todas las áreas','No tiene día en casa','No exacto','iconos/backend/danielt.webp'),
('Julian IA','Líder','Inteligencia Artificial','No tiene día en casa','No exacto','iconos/Inteligencia artificial/julianIA.webp'),
('Estefania','Líder','Transversal','No tiene día en casa','No exacto','iconos/transversales/estefania.webp'),
('Julieth','Líder','Bi Datas','No tiene día en casa','No exacto','iconos/Bi datas/julieth.webp'),
('Monica','Líder','Gestion de Software','No tiene día en casa','No exacto','iconos/gestion de software/monica.webp'),
('Porras','Líder','Front','No tiene día en casa','No exacto','iconos/front/porras.webp'),
('Algarin','Líder','SiteBuilder','No tiene día en casa','No exacto','iconos/SiteBuilder/algarin.webp'),
('Miranda','Líder','Diseño','No tiene día en casa','No exacto','iconos/diseño/miranda.webp'),
('Deivys','Líder','Incidentes','No tiene día en casa','No exacto','iconos/incidentes/deivys.webp'),
('Jerson','Líder','Integraciones','No tiene día en casa','No exacto','iconos/integraciones/jerson.webp');

INSERT INTO puesto (codigo_puesto, numero_puesto, ubicacion, id_usuario, reservable, estado, observacion, motivo)
SELECT 'P062',NULL,'Puestos izquierda',id_usuario,FALSE,TRUE,NULL,'Puesto de líder: reservado exclusivamente para la persona líder del equipo.' FROM usuario WHERE nombre='Julian IA'
UNION ALL
SELECT 'P063',NULL,'Puestos izquierda 2',id_usuario,FALSE,TRUE,NULL,'Puesto de líder: reservado exclusivamente para la persona líder del equipo.' FROM usuario WHERE nombre='Estefania'
UNION ALL
SELECT 'P064',NULL,'Columna central',id_usuario,FALSE,TRUE,NULL,'Puesto de líder: reservado exclusivamente para la persona líder del equipo.' FROM usuario WHERE nombre='Julieth'
UNION ALL
SELECT 'P065',NULL,'Columna central',id_usuario,FALSE,TRUE,NULL,'Puesto de líder: reservado exclusivamente para la persona líder del equipo.' FROM usuario WHERE nombre='Monica'
UNION ALL
SELECT 'P066',NULL,'Columna derecha',id_usuario,FALSE,TRUE,NULL,'Puesto de líder: reservado exclusivamente para la persona líder del equipo.' FROM usuario WHERE nombre='Porras'
UNION ALL
SELECT 'P067',NULL,'Columna derecha',id_usuario,FALSE,TRUE,NULL,'Puesto de líder: reservado exclusivamente para la persona líder del equipo.' FROM usuario WHERE nombre='Algarin'
UNION ALL
SELECT 'P068',NULL,'Columna derecha',id_usuario,FALSE,TRUE,NULL,'Puesto de líder: reservado exclusivamente para la persona líder del equipo.' FROM usuario WHERE nombre='Miranda'
UNION ALL
SELECT 'P069','Puesto 06','Columna derecha 2',id_usuario,TRUE,TRUE,'Sin observaciones',NULL FROM usuario WHERE nombre='David Torres'
UNION ALL
SELECT 'P070',NULL,'Columna extrema',id_usuario,FALSE,TRUE,NULL,'Puesto de líder: reservado exclusivamente para la persona líder del equipo.' FROM usuario WHERE nombre='Deivys'
UNION ALL
SELECT 'P071',NULL,'Columna extrema',id_usuario,FALSE,TRUE,NULL,'Puesto de líder: reservado exclusivamente para la persona líder del equipo.' FROM usuario WHERE nombre='Jerson';

INSERT INTO usuario (nombre, cargo, area, dia_casa, horario, foto, estado) VALUES
('Mateo Romero', 'Sin puesto fijo', 'Backend', 'No aplica', 'No aplica', 'iconos/backend/mateo.webp', TRUE),
('Ana Alvarez', 'Sin puesto fijo', 'Backend', 'No aplica', 'No aplica', 'iconos/backend/ana.webp', TRUE),
('Angie Castañeda', 'Sin puesto fijo', 'Monitoreo', 'No aplica', 'No aplica', 'iconos/monitoreo/angie.webp', TRUE),
('Luis Arley Morales', 'Sin puesto fijo', 'Integraciones', 'No aplica', 'No aplica', 'iconos/integraciones/arley.webp', TRUE),
('Franchesca Navarro', 'Sin puesto fijo', 'Diseño', 'No aplica', 'No aplica', 'iconos/diseño/franchesca.webp', TRUE),
('Julian Muñoz', 'Sin puesto fijo', 'Inteligencia Artificial', 'No aplica', 'No aplica', 'iconos/Inteligencia artificial/julianIA.webp', TRUE),
('Luis Angel Cordoba', 'Sin puesto fijo', 'Integraciones', 'Aún no definido', 'No aplica', 'iconos/integraciones/luis_cordoba.webp', TRUE);


-- Personas sin puesto fijo se pueden agregar posteriormente a usuario.
-- Al no tener un registro en puesto.id_usuario, aparecerán automáticamente en el panel lateral.

