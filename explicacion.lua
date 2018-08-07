-----------------------------------------------------------------------------------------
--
-- Proyecto de Módulo de Programación Lenguaje Lua
-- Autor: Alejandro Díaz Solís
-- Fecha: Octubre de 2017
-- Archivo: explicacion.lua
--
-----------------------------------------------------------------------------------------
--[[
En esta escena explicaremos los objetivos del juego y a la vez cçomo se juega, que al darle click el avión 
ascenderá y que deberán atravesar unas 15 columnas.
]]--

--cargamos el gestor de escenas para el futuro trabajo dentro de la presente
local composer = require("composer")

--activamos el autoreciclado de la escena, donde al cerrarla los objetos de la escena se reiniciarán, manteniendo los
--objetos en memoria
composer.recycleOnSceneChange = true

--cargamos el widget dado que colocaremos dos botones dentro de la escena
local widget = require("widget")

--creamos la escena donde se le añadirán los componentes 
local scene = composer.newScene()

--guardamos las dimensiones para el uso en la ubicación de los elementos, además de dimensiones
local W = display.contentWidth --ancho de la pantalla
local H = display.contentHeight --largo de la pantalla


--creamos las distintas variables que se trabajarán en la escena
local background, texto1Explicacion, texto2Explicacion, texto3Explicacion, textoClick, textoEleva, flecha, click, transicionTexto1, transicionTexto2, transicionTexto3, grupoTexto, transicionMesaje1, TransicionMensaje2

-- creamos el método que hace referencia el regresar a la escena de inicio
local function volver(event)
  --si la fase del evento es ended
  if ( "ended" == event.phase ) then
    composer.gotoScene("inicio", {effect="fade", time=1000}) -- transición a la escena del inicio con el efecto fade y que dure un segundo la transición
  end
end

-- método que enlaza la escena con el inicio del juego
local function jugar(event)
  --si es ended la fase final del touch
  if ( "ended" == event.phase ) then
    composer.gotoScene("juego", {effect="fade", time=1000}) -- transición a la escena del juego con el efecto fade y que dure un segundo la transición
  end
end

-- método para activar la imagen visible del click en la escena
local function clickVisible()
  --hacer visible a click
  click.isVisible = true
end

--activar el objeto flecha visible dentro de la escena
local function flechaVisible()
  flecha.isVisible = true--hacer visible la imagen flecha en la escena
end

-- los dos textos  referidos a las imagenes anteriores hacerlos visibles
local function mostrarAcciones()
  textoClick.isVisible = true -- hacer visible el texto del click
  textoEleva.isVisible = true -- hacer visible el texto de elevar
end

--creamos el primer botón de la escena referido a regresar a la escena del inicio
local boton1 = widget.newButton({
    left = 320/2, --posición desde la izquierda
    top = 480/2+70, --posición desde arriba
    id = "boton1", --id del botón 
    label = "Menú Inicio", -- etiqueta del botón, lo que se verá escrito en este
    onEvent = volver, --método que se activará al clickear el botón
    shape = "roundedRect", --forma del botón
    width = 100, --ancho del botón
    height = 40, -- largo del botón
    cornerRadius = 2, --radio de las esquinas
    fillColor = { default={195/255,195/255,195/255,1}, over={160/255,052/255,114/255,0.4} }, --rellenos que contendrá el botón
    strokeColor = { default={160/255,052/255,114/255,0,1}, over={0.8,0.8,1,1} }, --color de los bordes
    strokeWidth = 4 --ancho del borde
})

--creamos el segundo botón de la escena reverido a r a jugar 
local boton2 = widget.newButton({
    left = 320/2, --posición desde la izquierda
    top = 480/2+130, --posición desde la derecha
    id = "boton1", --ide del botón 
    label = "Jugar", --etiqueta el botón que  se reflejará en la escena
    onEvent = jugar, --método que se activará al ser clickeado
    shape = "roundedRect", --forma del botón
    width = 100, --ancho del botón
    height = 40, --largo del botón
    cornerRadius = 2, --radio de las esquinas
    fillColor = { default={195/255,195/255,195/255,1}, over={160/255,052/255,114/255,0.4} }, --rellenos que contendrá el botón
    strokeColor = { default={160/255,052/255,114/255,0,1}, over={0.8,0.8,1,1} }, --color de los bordes
    strokeWidth = 4 --ancho del borde
})

