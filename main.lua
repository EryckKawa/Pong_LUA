--AUTHOR>>eRyCkKaWa
--alt + L executa o LOVE.exe

push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

function love.load()
    --define um filtro retrô para as strings e imagens
    love.graphics.setDefaultFilter('nearest','nearest')
    --Cria uma dimensão virtual dentro da dimensão real, causando uma distorção
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end

function love.keypressed(key)
    --fecha a janela
    if key == 'escape' then
        love.event.quit()
    end
end


function love.draw()
    --começa a renderização da dimensão virtual
    push:apply('start')
    --desenha algo na tela
    love.graphics.printf('Hello Pong', 0, VIRTUAL_HEIGHT / 2 - 6, VIRTUAL_WIDTH, 'center')
    --encerra a renderização da dimensão virtual
    push:apply('end')
end