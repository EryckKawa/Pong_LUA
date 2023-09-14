--AUTHOR>>eRyCkKaWa
--alt + L executa o LOVE.exe

--importação de biblioteca
push = require "push"

--importação de biblioteca
Class = require "class"

--Atribuindo as classes na main
require "Ball"
require "Paddle"

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

SPEED = 200

function love.load()
    --titulo da janela
    love.window.setTitle("Pong")

    --define uma seed para o RNG para garantir que o random sempre será random
    math.randomseed(os.time())

    --define um filtro retrô para as strings e imagens
    love.graphics.setDefaultFilter("nearest", "nearest")

    --carrega uma fonte personalizada para a aplicação do hello pong
    smallFont = love.graphics.newFont("font.ttf", 8)

    --maior fonte para outras aplicações
    largeFont = love.graphics.newFont("font.ttf", 16)

    --carrega a mesma fonte para a aplicação do score
    scoreFont = love.graphics.newFont("font.ttf", 32)

    --cria um objeto fonte que será ativado como padrão
    love.graphics.setFont(smallFont)

    sounds = {
        ["paddle_hit"] = love.audio.newSource("sounds/paddle_hit.wav", "static"),
        ["score"] = love.audio.newSource("sounds/score.wav", "static"),
        ["wall_hit"] = love.audio.newSource("sounds/wall_hit.wav", "static")
    }

    --Cria uma dimensão virtual dentro da dimensão real, causando uma distorção
    push:setupScreen(
        VIRTUAL_WIDTH,
        VIRTUAL_HEIGHT,
        WINDOW_WIDTH,
        WINDOW_HEIGHT,
        {
            fullscreen = false,
            resizable = true,
            vsync = true
        }
    )

    --score players
    player1Score = 0
    player2Score = 0

    --Diz de quem vai ser a vez de sacar
    servingPlayer = 1

    --position Y player
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, 110, 5, 20)

    --posição da bola quando começa
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    --estado do game implementado
    gameState = "start"
end

--responsável pela atualização de frames dentro do jogo
function love.update(dt)
    if gameState == "serve" then
        --responsavel por controlar quem vai sacar
        ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end
    elseif gameState == "play" then
        if ball:collides(player1) then
            --inverte a direção da bola e aumenta sua velocidade
            ball.dx = -ball.dx * 1.03
            --isso evitar que a bola fique presa no player
            ball.x = player1.x + 5

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

            sounds["paddle_hit"]:play()
        end

        if ball:collides(player2) then
            --inverte a direção da bola e aumenta sua velocidade
            ball.dx = -ball.dx * 1.03
            --isso evitar que a bola fique presa no player
            ball.x = player2.x - 4

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

            sounds["paddle_hit"]:play()
        end

        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
            sounds["wall_hit"]:play()
        end

        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy

            sounds["wall_hit"]:play()
        end

        --sistema de pontuação
        if ball.x < 0 then
            servingPlayer = 2
            player2Score = player2Score + 1
            sounds["score"]:play()

            --condição de vitória
            if player2Score == 10 then
                winningPlayer = 2
                gameState = "done"
            else
                gameState = "serve"
                -- coloca a bola no meio da tela
                ball:reset()
            end
        end

        if ball.x > VIRTUAL_WIDTH then
            servingPlayer = 1
            player1Score = player1Score + 1
            sounds["score"]:play()

            if player1Score == 10 then
                winningPlayer = 1
                gameState = "done"
            else
                gameState = "serve"
                ball:reset()
            end
        end
    end

    --movimentação do player 1
    --obs: dy representa o deslocamento vertical do objeto, enquanto dx representa o deslocamento horizontal do objeto
    if love.keyboard.isDown("w") then
        player1.dy = -SPEED
    elseif love.keyboard.isDown("s") then
        player1.dy = SPEED
    else
        --0 para o jogador ficar paradinho
        player1.dy = 0
    end

    --movimentação do player 2
    if love.keyboard.isDown("up") then
        player2.dy = -SPEED
    elseif love.keyboard.isDown("down") then
        player2.dy = SPEED
    else
        --0 para o jogador ficar paradinho
        player2.dy = 0
    end

    if gameState == "play" then
        --atualiza a movimentação da bola e multiplica por deltatime para realizar a movimentação pelos frames
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
end

function love.keypressed(key)
    --fecha a janela
    if key == "escape" then
        love.event.quit()
    --altera os estados do jogo
    elseif key == "enter" or key == "return" then
        if gameState == "start" then
            gameState = "serve"
        elseif gameState == "serve" then
            gameState = "play"
        elseif gameState == "done" then
            gameState = "serve"

            ball:reset()

            -- reseta a pontuação pra zero
            player1Score = 0
            player2Score = 0

            -- decide a vez do jogador dependendo de quem ganhar
            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        end
    end
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.draw()
    --começa a renderização da dimensão virtual
    push:apply("start")

    --coloca uma cor de fundo
    love.graphics.clear(64 / 255, 64 / 255, 64 / 255, 255 / 255)

    --desenha algo na tela e coloca a fonte personalizada
    love.graphics.setFont(smallFont)

    if gameState == "start" then
        love.graphics.printf("WELCOME TO PONG!!!", 0, 10, VIRTUAL_WIDTH, "center")
        love.graphics.printf("Press Enter to Start", 0, 20, VIRTUAL_WIDTH, "center")
    elseif gameState == "serve" then
        love.graphics.setFont(smallFont)
        love.graphics.printf("Player " .. tostring(servingPlayer) .. "'s serve!", 0, 10, VIRTUAL_WIDTH, "center")
        love.graphics.printf("Press Enter to Start", 0, 20, VIRTUAL_WIDTH, "center")
    elseif gameState == "done" then
        love.graphics.setFont(largeFont)
        love.graphics.printf("Player " .. tostring(winningPlayer) .. " wins!", 0, 10, VIRTUAL_WIDTH, "center")
        love.graphics.setFont(smallFont)
        love.graphics.printf("Press Enter to restart!", 0, 30, VIRTUAL_WIDTH, "center")
    end

    --desenha um retangulo na tela com seus atributos
    player1:render()

    --desenha um retangulo na tela com seus atributos
    player2:render()

    --desenha a bola no meio da tela
    ball:render()

    --mostra o FPS
    FPS()

    --encerra a renderização da dimensão virtual
    push:apply("end")
end

function FPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(10 / 255, 0 / 255, 0 / 255, 255 / 255)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
end

function displayScore()
    --mostra a pontuação na tela
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
end
