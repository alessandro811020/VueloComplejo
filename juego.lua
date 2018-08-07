-----------------------------------------------------------------------------------------
--
-- Proyecto de Módulo de Programación Lenguaje Lua
-- Autor: Alejandro Díaz Solís
-- Fecha: Octubre de 2017
-- Archivo: juego.lua
--
-----------------------------------------------------------------------------------------
--[[
Esta es la escena principal del programa, porque es la escena del juego, donde se declaran las vidas, los puntos, ademñas de todas las situaciones transiciones, sonidos específicos para el juego. La esencia principal del programa.
]]--
--cargamos el gestor de escenas para el futuro trabajo dentro de la presente
local composer = require("composer")

composer.recycleOnSceneChange = false--desactivamos el autoreciclado de la escena, por lo que los objetos de la escena no se reinician, manteniendo 
                                      --la situación en memoria 

local physics = require("physics") --requerimos el módulo de física para la asignación de propiedades físicas a determinados objetos en el juego

local scene = composer.newScene()--creamos la escena donde se le añadirán los componentes

--guardamos las dimensiones para el uso en la ubicación de los elementos, además de dimensiones
local W = display.contentWidth --definimos el ancho de la pantalla en una variable
local H = display.contentHeight -- definimos el largo de la pantalla en una variable
local math_random=math.random --creamos una herramienta para obtener valoes aleatorios y optimizamos la memoria

--especificamos esas variables se trabajaran a lo largo de la escena
local puntos, contadorPuntos, contadorVidas, vidas, avionSprite, temporizador_columnas, temporizador_nubes, emittert, transicionAbajo, transicionArriba, transicionSensor,grupoColumnas, gPrincipal
local nubes = {} --una tabla donde se guardarán las nubes que volarán en el cielo
local sonidos = {} --tabla para los sonidos que se guardarán en la escena

--vienen los datos del sprite del avion, las cuadrículas del sprite
local opciones = {
  width = 80, --ancho de la cuadrícula
  height = 60, --largo de la cuadrícula
  numFrames = 3, --hay tres imágenes en el spritesheet
  sheetContentWidth = 80, --ancho del contenedor del sprite
  sheetContentHeight = 180 --largo del contenedor
}

local avionSheet = graphics.newImageSheet("imagenes/avion.png",opciones) --declaramos el sheet donde se encuentran las imágenes de la animación

--se crea una tabla con las especificaciones de la animación, nombre, el tiempo de realización, ademas de las coordenadas de cada imagen en el spritesheet
local secuenciaSpriteAvion = {
    {name = "avion", start = 1, count = 3, time = 700},
    frames = {
        {
            x=1, --coordenadas desde el horizontal
            y=40, --coordenada desde el vertical
            width=54, --ancho de la imagen
            height=20, --largo del imagen
            sourceX = 20, --coordenadas en el sprite desde donde se mide
            sourceY = 16, --coordenadas en el sprite desde donde se mide
            sourceWidth = 80, --ancho
            sourceHeight = 60 -- largo
        },
        --ahora todos tienes las mismas definiciones en la tabla
        {
            x=1,
            y=1,
            width=54,
            height=28,
            sourceX = 20,
            sourceY = 10,
            sourceWidth = 80,
            sourceHeight = 60
        },
        {
            x=1,
            y=50,
            width=54,
            height=44,
            sourceX = 22,
            sourceY = 1,
            sourceWidth = 80,
            sourceHeight = 60
        },
        {
            x=1,
            y=50,
            width=54,
            height=44,
            sourceX = 22,
            sourceY = 1,
            sourceWidth = 80,
            sourceHeight = 60
        },
        {
            x=1,
            y=1,
            width=54,
            height=28,
            sourceX = 20,
            sourceY = 10,
            sourceWidth = 80,
            sourceHeight = 60
        },
        {
            x=1,
            y=40,
            width=54,
            height=20,
            sourceX = 20,
            sourceY = 16,
            sourceWidth = 80,
            sourceHeight = 60
        },
    }
}

