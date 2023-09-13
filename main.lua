--AUTHOR>>eRyCkKaWa
--alt + L executa o LOVE.exe

--importação de biblioteca
push = require 'push'

--importação de biblioteca
Class = require 'class'

--Atribuindo as classes na main
require 'Ball'
require 'Paddle'

WINDOW_WIDTH = 1280 
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

SPEED = 200

function love.load()
    --define uma seed para o RNG para garantir que o random sempre será random
    math.randomseed(os.time())

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
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, 110, 5, 20) 

    --posição da bola quando começa
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    --estado do game implementado
    gameState = 'start'
end

--responsável pela atualização de frames dentro do jogo
function love.update(dt)
    --movimentação do player 1
    --obs: dy representa o deslocamento vertical do objeto, enquanto dx representa o deslocamento horizontal do objeto
    if love.keyboard.isDown('w') then
        player1.dy = -SPEED

    elseif  love.keyboard.isDown('s') then
        player1.dy = SPEED

    else
        --0 para o jogador ficar paradinho
        player1.dy = 0

    end

    --movimentação do player 2
    if love.keyboard.isDown('up') then
        player2.dy = -SPEED

    elseif  love.keyboard.isDown('down') then
        player2.dy = SPEED

    else
        --0 para o jogador ficar paradinho
        player2.dy = 0

    end

    if gameState =='play' then
        --atualiza a movimentação da bola e multiplica por deltatime para realizar a movimentação pelos frames
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
end

function love.keypressed(key)
    --fecha a janela
    if key == 'escape' then
        love.event.quit()

    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'

            --reseta a posição e velocidade da bola
            ball:reset()
        end
    end
end


function love.draw()
    --começa a renderização da dimensão virtual
    push:apply('start')

    --coloca uma cor de fundo
    love.graphics.clear(64/255, 64/255, 64/255, 255/255)

    --desenha algo na tela e coloca a fonte personalizada
    love.graphics.setFont(smallFont)

    if gameState == 'start' then
        love.graphics.printf('Press Enter to Start',0, 20, VIRTUAL_WIDTH, 'center')
    else 
        love.graphics.printf('Make your points',0, 20, VIRTUAL_WIDTH, 'center')
    end
    --seta a fonte do score e mostra ele na tela
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT/3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT/3)

    --desenha um retangulo na tela com seus atributos
    player1:render()

    --desenha um retangulo na tela com seus atributos
    player2:render()

    --desenha a bola no meio da tela
    ball:render()

    --encerra a renderização da dimensão virtual
    push:apply('end')
end