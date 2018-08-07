-----------------------------------------------------------------------------------------
--
-- Proyecto de Módulo de Programación Lenguaje Lua
-- Autor: Alejandro Díaz Solís
-- Fecha: Octubre de 2017
-- Archivo: main.lua
--
-----------------------------------------------------------------------------------------
--[[
Este archivo presenta datos del autor, además del lenguaje que se ha realizado. Se carga además 
el sonido de todo el juego cuando se acciona el botón de adentrarse en el juego.
]]--
--ocultamos la barra de estado
display.setStatusBar(display.HiddenStatusBar)

--exportamos el modulo composer que nos sirve de gestor de escenas y transiciones 
local composer = require("composer")

--guardamos las dimensiones para el uso en la ubicación de los elementos, además de dimensiones
local W = display.contentWidth
local H = display.contentHeight

--definimos el fondo de la pantalla y el punto de referencia
local fondo = display.newImageRect("imagenes/fondo_final.jpg",W,H)
fondo.anchorX=0
fondo.anchorY=0

--agregamos una imagen que hará de botón para adentrarse dentro del juego y su posicion
local botonJugar = display.newImageRect("imagenes/boton_jugar.png",120,55)
botonJugar.x=W/2
botonJugar.y=H/2+80

--definimos el canal de la música y que esta no se detenga. Se reproduzca indefinidamente
local opcionesMusica =
{
    channel = 1,
    loops = -1,
}

--definimos la música de fondo, como stream, porque sólo será reproducida una vez
local musicaFondo = audio.loadStream("sonido/fondo_musical.wav")

--definimos la función de jugar, de entrar directamente en el juego
function jugar(event)
  --ir a la escena inicio.lua
  composer.gotoScene("inicio")
  --definir el volumen del canal 1, que es la canción de fondo
  audio.setVolume( 0.1, { channel=1 } )
  --reproducir la canción del fondo del juego
  audio.play(musicaFondo, opcionesMusica)
  --eliminamos el fondo
  fondo:removeSelf()
  --eliminamos el botón
  botonJugar:removeSelf()
end

--agregamos al botón el listener con el event tap
botonJugar:addEventListener("tap",jugar)