--se definen las opciones del sonido del avión, especificando que se almacenará en el canal 3
local opcionesSonidoAvion =
{
  channel = 3,--canal 3
  loops = -1, --reproducción indefinida, se repita indefinidamente hasta que el programa sea quien decida cuando detenerlo
}
--definir las opciones del sonido de la explosión 
local opcionesSonidoExplosion =
{
  channel = 2,--almacenarlo en el canal 2 de sonido
  loops = 0, --se reproduzca una sola vez
}

--escogemos las nubes que se usaran en el juego y las hacemos desplazar por la pantalla
local function moverNubes(event)
      local obj = nubes[math_random(1,3)] --definimos nubes aleatoriamente desde 1 hasta 3
      obj.x = W --posicionamos en el borde a la derecha de la pantalla
      obj.y = math_random(0,H) --aleatoriamente colocamos la nube a lo largo de la pantalla
      obj.sizeX = obj.contentWidth --definimos el tamaño del objeto egun el tamaño de la imagen
      obj.sizeY = obj.contentHeight --definimos el grosor de la nube según al grosor de la imagen
      transition.to(obj, {time=math_random(1200,1800),x=0-obj.contentWidth-40,y=obj.y}) --hacer el movimiento de la nube desde la derecha hacia la izquierda
      --cuando el objeto llegue al borde de la izquierda sea borrado
      if obj.x == 0-obj.contentWidth/2 then
        obj:removeSelf()
      end
end

--función que se usará para el juego, cuando se clickee la pantalla, asignarle al avión velocidad en el vertical invertido hacia arriba
local function levantarAvion(event)
      avionSprite:setLinearVelocity(0,-150)--establecer velocidad linea netamente vertical hacia arriba
end

