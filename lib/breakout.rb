require 'java'
require 'lwjgl.jar'
require 'slick.jar'

java_import org.newdawn.slick.BasicGame
java_import org.newdawn.slick.GameContainer
java_import org.newdawn.slick.Graphics
java_import org.newdawn.slick.Image
java_import org.newdawn.slick.Input
java_import org.newdawn.slick.SlickException

require 'breakout/paddle'
require 'breakout/ball'
require 'breakout/block'

class Breakout
  class Game < BasicGame
    def initialize
      super('RubyBreakout')
    end

    def init(container)
      @bg = Image.new('media/bg.png')
      @ball = Breakout::Ball.new
      @paddle = Breakout::Paddle.new
      @blocks = []
      @score = 0
      5.times do |row_count|
        y = (row_count+1) * 25
        5.times do |cell_count|
          x = (cell_count * 100)
          x += 10 if cell_count == 0

          block = Breakout::Block.new(x, y)
          @blocks.push(block)
        end
      end
    end

    def render(container, graphics)
      @bg.draw(0, 0)
      @ball.draw
      @paddle.draw
      @blocks.each do |b|
        b.draw
      end
      graphics.draw_string("SCORE: #{@score}", container.width - 100, 10)
      graphics.draw_string('RubyPong (ESC to exit)', 8, container.height - 30)
      if game_won?
        graphics.draw_string("YOU WIN!", container.width / 2, container.height / 2)
      end
    end

    def update(container, delta)
      handle_input(container, delta)
      unless game_won?
        @ball.move(delta)
        collision_detection(container, delta)
      end
    end

    def handle_input(container, delta)
      input = container.get_input
      container.exit if input.is_key_down(Input::KEY_ESCAPE)

      if input.is_key_down(Input::KEY_LEFT) || input.is_key_down(Input::KEY_A)
        @paddle.move(-delta) if !@paddle.leaving_the(container, 'left')
      end

      if input.is_key_down(Input::KEY_RIGHT) || input.is_key_down(Input::KEY_D)
        @paddle.move(delta) if !@paddle.leaving_the(container, 'right')
      end
    end

    def collision_detection(container, delta)
      if @ball.leaving_the container
        @ball.bounce
      end

      if @ball.leaving_the container, 'bottom'
        reset
      end

      if @ball.is_colliding_with? @paddle
        @ball.bounce
      end

      @blocks.each do |block|
        if @ball.is_colliding_with? block
          @ball.bounce
          @blocks.delete(block)
          @score += 150
        end
      end
    end

    def reset
      @ball.reset
      @paddle.reset
    end

    def game_won?
      @blocks.empty? 
    end
  end
end
