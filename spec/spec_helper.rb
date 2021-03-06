$: << "../lib"
require 'breakout'

shared_examples 'a paddle movement key' do |direction|
  context 'paddle is within container boundaries' do
    it "should move the paddle to the #{direction}" do
      container.stub(:get_input) { key }
      distance = (direction == 'right' ? 4 : -4)
      subject.instance_variable_get(:@paddle).stub(:leaving_the) { false }
      subject.instance_variable_get(:@paddle).should_receive(:move).with(distance)
      subject.handle_input(container, 4)
    end
  end

  context 'paddle is outside the container boundaries' do
    it "should not move the paddle to the #{direction}" do
      subject.instance_variable_get(:@paddle).stub(:leaving_the) { true }
      subject.instance_variable_get(:@paddle).should_not_receive(:move)
      subject.handle_input(container, 4)
    end
  end
end