-- método primero de las escenas, método que crea elementos de la escena que serán usados en ella
function scene:create( event )
    local sceneGroup = self.view --creamos una instancia de la escena dentro del método
    --creamos el fondo de la escena, dada la imagen preparada para ello
    background = display.newImageRect("imagenes/fondo_explicacion.jpg",W,H)
    --posiciónamos la imagen en la pantalla
    background.x=W/2 --en el centro del ancho 
    background.y=H/2 -- en el centro de lo largo
    sceneGroup:insert(background) --insertamos el fondo en la escena
    
    --TRES TEXTOS CONSECUTIVOS QUE EXPLICAL EL OBJETIVO A GANAR EN EL JUEGO
    --el primer texto que explica el objetivo y sus dimensiones
    texto1Explicacion = display.newImageRect("imagenes/texto1_explicacion.png", 200, 23)
    texto1Explicacion.x=220 --colocarlo en la posición en el eje horizontal 
    texto1Explicacion.y=-100 --posición en el eje vertical 
    sceneGroup:insert(texto1Explicacion)--insertamos el texto en la escena
    
    --creamos el segundo texto de la explicación
    texto2Explicacion = display.newImageRect("imagenes/texto2_explicacion.png", 164, 23)
    texto2Explicacion.x=220 -- lo ubicamos en las coordenadas el eje x
    texto2Explicacion.y=-100 --lo ubicamos en las coordenadas el eje y
    sceneGroup:insert(texto2Explicacion) --insertamos en la escena
    
    --creamos el tercer texto de la explicación
    texto3Explicacion = display.newImageRect("imagenes/texto3_explicacion.png", 129, 23)
    texto3Explicacion.x=220 --ubicación en le eje x
    texto3Explicacion.y=-100 --ubicación en el eje y
    sceneGroup:insert(texto3Explicacion) --insertar el texto en la escena 
    
    --creamos la flecha que representará que el avión se eleva al darle click y sus dimensiones
    flecha = display.newImageRect("imagenes/flecha.png",40,40)
    flecha.x = 65 --posición en las coordenadas en el eje x
    flecha.y = 80 -- dimensiones en el eje de coordenadas dentro del eje y
    flecha.isVisible = false --iniciamos que no sea visible hasta que se lo especifiquemos mas adelante
    sceneGroup:insert(flecha) --insertamos la flecha dentro de la escena
    
    --creamos la imagen click cons us respectivas dimensiones que reflejara que se puede dar click en la pantalla
    click = display.newImageRect("imagenes/click.png",60,60)
    click.x = 210 --cordenadas dentro del eje x
    click.y = 225 --coordenadas en el eje y vertical 
    click.isVisible = false --establecer como inicio que no sea visible en la pantalla
    sceneGroup:insert(click) --insertamos la imagen dentro de la escena
    
    --creamos un grupo que contendrá a la vez los dos textos de lick y elevar en la pantalla
    grupoTexto = display.newGroup()
    
    --creamos el texto referido al click dentro de la escena cons sus dimensiones
    textoClick = display.newImageRect("imagenes/texto_click.png",67, 29)
    textoClick.x=265 --lo posicionamos dentro de la pantalla en el eje horizontal
    textoClick.y=325 -- lo posicionamos dentro del eje vertical
    textoClick.isVisible = false --lo hacemos invisible dentro de la pantalla inicial
    grupoTexto:insert(textoClick) --insertar el texto en el grupo de texto
    
    --creamos el texto que hace referencia a que sube el avión
    textoEleva = display.newImageRect("imagenes/texto_eleva.png",120, 29)
    textoEleva.x=90 --establecemos las coordenadas dentro del eje horizontal
    textoEleva.y=200 --establecemos las coordenas dentro del eje vertical
    textoEleva.isVisible = false --hacemos el texto no visible al inicio
    grupoTexto:insert(textoEleva) --insertamos el texto en el grupo de texto
    --insertamos el grupo dentro de la escena
    sceneGroup:insert(grupoTexto) 
    
    --insertamos los dos botones como partes de la escena
    sceneGroup:insert(boton1)
    sceneGroup:insert(boton2)
