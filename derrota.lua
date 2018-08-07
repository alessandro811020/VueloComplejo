-----------------------------------------------------------------------------------------
--
-- Proyecto de Módulo de Programación Lenguaje Lua
-- Autor: Alejandro Díaz Solís
-- Fecha: Octubre de 2017
-- Archivo: derrota.lua
--
-----------------------------------------------------------------------------------------
--[[
Esta escena se ha preparado para cuando el usuario ha gastado sus tres vidas del juego y por ello, se le declara la derrota
y que nuevamente vuelva a intentarlo, con los dos botones de regresar o de salir
]]--
--cargamos el gestor de escenas para el futuro trabajo dentro de la presente
local composer = require("composer")

--cargamos el widget dado que colocaremos dos botones dentro de la escena
local widget = require("widget")

--creamos la escena donde se le añadirán los componentes
local scene = composer.newScene()

--guardamos las dimensiones para el uso en la ubicación de los elementos, además de dimensiones
local W = display.contentWidth --definimos el ancho de la pantalla
local H = display.contentHeight --definimos el largo de la pantalla

--creamos las distintas variables que se trabajarán en la escena
local background, piloto, texto1, texto2, texto3, sonidoDerrota

--declaramos las opciones del sonido que se cargará en la escena, de la derrota
local opcionesSonidoDerrota =
{
    channel = 5, --declaramos el canal que ocupará en la memoria
    loops = 0, -- que no se repita, que únicamente se reproduzca una vez
}

--este método regresa al usuario a la escena de inicio del juego
local function iniciar(event)
  --si se termina de clickear, en la fase ended, entonces
  if ( "ended" == event.phase ) then
    audio.stop({channel=5})--detener la reproducción del canal 5 
    composer.gotoScene("inicio", {effect="fade", time=1000})--regresar a la escena inicio, con el tiempo y la transición especificada
  end
end

--declaramos al botón que se accionará el regresar a la pantalla de inicio
local boton = widget.newButton({
    left = W/2+35, --posición desde la izquierda
    top = H/2+20, --posición desde arriba
    id = "boton1", --id del botón
    label = "Inicio", -- etiqueta que se mostrará en la escena en el botón
    onEvent = iniciar, --método que se implementará al ser clickeado
    shape = "roundedRect", --forma del botón
    width = 100, --ancho del botón
    height = 40, --largo del botón
    cornerRadius = 2, --radio de la esquina
    fillColor = { default={195/255,195/255,195/255,1}, over={160/255,052/255,114/255,0.4} }, --relleno del botón que tendrá
    strokeColor = { default={160/255,052/255,114/255,0,1}, over={0.8,0.8,1,1} }, --color del borde delbotón
    strokeWidth = 4 --ancho de la línea que tendrá el botón
})

-- método primero de las escenas, método que crea elementos de la escena que serán usados en ella
function scene:create( event )
    local sceneGroup = self.view--creamos una instancia de la escena dentro del método
    
    --creamos el fondo de la escena, dada la imagen preparada para ello, dimensiones
    background = display.newRect(0,0,W,H) --en este caso será un rectángulo con las dimensiones de la pantalla
    background:setFillColor(073/255,103/255,141/255) --rellenamos el rectángulo
    background.x=W/2 -- posición en el centro de la pantalla en el eje horizontal
    background.y=H/2 --posición en el centro de la pantalla en el eje vertical
    sceneGroup:insert(background) --insertamos el fondo en la escena

    
    --asignamos a piloto la imagen del piloto respectiva con las dimensiones pescificadas para la escena
    piloto = display.newImageRect("imagenes/piloto_derrota.png", 222, 250)
    piloto.anchorX=0--establecemos el punto de referencia de la imagen a la izquierda
    piloto.anchorY=250 --establecemos el punto de referencia abajo de la imagen
    piloto.x=0 --ubicamos en el eje horizontal en el origen
    piloto.y=H --extremo inferior de la pantalla
    sceneGroup:insert(piloto) --insertamos la imagen del piloto en la escena

    
    --establecemos el texto primero de la derrota y sus dimensiones
    texto1 = display.newImageRect("imagenes/texto1_derrota.png", 200, 45)
    texto1.x=W/2--lo ubicamos en el centro del eje horizontal
    texto1.y=80 --establecemos en el eje vertical
    sceneGroup:insert(texto1)--insertamos el texto 1 en la escena
    
    --establecemos el texto segundo de la derrota y sus dimensiones. 
    texto2 = display.newImageRect("imagenes/texto2_derrota.png", 80, 36)
    texto2.x=W/2--posición en el centro del eje horizontal
    texto2.y=120 --establecemos en el eje vertical
    sceneGroup:insert(texto2) --insertamos el texto2 en la escena

    
    --establecemos el texto tercero de la derrota y sus dimensiones
    texto3 = display.newImageRect("imagenes/texto3_derrota.png", 250, 35)
    texto3.x=W/2--posición en el centro del eje horizontal
    texto3.y=160 --ubicación en el eje vertical desde arriba
    sceneGroup:insert(texto3)--insertamos el texto3 en la escena
    
    --cargamos el sonido de la derrota
    sonidoDerrota = audio.loadSound("sonido/derrota.wav")
    
    --insertamos el botón en la escena
    sceneGroup:insert(boton)
end
 
--método show que hace referencia a la interfaz al usuario, donde se hacen los movimientos, declaración de efectos, de sucesos que deben ocurrir
--antes y en la escena
function scene:show( event )
 
    local sceneGroup = self.view--creamos la instancia de la escena creada
    local phase = event.phase --definimos la fase que esté ocurriendo, sea will o did
 
    --en este caso sólo necesitaremos el did, que es la pantalla mostrada
    if ( phase == "did" ) then
      audio.setVolume( 0.4, { channel=5 } )--establecer el volumen del canal cinco que es el que se reproduce con el sonido de la derrota
      audio.play(sonidoDerrota, opcionesSonidoDerrota) --accionar el sonido de la derrota
    end
end
 
--definimos el método destroy porque debemos descargar la música de la memoria
function scene:destroy( event )
  
    --definimos la instancia de la escena
    local sceneGroup = self.view
    
    --eliminamos el sonido de memoria
    audio.dispose(sonidoDerrota)
    
    --borramos de la variable
    sonidoDerrota=nil 
end
 
-- asignamos a la escena respectivas, los listeners y efectos respectivos según el flujo de la escena 
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "destroy", scene )
 
return scene --devolvemos la escena ya creada
