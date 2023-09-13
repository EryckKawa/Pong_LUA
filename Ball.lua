--inicializa ball como uma classe no jogo
Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    --delta time para coordenadas da bola e realizar sua atualização
    self.dx = math.random(2) == 1 and -100 or 100
    self.dy = math.random(-50, 50)
end

function Ball:reset()
    --velocidade e posição da bola quando começa    
    self.x = VIRTUAL_WIDTH/ 2 - 2
    self.y = VIRTUAL_HEIGHT/ 2 - 2

    --delta time para coordenadas da bola e realizar sua atualização
    --modo de fazer uma operação ternária
    self.dx = math.random(2) == 1 and -100 or 100
    self.dy = math.random(-50, 50)
end

function Ball:update(dt)
    --atualiza a movimentação da bola e multiplica por deltatime para realizar a movimentação pelos frames
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render()
    --desenha a bola no meio da tela
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end