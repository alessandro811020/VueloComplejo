-----------------------------------------------------------------------------------------
--
-- Proyecto de Módulo de Programación Lenguaje Lua
-- Autor: Alejandro Díaz Solís
-- Fecha: Octubre de 2017
-- Archivo: inicio.lua
--
-----------------------------------------------------------------------------------------
--[[
Este archivo es la primera escena del juego, donde se expresa un menú para el usuario, donde podrá
jugar directamente, conocer el objetivo del juego, además de cómo se juega, o salir simplemente del
juego
]]--

--cargamos el gestor de escenas para el futuro trabajo dentro de la presente
local composer = require("composer")
--cargamos el widget dado que colocaremos tres botones dentro del menú
local widget = require("widget")

--creamos la escena donde se le añadirán los componentes 
local scene = composer.newScene()

--aleatorizar desde el tiempo del sistema
local seed = os.time();
math.randomseed( seed )

--guardamos las dimensiones para el uso en la ubicación de los elementos, además de dimensiones
local W = display.contentWidth --ancho
local H = display.contentHeight --largo

--definimos las variables locales que se usarán a lo largo de la escena
local background, titulo1, titulo2, pilotoInicio, aeropuertoBajo
local grupoAviones = {} --una tabla
local numeroAviones = 10 --inicializarlo la cantidad de aviones que estarán volando en el fondo de la pantalla

--función para especificar el rebote de los aviones del fondo cuando lleguen a los bordes de la pantalla
local function rebotarAvion(event)
  --bucle for para la tabla de aviones
  for i,v in pairs(grupoAviones) do
    --para cada avion creamos un avión local para hacer las especificaciones
    local avion = v
    --que la posicion del avión sea la que se encuentra más el vector de de velocidad tanto horizontal como vertical
    avion.x=avion.x+avion.vx
    avion.y=avion.y+avion.vy
    
    --si el avión llega a los bordes horizontales
    if avion.x>=W or avion.x<=0 then
      --invertimos el sentido de la velocidad
      avion.vx=-avion.vx
      --el avión gira
      avion:scale( -1, 1 )
    end
    
    --si llega al borde vertical
    if avion.y>=H or avion.y<=0 then
      --solo invertir el sentido de la velocidad
      avion.vy=-avion.vy
    end
  end
end

--función para ir a jugar
local function jugar(event)
  --terminada la pulsación del botón
  if ( "ended" == event.phase ) then
    --ir a la escena de jugar con efecto fade y una transición que tardará 1 segundo
    composer.gotoScene("juego", {effect="fade", time=1000})
  end
end

--función para ir a la escena de explicar
local function explicar(event)
  --terminada la pulsación del botón
  if ( "ended" == event.phase ) then
    --ir a la escena de la explicación del juego y objetivo, transición fade y tardando 1 segundo
    composer.gotoScene("explicacion", {effect="fade", time=1000})
  end
end

--función que especifica la salida del juego
local function salir(event)
  --conocer la plataforma que está jugando
  local plataforma = system.getInfo( "platform" )
  --al ser pulsado, fin de la pulsación
  if ( "ended" == event.phase ) then
    if plataforma == "android" then--en caso de ser plataforma android
    --salida de la app
      native.requestExit()
    elseif plataforma == "ios" then --en caso de ser ios
      os.exit()--no se recomienda pero para el juego en el deber de salir de ios u no por el botón de home
    end
  end
end

--creación del primer botón con sus especificaciones en las opciones. Botón para ir a jugar
local boton1 = widget.newButton({
    left = W/2-50, --posición desde la izquierda
    top = H/2-70, --posición desde arriba
    id = "boton1", --id del botón
    label = "Jugar", --etiqueta que mostrará lo que dice el botón
    onEvent = jugar, --función que activará al ser clickeado
    shape = "roundedRect", --forma del boton
    width = 100, --ancho 
    height = 40, --largo
    cornerRadius = 2, --radio de las esquinas
    fillColor = { default={195/255,195/255,195/255,1}, over={160/255,052/255,114/255,0.4} },-- colores de los rellenos
    strokeColor = { default={160/255,052/255,114/255,0,1}, over={0.8,0.8,1,1} },--color de la linea del borde
    strokeWidth = 4 --ancho del borde
})

--creación del segundo botón con sus especificaciones en las opciones. Botón para ir a explicar
local boton2 = widget.newButton({
    left = W/2-50, --ancho
    top = H/2, --largo
    id = "boton1", --id del botón
    label = "Objetivo", --etiqueta que mostrará lo que dice el botón
    onEvent = explicar, --función que activará al ser clickeado
    shape = "roundedRect", --forma del botón
    width = 100, --ancho
    height = 40, --largo
    cornerRadius = 2, --radio de las esquinas
    fillColor = { default={195/255,195/255,195/255,1}, over={160/255,052/255,114/255,0.4} }, --colores de los rellenos
    strokeColor = { default={160/255,052/255,114/255,0,1}, over={0.8,0.8,1,1} }, --color de la línea del borde
    strokeWidth = 4 --ancho del borde
    
})

--creación del tercer botón con sus especificaciones en las opciones. Botón para salir de la app
local boton3 = widget.newButton({
    left = W/2-50, --ancho
    top = H/2+70, --largo
    id = "boton1", --id del botón
    label = "Salir", --etiqueta que mostrará lo que dice el botón
    onEvent = salir, --función que activará al ser clickeado
    shape = "roundedRect", --forma del botón
    width = 100, --ancho
    height = 40, --largo
    cornerRadius = 2, --radio de las esquinas
    fillColor = { default={195/255,195/255,195/255,1}, over={160/255,052/255,114/255,0.4} }, --colores de los rellenos
    strokeColor = { default={160/255,052/255,114/255,0,1}, over={0.8,0.8,1,1} }, --color de la línea del borde
    strokeWidth = 4 --ancho del borde
})

