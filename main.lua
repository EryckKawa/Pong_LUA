--AUTHOR>>eRyCkKaWa
--alt + L executa o LOVE.exe

push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

SPEED = 200

function love.load()
    --define um filtro retrô para as strings e imagens
    love.graphics.setDefaultFilter('nearest','nearest')

    --carrega uma fonte personalizada para a aplicação do hello pong
    smallFont = love.graphics.newFont('font.ttf', 8)

    --carrega a mesma fonte para a aplicação do score
    scoreFont = love.graphics.newFont('font.ttf', 32)

    --cria um objeto fonte que será ativado como padrão
    love.graphics.setFont(smallFont)

    --Cria uma dimensão virtual dentro da dimensão real, causando uma distorção
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    --score players
    player1Score = 0
    player2Score = 0

    --position Y player
    player1Y = 30
    player2Y = 110 
end

--responsável pela atualização de frames dentro do jogo
function love.update(dt)
--movimentação do player 1
    if love.keyboard.isDown('w') then
        --adiciona velocidade negativa * o deltaTime para movimentar para cima
        player1Y = player1Y + -SPEED * dt 

    elseif  love.keyboard.isDown('s') then
        --adiciona velocidade positiva * o deltaTime para movimentar para cima
        player1Y = player1Y + SPEED * dt
    end

    --movimentação do player 2
    if love.keyboard.isDown('up') then
        --adiciona velocidade negativa * o deltaTime para movimentar para cima
        player2Y = player2Y + -SPEED * dt 

    elseif  love.keyboard.isDown('down') then
        --adiciona velocidade positiva * o deltaTime para movimentar para cima
        player2Y = player2Y + SPEED * dt
    end
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

    --coloca uma cor de fundo
    love.graphics.clear(64/255, 64/255, 64/255, 255/255)

    --desenha algo na tela e coloca a fonte personalizada
    love.graphics.setFont(smallFont)
    love.graphics.printf('Hello Pong',0, 20, VIRTUAL_WIDTH, 'center')

    --seta a fonte do score e mostra ele na tela
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT/3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT/3)

    --desenha um retangulo na tela com seus atributos
    love.graphics.rectangle('fill', 10, player1Y, 5, 20 )

    --desenha um retangulo na tela com seus atributos
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)

    --desenha a bola no meio da tela
    love.graphics.rectangle('fill', VIRTUAL_WIDTH/2 -2, VIRTUAL_HEIGHT/2 - 2 , 4, 4)

    --encerra a renderização da dimensão virtual
    push:apply('end')
end