--creamos las columnas con los sensores
local function crearColumna()
  
  local rectangulo = { -18,-185 , 18,-185 , 18,185 , -18,185}--creamos un rectángulo que expresará los bordes de contacto en las colisiones
  local opcionesFisicas = {density = 0.8, friction =0.8, bounce = 0.8, shape=rectangulo}--tabla de opcione de propiedades físicas
  
  grupoColumnas = display.newGroup()--creamos el grupo donde se almacenarán las columnas y el espacio intermedio como sensor de que el avión le atraviesa
  
  --CREAMOS LAS COLUMNAS
  local columnaAbajo = display.newImageRect("imagenes/columna_abajo.png", 55, 400)--definimos la imagen  y sus características
  columnaAbajo.myName = "abajo" --establecemos el nombre de la columna para las colisiones
  columnaAbajo.anchorX=0 --establecemos el punto de referencia de la columna para su ubicación en el eje horizontal
  columnaAbajo.anchorY=0 --establecemos el punto de referencia de la columna para su ubicación en el eje vertical
  physics.addBody(columnaAbajo, "kinematic", opcionesFisicas)--añadimos la columna al espacio físico con propiedades kinematic, donde no influya la gravedad
  
  local columnaArriba = display.newImageRect("imagenes/columna_arriba.png", 55,400)--definimos la imagen y sus características
  columnaArriba.myName = "arriba" --colocamos el nombre para las colisiones
  columnaArriba.anchorX = 0 --establecemos la referencia de la columna en el horizontal en el origen 
  columnaArriba.anchorY=0 --establecemos la diferencia de la columna en el vertical en elorigen
  physics.addBody(columnaArriba, "kinematic", opcionesFisicas)--agreamos la columna en el espacio físico con propiedades que no infuye la gravedad

  --definimos el sensor, el espacion intermedio entre las columnas
  local sensor = display.newRect(0,0,25,110)--un rectangulo con sus dimensiones
  sensor.myName="sensor" --definimos el nombre sensor para las colisiones
  sensor.anchorX=0--establecemos la referencia en el horizontal del sensor
  sensor.anchorY=0--establecemos la referencia en el vertical del sensor
  sensor.alpha=0--que sea completamente trasparente
  physics.addBody(sensor, "kinematic", {isSensor = true}) --lo agregamos al espacio físico que pueda ser atravesado, declarando el sensor como true
  
  --colocaremos cada uno sobre el otro en posición desde abajo aleatoria e ir sumando
  columnaAbajo.x=W--parte desde el fondo de la derecha
  columnaAbajo.y =math_random(145,335) --desde abajo varie su posicón entre estos valores  aleatoriamente
  sensor.x=W+10 --el sensor que empiece un poco más allá del borde para que sea mas sensible en las columnas, 
  sensor.y= columnaAbajo.y-110--desde el punto de abajo, restarle 110 para que vaya hacia arriba
  columnaArriba.x=W--parde desde el fondo de la derecha
  columnaArriba.y=sensor.y-400 --desde el sensor, restarle 400 para que se haga una sola columna
  
  
  --si llega a 8 puntos las columnas vayan más rápido
  if contadorVidas<9 then --si es menor que 9 casa 1200 milisegundos
    transicionAbajo = transition.to(columnaAbajo, {time = 1600,x=0-columnaAbajo.contentWidth-40,y=columnaAbajo.y, onComplete = function() display.remove(columnaAbajo)end})--mover la columna de abajo, con transicion de 1600 definiendo hasta donde, y que al llegar al borde desaparezca
    transicionSensor = transition.to(sensor, {time = 1600, x=0-sensor.contentWidth-40,y=sensor.y, onComplete = function() display.remove(sensor)end})--mover el sensor, con transicion de 1600 definiendo hasta donde, y que al llegar al borde desaparezca
    transicionArriba = transition.to(columnaArriba, {time = 1600,x=0-columnaArriba.contentWidth-40,y=columnaArriba.y, onComplete = function() display.remove(columnaArriba)end})--mover la columna de arriba, con transicion de 1600 definiendo hasta donde, y que al llegar al borde desaparezca
  else --sino que vaya cada 700 milisegundos
    transicionAbajo = transition.to(columnaAbajo, {time = 700,x=0-columnaAbajo.contentWidth-40,y=columnaAbajo.y, onComplete = function() display.remove(columnaAbajo)end})--mover la columna de abajo, con transicion de 700 definiendo hasta donde, y que al llegar al borde desaparezca
    transicionSensor = transition.to(sensor, {time = 700, x=0-sensor.contentWidth-40,y=sensor.y, onComplete = function() display.remove(sensor)end})--mover el sensor, con transicion de 700 definiendo hasta donde, y que al llegar al borde desaparezca
    transicionArriba = transition.to(columnaArriba, {time = 700,x=0-columnaArriba.contentWidth-40,y=columnaArriba.y, onComplete = function() display.remove(columnaArriba)end})--mover la columna de arriba, con transicion de 700 definiendo hasta donde, y que al llegar al borde desaparezca
  end
  
  grupoColumnas:insert(columnaAbajo)--insertar la columna en el grupo
  grupoColumnas:insert(sensor) --insertar el sensor enel grupo
  grupoColumnas:insert(columnaArriba) --insertar la columna en el grupo de la coumna

  gPrincipal:insert(grupoColumnas)--insertamos el grupo de las columnas en la grupo principal que ha sido insertado en la escena
end

--creamos la función que crea el emitter de la explosión donde se le introducirán las coordenadas de la colisión
local function hacerEmitter(a,b)
  local particleDesigner = require( "particleDesigner" ) --se requiere del módulo 
  local emitterExplosion = particleDesigner.newEmitter( "fire.json" ) --creación del emitter
  emitterExplosion.x = a --ubicar la explosión en la coordenada x de la colisión
  emitterExplosion.y = b --ubicación de la explosión en la coordenada y de la colisión
  return emitterExplosion --devolver el emitter de la explosión
end