end
 
--método show que hace referencia a la interfaz al usuario, donde se hacen los movimientos, declaración de efectos, de sucesos que deben ocurrir
--al empezar la escena
function scene:show( event )
    --declaramos un objeto dentro del método qeu haga referencia a la escena que se está trabajando
    local sceneGroup = self.view
    --identificamos la fase y sea did o will, así los sucesos, en este caso, no ha sido necesario el uso del will
    local phase = event.phase
    
    --en caso de ser did, que es la pantalla ya mostrada en escena, los sucesos que debe ocurrir
    if ( phase == "did" ) then
      
      --SE HARÁ UNA PEQUEÑA ANIMACIÓN QUE EXPLIQUE EL OBJETIVO Y CÓMO JUGAR
      --mover el texto de explicación desde arriba, el tiempo de movimiento, y lo que debe tardar para que esto ocurra.
      transicionTexto1 = transition.to( texto1Explicacion, { time=500, delay=500, x=220, y=80} ) --movimiento del texto 1
      transicionTexto2 = transition.to( texto2Explicacion, { time=500, delay=1000, x=220, y=115} ) --movimiento del texto 2
      transicionTexto3 = transition.to( texto3Explicacion, { time=500, delay=1500, x=220, y=150} ) --movimiento del texto 3
      --se coloca hasta donde deben moverse y también una sincronización de movimientos
    
      --ahora toca agrandar la mano del click aumentando su escala y luego regresandola a su tamaño original. Se especifica el método que 
      --declara visible al objeto primeramente
      transicionClick1 = transition.scaleTo( click, { xScale=1.25, yScale=1.25, time=1000,delay = 2500, onStart = clickVisible } )--agrandarlo
      transicionClick2 = transition.scaleTo( click, { xScale=0.8, yScale=0.8, time=1000,delay = 3500 } ) --reducirlo al tamaño original
      --se especifica el tiempo, posición de objeto, además de la demora sincronizada de las acciones
      
      --ahora toca agrandar la flecha del avión aumentando su escala y luego regresandola a su tamaño original. Se especifica el método que 
      --declara visible al objeto primeramente
      transicionFlecha1 = transition.scaleTo( flecha, { xScale=1.25, yScale=1.25, time=1000,delay = 4500, onStart = flechaVisible } ) --agrandar la flecha
      transicionFlecha2 = transition.scaleTo( flecha, { xScale=0.8, yScale=0.8, time=1000,delay = 5500 } ) --devolverlo al tamaño original
      --se especifica el tiempo, la posición, además de la demora sincronizada de las acciones
      
      --ahora toca agrandar el grupo de textos referativos a las acciones y luego regresandola a su tamaño original. Se especifica el método que 
      --declara visible al grupo primeramente
      transicionMensaje1 = transition.scaleTo( grupoTexto, { xScale=1.1, yScale=1.1, time=1000,delay = 6500, onStart = mostrarAcciones } ) --agrandar al grupo
      transicionMensaje2 = transition.scaleTo( grupoTexto, { xScale=0.8, yScale=0.8, time=1000,delay = 7500 } ) --reducirlo a su tamaño original
      --se especifican el tiempo, la posición ademas de la demora cone l delay sincronizada de las acciones.
    end
end
 
-- asignamos a la escena respectivas, los listeners y efectos respectivos según el flujo de la escena, en este caso solo se ha sido necesario el create
-- y el show
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
 
--devolver la escena con todas sus características
return scene
