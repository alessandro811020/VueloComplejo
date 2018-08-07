-----------------------------------------------------------------------------------------
--
-- Proyecto de Módulo de Programación Lenguaje Lua
-- Autor: Alejandro Díaz Solís
-- Fecha: Octubre de 2017
-- Archivo: victoria.lua
--
-----------------------------------------------------------------------------------------
--[[
En esta escena declaramos el objetivo logrado en el juego, mosntrando una escena del triunfo
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
local background, cartelVictoria, cartelLogrado1, cartelLogrado2, sonidoVictoria

--declaramos las opciones del sonido de la victoria que serán fuegos artificiales, donde declaramos el canal y que no serepita el sonido
--una vez reproducido
local opcionesSonidoVictoria =
{
    channel = 4, --declarado para el canal 4
    loops = 0, --declarado que no haya ninguna repetición
}

-- luego de haber ganado el juego, regresar a la pantalla de inicio del juego 
local function volver(event)
  --si la fase de touch es ended 
  if ( "ended" == event.phase ) then
      composer.removeScene("juego") --remover la escena del juego
      audio.stop({channel=4}) --detener el sonido que se está repoduciendo en la escena en caso de que no se haya terminado la reproducción
      composer.gotoScene("inicio")--ir a la escena de inicio
  end
end

-- en caso que después de haber jugado, quiera salir del juego, salir de este
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

--declaramos el primer botón de la escena que se refiere a regresar al inicio, sus características
local boton1 = widget.newButton({
    left = 320/2-50, --posición desde la izquierda
    top = 480/2+70, --posición desde arriba
    id = "boton1", -- el id del botón 
    label = "Menú Inicio", -- la etiqueta del botón que se mostrará en pantalla
    onEvent = volver, --el método que se implementará al darle click
    shape = "roundedRect", --forma del botón
    width = 100,--ancho
    height = 40, --largo
    cornerRadius = 2, --radio de la esquina
    fillColor = { default={195/255,195/255,195/255,1}, over={160/255,052/255,114/255,0.4} }, -- color relleno del botón 
    strokeColor = { default={160/255,052/255,114/255,0,1}, over={0.8,0.8,1,1} }, --color del borde del botón
    strokeWidth = 4 --ancho de la línea
    
})

--declaramos el segundo botón que se refiere a salir de la app
local boton2 = widget.newButton({
    left = 320/2-50, --posición desde la izquierda
    top = 480/2+130, --posición desde arriba
    id = "boton1", --id del botón
    label = "Salir", -- etiqueta que se mostrará en el botón
    onEvent = salir, --el método que se implementará al ser tocado el botón
    shape = "roundedRect", --forma del botón
    width = 100, --ancho del botón
    height = 40, --largo del botón
    cornerRadius = 2, --radio de las esquinas
    fillColor = { default={195/255,195/255,195/255,1}, over={160/255,052/255,114/255,0.4} }, --color del relleno del botón
    strokeColor = { default={160/255,052/255,114/255,0,1}, over={0.8,0.8,1,1} }, --color de los bordes del botón
    strokeWidth = 4 --ancho de la línea del botón
    
})

-- método primero de las escenas, método que crea elementos de la escena que serán usados en ella
function scene:create( event )
  
    --creamos una instancia de la escena dentro del método
    local sceneGroup = self.view
    
    --creamos el fondo de la escena, dada la imagen preparada para ello, dimensiones
    background = display.newImageRect("imagenes/fondo_victoria.jpg",W,H)
    background.x=W/2 --posición en el eje horizontal, el centro
    background.y=H/2 --posición en el eje vertical, el centro
    sceneGroup:insert(background) --insertamos el fondo a la escena
    
    --creamos el cartel de la victoria con sus dimensiones
    cartelVictoria = display.newImageRect("imagenes/cartel_victoria.png", 224, 35)
    sceneGroup:insert(cartelVictoria)--lo insertamos dentro de la escena
    
    --HACEMOS AHORA UN CARTEL DE DOS LINEAS CON EL TEXTO DE QUE SE HA LOGRADO EL OBJETIVO
    --primer cartel, que se carga con sus dimensiones
    cartelLogrado1 = display.newImageRect("imagenes/texto1_llegado.png", 200,37)
    cartelLogrado1.x=0-200 --posición en el eje horizontal x
    cartelLogrado1.y=H/2-10 --posición en el eje vertical y
    sceneGroup:insert(cartelLogrado1) --insertarlo en la escena 
    
    --segundo cartel, cargarlo cons us dimensiones
    cartelLogrado2 = display.newImageRect("imagenes/texto2_destino.png", 172,37)
    cartelLogrado2.x=0-200 --posición en el eje horizontal, fuera de pantalla
    cartelLogrado2.y = H/2+35 --posición en el vertical
    sceneGroup:insert(cartelLogrado2)--insertarlo en la escena
    
    --cargar el sonido de la victoria, que son unos fuegos artificiales
    sonidoVictoria = audio.loadSound("sonido/fuegos_artificiales.wav")
    
    --agregar los botones a la escena
    sceneGroup:insert(boton1)
    sceneGroup:insert(boton2)
end
 
--método show que hace referencia a la interfaz al usuario, donde se hacen los movimientos, declaración de efectos, de sucesos que deben ocurrir
--antes y en la escena
function scene:show( event )
    
    local sceneGroup = self.view --creamos la instancia de la escena creada
    local phase = event.phase --definimos la fase que esté ocurriendo, sea will o did
 
    --en este caso sólo necesitaremos el did, que es la pantalla mostrada
    if ( phase == "did" ) then
      --establecer el volumen del canal cuatro, que es el sonido cargado en esta escena
      audio.setVolume( 0.9, { channel=4 } )
      audio.play(sonidoVictoria, opcionesSonidoVictoria)--reproducir el sonido dadas las opciones planteadas anteriormente
    
      --definimos los movimientos que se realizan en la escena
      transicionVictoria = transition.to(cartelVictoria, {time = 300,x=W/2,y=75}) --mover el cartel de victoria
      transiciontexto1 = transition.to(cartelLogrado1, {time = 300,x=W/2,y=H/2-20}) --mover el texto primero de la explicación del triunfo
      transiciontexto1 = transition.to(cartelLogrado2, {time = 300,x=W/2,y=H/2+35}) --mover el segundo texto de explicación
    end
end

--definimos el método destroy porque debemos descargar la música de la memoria
function scene:destroy( event )
  
    --definimos la instancia de la escena
    local sceneGroup = self.view
    
    --eliminamos el sonido de memoria
    audio.dispose(sonidoVictoria)
    
    --borramos de la variable
    sonidoVictoria=nil
end
 
-- asignamos a la escena respectivas, los listeners y efectos respectivos según el flujo de la escena 
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "destroy", scene )
 

return scene --devolvemos la escena ya creada