--función que se encargará de controlar que el avión no sobrepase la base de la pantalla
local function controlBajo(event)
  if avionSprite.y>W+120 then--si el avión sobrepasa la pantalla
    transition.pause(transicionAbajo)--detener la transición de la columna de abajo
    transition.pause(transicionArriba)--detener la transición de la columna de arriba
    transition.pause(transicionSensor)--detener la transición del sensor
      
    timer.pause( temporizador_columnas )--detener el timer de sacar columnas aleatoriamente
    timer.pause( temporizador_nubes )--detener el timer de enviar nubes en la pantalla del programa
      
    audio.stop( { channel=3 } )--detener el sonido del avión volando del canal 3
    
    contadorVidas = contadorVidas -1 --restar una vida de las que cuenta el usuario
    
    --en caso de que las vidas sean mayor que cero 
    if contadorVidas>0 then
      composer.gotoScene("estrellado", {effect="fade", time=1000})--que se vaya hacia el estrellado, aun no es derrota
    else--en aso contrario pues que active el reciclado para reiniciar los objetos y se retire a la página de derrota
      composer.recycleOnSceneChange = true --activado del reciclado
      composer.gotoScene("derrota", {effect="fade", time=1000}) --ir hacia la escena de la derrota
    end
  end
end

--función que se refiere al control global de las colisiones que tendrá el juego
local function onGlobalCollision(event)
  
  if(event.phase=="began") then --si empieza la colisión
      
      --debe ver si es entre el avión y las columnas, como el programa no define el objeto quien es el objeto 1 u dos, deben especificarse ambas opciones
      if (event.object1.myName=="avion" and event.object2.myName=="abajo") or (event.object1.myName=="avion" and event.object2.myName == "arriba") or (event.object1.myName=="abajo" and event.object2.myName=="avion") or (event.object1.myName=="arriba" and event.object2.myName == "avion") then
        
        transition.pause(transicionAbajo)--detener la transición de la columna de abajo
        transition.pause(transicionArriba)--detener la transición de la columna de arriba
        transition.pause(transicionSensor)--detener la transición de un sensor
      
        timer.pause( temporizador_columnas )--detener el timer de las columnas
        timer.pause( temporizador_nubes )--detener el timer de las nubes
      
        avionSprite:removeSelf() --desaparece el avión
      
        emittert = hacerEmitter(event.x, event.y)--realizar el emitter dadas las coordenadas
        audio.stop( { channel=3 } )--detener el audio del avión

        audio.setVolume( 0.4, { channel=2 } )--establecer el audio del canal 2 de la explosión
        audio.play(sonidos["explosion"], opcionesSonidoExplosion)--reproducir la explosión del avión
        contadorVidas = contadorVidas -1 --disminuir una vida del usuario
        gPrincipal:insert(emittert)--agregar en el grupo principal al emitter, el cual se agregó a la escena
        if contadorVidas>0 then --si las vidas aún son positivas
          composer.gotoScene("estrellado", {effect="fade", time=1000})--transición hacia la escena de estrellado pero que lo siga intentando
        else --en caso contrario, pues se activa el reciclado para que los objetos se reinicien nuevamente
          composer.recycleOnSceneChange = true
          composer.gotoScene("derrota", {effect="fade", time=1000})--trnasiion a la escena de la derrota
        end
      
      --en caso de que el avión atraviese el sensor, pues que puntue
      elseif (event.object1.myName == "avion" and event.object2.myName == "sensor") or (event.object1.myName == "sensor" and event.object2.myName == "avion")then
      
        contadorPuntos = contadorPuntos + 1 --que puntue el usuario por atravesar el espacio
        if contadorPuntos == 15 then --en caso de que iguale a 15 ha ganado
          audio.stop({channel=3})--detener el sonido del avión en el canal 3
          composer.gotoScene("victoria", {effect="fade", time=1000}) --ir hacia la escena de la victoria
        end      
      end
  end
end

--función que expresa la escritura en el texto de los puntos que se va obteniendo
local function mostrasPuntos()
    puntos.text=contadorPuntos--escribir los puntos en el texto
end
--función que expresa la escritura en el texto de las vidas que se van quedando
local function mostrasVidas()
    vidas.text=contadorVidas --escriba el texto de las vidas que van quedando
end
 