-- método primero de las escenas, método que crea elementos de la escena que serán usados en ella
function scene:create( event )
  --creamos una instancia de la escena dentro del método
    local sceneGroup = self.view 
    --a la variable del fondo, le indicamos que será un rectángulo con las dimensiones de la pantalla
    background = display.newRect(0,0,W,H)
    --rellenaremos con un color azul celeste como el cielo
    background:setFillColor(059/255,131/255,189/255)
    --posicionammos el rectángulo dentro de la pantalla
    background.x=W/2 --coordenadas en el eje x
    background.y=H/2 --coordenadas en el eje y
    sceneGroup:insert(background) --insertamos el fondo dentro de la escena
    
    --creamos un bucle para los aviones que salen volando en el fondo de la escena, definido anteriormente un total de 10
    for i=1,numeroAviones do
      --creamos un grupo donde se guardarán los aviones
      local avion = display.newImageRect("imagenes/victoria1.png", 50, 31 ) --creamos un avion con imagen según la dirección expresada
      --el avión se desplaza desde el centro de la pantalla hacia las direcciones aleatoriamente planteadas
      avion:translate( W/2 + math.random( -100, 100 ), H/2 + math.random( -100, 100 ) )
      grupoAviones[i] = avion --asignar al grupo de los aviones, cada avion dentro de la tabla
      sceneGroup:insert(avion) --asignar cada avion a la escena
    end
    
    -- a la variable título1 le asignamos el texto de imagen con las dimensiones especificadas
    titulo1 = display.newImageRect("imagenes/texto1_titulo.png", 200, 75)
    titulo1.x=W/2 --localizacion en el eje x, al centro del eje
    titulo1.y=52 --posición en el eje vertical
    sceneGroup:insert(titulo1) --insertamos el texto dentro de la escena
    
    --asignar la imagen a la variable titulo2 con la imagen guardada
    titulo2 = display.newImageRect("imagenes/texto2_titulo.png", 182,75)
    titulo2.x=W/2 --posicion en el eje horizontal, hacia el centro
    titulo2.y=110 --posicion en el eje vertical, 
    sceneGroup:insert(titulo2) --insertarlo en la escena
    
    --se quiere colocar una imagen de piloto en la presentación y sus dimensiones
    pilotoInicio = display.newImageRect("imagenes/piloto_inicio.png", 170, 170)
    pilotoInicio.anchorX = 0 --establecemos el punto de referencia del piloto en el eje x, en este caso el origen
    pilotoInicio.anchorY = 170 --establecemos el punto de referencia en el eje y, en este caso, el extremo dela imagen abajo
    --era necesario el punto de referencia abajo y a la izquierda para definir desde el fondo la posicion de la imagen
    pilotoInicio.x=0 --posicion en el eje x
    pilotoInicio.y=H --posicion en el eje y
    sceneGroup:insert(pilotoInicio) --asignar a la escena la imagen del piloto
    
    -- creamos la imagen abajo a la derecha de un aeropuerto, por ello creamos el objeto
    aeropuertoBajo = display.newImageRect("imagenes/aeropuerto_inicio.png", 150,96)
    aeropuertoBajo.anchorX=200 --establecemos el punto de referencia en el eje x
    aeropuertoBajo.anchorY=128 --establecemos el punto de referencia en el eje y
    aeropuertoBajo.x=W-15 -- posición en el eje x desde el punto de referencia
    aeropuertoBajo.y=H-15 --posición en el eje y desde el punto de referencia 
    sceneGroup:insert(aeropuertoBajo) --insertar el objeto en la escena
    
    --insertamos en la escena los distintos botones
    sceneGroup:insert(boton1) --insertamos el boton1
    sceneGroup:insert(boton2) --insertamos el boton2
    sceneGroup:insert(boton3) --insertamos el boton3
end
 
 
--método show que hace referencia a la interfaz al usuario, donde se hacen los movimientos, declaración de efectos, de sucesos que deben ocurrir
--al empezar la escena
function scene:show( event )
    
    local sceneGroup = self.view --creamos la instancia de la escena creada
    local phase = event.phase --definimos la fase del método, will o did
    
    --en el caso de que sea will, justo antes de empezar la escena
    if ( phase == "will" ) then
      --hacemos el bucle for referido a los aviones definidos en el grupo de los aviones
      for i,v in pairs(grupoAviones) do
        v.vx=math.random( 1, 5 ) --asignamos la velocidad en el eje x a cada avión creado
        v.vy = math.random( -2, 2 ) --asignamos la velocidad en el eje y a cada avión creado
      end
    --en caso de la fase did, que es lo que será en la pantalla activa
    elseif ( phase == "did" ) then
      Runtime:addEventListener( "enterFrame", rebotarAvion ) --activamos en el Runtime el rebote del avión en los bordes
    end
end
 
 -- que es cuando la escena se encuentra oculta
function scene:hide( event )
    --nuevamente se crea una instancia dentro del método que hace referencia a la escena respectiva
    local sceneGroup = self.view
    local phase = event.phase --para instanciar la fase dentro del método, que puede ser will o did
    -- en este caso solo habrá will que es cuando está pasando a oculta
    if ( phase == "will" ) then
      Runtime:removeEventListener("enterFrame",rebotarAvion) --eliminamos el rebote de los aviónes de los bordes. 
    end
end
 
-- asignamos a la escena respectivas, los listeners y efectos respectivos según el flujo de la escena 
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

return scene --devolvemos la escena que ha sido creada
