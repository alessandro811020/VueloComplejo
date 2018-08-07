-----------------------------------------------------------------------------------------
--
-- Proyecto de Módulo de Programación Lenguaje Lua
-- Autor: Alejandro Díaz Solís
-- Fecha: Octubre de 2017
-- Archivo: estrellado.lua
--
-----------------------------------------------------------------------------------------
--[[
Esta escena se mostrará cada vez que el usuario estrelle el avión en una columna expresándole que puede
volver a intentarlo. 
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

--definimos el fondo con la imagen que tendrá
local background = display.newImageRect("imagenes/avion_estrellado.png",W,H)

--declaramos la variable del sonido que se trabarará en la escena
local sonidoEstrellado

--declaramos las opciones en una tabla del sonido que se reproducirá dentro de la escena de estrellarse
local opcionesSonidoEstrellado =
{
    channel = 6,--se almacenará en el canal 6
    loops = 0, -- sólo se reproducirá una vez
}

--función que especifica regresar a la escena del juego con las características específicas
local function regresar(event)
  --dada la fase ended del clickeado 
  if ( "ended" == event.phase ) then
    --detener la reproducción del canal 6
    audio.stop({channel=6})
    composer.gotoScene("juego") --ir hacia la escena del juego nuevamente
  end
end

--declaramos el botón que especifica el regresar hacia el juego
local boton = widget.newButton({
    left = 190, -- posición desde la izquierda
    top = 100, --posición desde arriba
    id = "boton1", --id del botón
    label = "Reintentar", --etiqueta que se mostrará en el botón
    onEvent = regresar, --método que implementa el botón de regresar al juego
    shape = "roundedRect", --forma del botón
    width = 100, --ancho
    height = 40, --largo
    cornerRadius = 2, --radio de la esquina del botón
    fillColor = { default={195/255,195/255,195/255,1}, over={160/255,052/255,114/255,0.4} }, --relleno del botón
    strokeColor = { default={160/255,052/255,114/255,0,1}, over={0.8,0.8,1,1} }, --color de los bordes del  botón
    strokeWidth = 4 --ancho del borde
})

-- método primero de las escenas, método que crea elementos de la escena que serán usados en ella
function scene:create( event )
    local sceneGroup = self.view--creamos una instancia de la escena dentro del método
    
    background.x=W/2--posicionamos el fondo dentro de la escena en el centro del eje horizontal
    background.y=H/2 --posicionamos el donfo dentro de la escena en el centro del eje vertical
    
    sonidoEstrellado = audio.loadSound("sonido/estrellado.wav")--cargamos el audio en el programa 
    
    sceneGroup:insert(background)--colocamos el fondo dentro de la escena
    
    sceneGroup:insert(boton) --insertamos el sonido en la escena
end
 
 --método show que hace referencia a la interfaz al usuario, donde se hacen los movimientos, declaración de efectos, de sucesos que deben ocurrir
--antes y en la escena
function scene:show( event )
 
  local sceneGroup = self.view --creamos la instancia de la escena creada
  local phase = event.phase --definimos la fase que esté ocurriendo, sea will o did
 
  --en este caso sólo necesitaremos el did, que es la pantalla mostrada
  if ( phase == "did" ) then
    audio.setVolume( 0.4, { channel=6 } )--establecemos el volumen dentro del canal 6
    
    audio.play(sonidoEstrellado, opcionesSonidoEstrellado)--reproducir el sonido dentro de la escena con las opciones espcificadas
  end
end
 
--definimos el método destroy porque debemos descargar la música de la memoria
function scene:destroy( event )
 
    local sceneGroup = self.view --creamos la instancia de la escena creada
    
    audio.dispose(sonidoEstrellado)--eliminamos el sonido de la memoria
    
    sonidoEstrellado=nil --borramos de la variable
end
 
-- asignamos a la escena respectivas, los listeners y efectos respectivos según el flujo de la escena
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "destroy", scene )

return scene-- devolvemos la escena ya creada