-- método primero de las escenas, método que crea elementos de la escena que serán usados en ella
function scene:create( event )

  gPrincipal = display.newGroup()--creamos un grupo principal
  physics.setReportCollisionsInContentCoordinates( true )--que en las colisiones haga un control más específico de las coordenadas de la colisión
  physics.setAverageCollisionPositions( true )--qe al haber varios posibles puntos dec ontacto, defina uno exacto promedio
  local group = self.view--defina una instancia de la escena dentro del método
  local cielo = display.newImageRect("imagenes/cielo_juego.jpg",W,H) --definir el fondo de la escena con el cielo del vuelo
  cielo.anchorX=0 --establecer el punto de referencia del fondo en el eje horizontal
  cielo.anchorY=0--establecer el punto de referencia del fondo en el eje vertical
  gPrincipal:insert(cielo) --insertar el cielo en el grupo principal

  physics.start()--iniciar las propiedades físicas, el mundo físico dentro del juego
  physics.setGravity(0,11)--establecer la gravedad del juego
  group:insert(gPrincipal)--insertar el grupo principal dentro de la escena
    
  local avionVida = display.newImageRect("imagenes/avion_vida.png",38,40)--definir una imagenque refleje un avión como muestra de las vidas
  avionVida.anchorX=0--establecer coordenada de referencia en el eje horizontal
  avionVida.anchorY=0--establecer coordenada de referencia en el eje vertical
  avionVida.x=W/2-45 --posición en el eje x
  avionVida.y=2 --posición en el eje y
  group:insert(avionVida) --insertar el avión en la escena
  
  contadorPuntos = 0--inicializar los puntos desde cero
  contadorVidas = 3 --inicializar las vidas desde 3
  
  vidas = display.newText(contadorVidas,W/2,0+20,"GermaniaOne-Regular.ttf",25)--definir el texto donde se mostrará el número de vidas
  vidas:setTextColor(0,0,0)--finar el color del texto
  group:insert(vidas)--insertar este texto en la escena del juego
  
  local cartelPuntos = display.newImageRect("imagenes/puntuacion.png",50,15)--definir como una imagen el cartel que expresa los puntos alcanzados
  cartelPuntos.anchorX=0 --establecer la referencia en el eje horizontal
  cartelPuntos.anchorY=0 --establecer la referencia en el eje vertical
  cartelPuntos.x=W-85 --colocar la imagen en el eje x
  cartelPuntos.y=0+15 --colocar la imagen en el eje y
  group:insert(cartelPuntos) --insertar esta imagen en la escena
  
  puntos = display.newText(contadorPuntos, W-20, 0+20,"GermaniaOne-Regular.ttf",25) --definir un texto donde se expresen los puntos alcanzados
  puntos:setTextColor(0,0,0)--definir el color del texto
  group:insert(puntos)--insertar el texto en la escena
  
  --ahora se definirán las distintas nubes dentro de la tabla de nubes.
  nubes[1] = display.newImage("imagenes/nubes/nube1.png")--definir la imagen de la primera nube
  nubes[1].x = W+150--coordenada de inicio en xde la nube
  nubes[1].y = H+150--coordenada de inicio en y
  nubes[1]:scale(math_random(0.9,3),math_random(0.9,3))--definir aleatoriamente el tamaño de las nubes
  nubes[2] = display.newImage("imagenes/nubes/nube2.png")--definir la imagen de la primera nube
  nubes[2].x = W+150 --coordenada de inicio en xde la nube
  nubes[2].y = H+150--coordenada de inicio en y
  nubes[2]:scale(math_random(0.9,3),math_random(0.9,3))--definir aleatoriamente el tamaño de las nubes
  nubes[3] = display.newImage("imagenes/nubes/nube3.png")--definir la imagen de la primera nube
  nubes[3].x = W+150 --coordenada de inicio en xde la nube
  nubes[3].y = H+150--coordenada de inicio en y
  nubes[3]:scale(math_random(0.9,3),math_random(0.9,3))--definir aleatoriamente el tamaño de las nubes
  --insertamos cada tipo de nube dentro de la escena
  group:insert(nubes[1])
  group:insert(nubes[2])
  group:insert(nubes[3])
  
  sonidos["avion"] = audio.loadSound("sonido/avion_volando.wav")--definimos el sonido del avión volando
  sonidos["explosion"] = audio.loadSound("sonido/explosion.wav")--definimos el sonido de la explosión
end
 
