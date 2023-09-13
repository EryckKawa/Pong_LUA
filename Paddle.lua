--inicializa as tabuas como uma classe no jogo
Paddle = Class{}

function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.dy = 0
end

function Paddle:update(dt)
    if self.dy < 0 then
        --adiciona velocidade negativa * o deltaTime para movimentar para cima
        --limita a movimentação do player na coordenada Y de 0 até a atual
        self.y = math.max(0, self.y + self.dy * dt) 
    else
        --adiciona velocidade positiva * o deltaTime para movimentar para cima junto com a posição atual
        --limita a movimentação do player na coordenada Y da tela virtual até a atual 
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end
end

function Paddle:render()
    --desenha a tabua no meio da tela
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end