--método show que hace referencia a la interfaz al usuario, donde se hacen los movimientos, declaración de efectos, de sucesos que deben ocurrir
--antes y en la escena
function scene:show( event )
  local sceneGroup = self.view--creamos la instancia de la escena creada
  local phase = event.phase--definimos la fase que esté ocurriendo, sea will o did
  --en caso de fase will, que es justo antes de empezar la escena
  if ( phase == "will" ) then
    --si llega a 8 puntos las columnas vayan más rápido
    if contadorVidas<9 then --si es mayor que diez casa 1200 milisegundos
      temporizador_columnas = timer.performWithDelay(1600,crearColumna,0)--activamos el temporizador de las columnas
    else --sino que vaya cada 1600
      temporizador_columnas = timer.performWithDelay(800,crearColumna,0)--activamos el temporizador de las columnas
    end
    
    temporizador_nubes = timer.performWithDelay(math_random(1000,2000),moverNubes,0) --activamos el temporizador de las nubes, aleatorio tiempo
    audio.setVolume( 0.25, { channel=3 } )--establecemos el volumen del canal del sonido del avión
    audio.play(sonidos["avion"], opcionesSonidoAvion)--reproducimos el sonido del avión que saldrá a la escena a volar
  
    Runtime:addEventListener("touch",levantarAvion) --añadir el evento touche que refleja el levantar el avión a medida que se toqe la pantalla
    Runtime:addEventListener("collision", onGlobalCollision)--control de las colisiones del juego
    --en caso de que sea did, escena ya reproduciendose
  elseif ( phase == "did" ) then
    --borrar el emittert anterior
    display.remove(emittert)
    --colocar el avión dentro de la escena con sus caracteristicas
    avionSprite = display.newSprite(avionSheet,secuenciaSpriteAvion)
    avionSprite.x=30 --ubicación en x
    avionSprite.y=H/2 --ubicación en y
    avionSprite:setSequence("avion")--expresar la secuencia de animación que se desea
    avionSprite.myName = "avion"--definir el nombre para las colisiones
    avionSprite:play()--reproducir el sprite

    physics.addBody(avionSprite,{density=0.4, friction=1.0, bounce=0})--agregar el sprite al mundo físico
    
    Runtime:addEventListener("enterFrame", controlBajo) --establecer en el Runtime el avión no sobrepase la base
    Runtime:addEventListener("enterFrame",mostrasPuntos) --establecer los puntos que se van obteniendo
    Runtime:addEventListener("enterFrame",mostrasVidas) --establecer las vidas que aun van quedando en la pantalla
    end
end
 
-- que es cuando la escena se encuentra oculta
function scene:hide( event )
 
    local sceneGroup = self.view--creamos la instancia de la escena creada
    local phase = event.phase--definimos la fase que esté ocurriendo, sea will o did
 
    if ( phase == "will" ) then--en caso de que vaya saliendo de la escena
        audio.pause({channel=3})--detener el sonido del canal 3
        timer.cancel( temporizador_columnas )--detener el temporizador de las columnas
        timer.cancel( temporizador_nubes )--detener el temporizador de las nubes
        Runtime:removeEventListener("enterFrame", controlBajo)--quitar el listener del control bajo
        Runtime:removeEventListener("touch",levantarAvion)--quitar el listener del touche de levantar avión
        Runtime:removeEventListener("collision", onGlobalCollision)--detener el listener del control de colisiones
    elseif ( phase == "did" ) then--en caso de que ya esté plenamente oculta, 
      if grupoColumnas ~= nil then
        gPrincipal:remove(grupoColumnas) --eliminar el grupo de columna que se quedó en la escena
      end
    end
end
 
--definimos el método destroy porque debemos descargar la música de la memoria
function scene:destroy( event )
    local sceneGroup = self.view --creamos la instancia de la escena creada
    audio.dispose(sonidos["avion"]) --eliminar el sonido de vuelo del avión
    audio.dispose(sonidos["explosion"])--eliminamos de memoria el sonido de la explosicón
    sonidos["avion"]=nil --eliminamos la variable avión
    sonidos["explosion"]=nil --eliminamos la explosión, el valor guardado
end
 
-- asignamos a la escena respectivas, los listeners y efectos respectivos según el flujo de la escena
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene --devolvemos la escena creada
